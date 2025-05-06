-- Server Script (Place in ServerScriptService)
-- Or u can use this with exploits

local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- Configuration
local BLACK_HOLE_SIZE = 10 -- Initial size
local GROWTH_RATE = 0.1 -- Size increase per second
local ITEM_GROWTH = 2 -- Size increase per absorbed item
local PULL_FORCE = 50 -- Force of the black hole pull
local TRAP_DISTANCE = 5 -- Distance at which players get trapped
local DARK_ZONE_SIZE = 50 -- Size of the dark zone

-- Black hole storage
local blackHole = nil
local darkZone = nil
local trappedPlayers = {} -- Table to track trapped players
local originalSpawnLocations = {} -- Store original SpawnLocations

-- Function to create the black hole
local function createBlackHole()
	blackHole = Instance.new("Part")
	blackHole.Size = Vector3.new(BLACK_HOLE_SIZE, BLACK_HOLE_SIZE, BLACK_HOLE_SIZE)
	blackHole.Position = Vector3.new(0, 50, 0) -- Spawn in air
	blackHole.Anchored = true
	blackHole.CanCollide = false
	blackHole.Shape = Enum.PartType.Ball
	blackHole.BrickColor = BrickColor.new("Really black")
	blackHole.Material = Enum.Material.Neon
	blackHole.Parent = workspace
	
	-- Add a swirling animation
	local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
	local swirlGoal = { CFrame = blackHole.CFrame * CFrame.Angles(0, math.rad(360), 0) }
	local swirlTween = TweenService:Create(blackHole, tweenInfo, swirlGoal)
	swirlTween:Play()
	
	-- Add a particle effect to simulate a black hole
	local emitter = Instance.new("ParticleEmitter")
	emitter.Texture = "rbxassetid://243098098" -- Black swirl texture
	emitter.Size = NumberSequence.new(5)
	emitter.Rate = 50
	emitter.Lifetime = NumberRange.new(1, 2)
	emitter.Speed = NumberRange.new(10)
	emitter.Parent = blackHole
end

-- Function to create the dark zone
local function createDarkZone()
	darkZone = Instance.new("Part")
	darkZone.Size = Vector3.new(DARK_ZONE_SIZE, DARK_ZONE_SIZE, DARK_ZONE_SIZE)
	darkZone.Position = Vector3.new(0, -100, 0) -- Underground
	darkZone.Anchored = true
	darkZone.CanCollide = true
	darkZone.Transparency = 0.9
	darkZone.BrickColor = BrickColor.new("Really black")
	darkZone.Parent = workspace
	
	-- Create a SpawnLocation in the dark zone
	local darkSpawn = Instance.new("SpawnLocation")
	darkSpawn.Size = Vector3.new(5, 0.2, 5)
	darkSpawn.Position = darkZone.Position + Vector3.new(0, 5, 0)
	darkSpawn.Anchored = true
	darkSpawn.Parent = darkZone
end

-- Function to trap a player in the dark zone
local function trapPlayer(player)
	if not trappedPlayers[player] and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		trappedPlayers[player] = true
		local character = player.Character
		local humanoidRootPart = character.HumanoidRootPart
		
		-- Move player to dark zone
		humanoidRootPart.CFrame = CFrame.new(darkZone.Position + Vector3.new(0, 10, 0))
		
		-- Disable all UI for the player
		local playerGui = player:FindFirstChild("PlayerGui")
		if playerGui then
			for _, gui in pairs(playerGui:GetChildren()) do
				gui.Enabled = false
			end
		end
		
		-- Set screen to black
		local screenGui = Instance.new("ScreenGui")
		screenGui.IgnoreGuiInset = true
		local blackFrame = Instance.new("Frame")
		blackFrame.Size = UDim2.new(1, 0, 1, 0)
		blackFrame.BackgroundColor3 = Color3.new(0, 0, 0)
		blackFrame.BackgroundTransparency = 0
		blackFrame.Parent = screenGui
		screenGui.Parent = playerGui
		
		-- Prevent reset from escaping
		player.CharacterAdded:Connect(function(newCharacter)
			if trappedPlayers[player] then
				wait() -- Wait for character to fully load
				newCharacter:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(darkZone.Position + Vector3.new(0, 10, 0))
			end
		end)
	end
end

-- Function to handle telekinesis (move/throw black hole)
local function setupTelekinesis()
	for _, player in pairs(Players:GetPlayers()) do
		local tool = Instance.new("Tool")
		tool.Name = "Test"
		tool.RequiresHandle = false
		tool.Parent = player.Backpack
		
		tool.Activated:Connect(function()
			if blackHole then
				local mouse = player:GetMouse()
				local targetPos = mouse.Hit.Position
				local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
				local moveGoal = { Position = targetPos }
				local moveTween = TweenService:Create(blackHole, tweenInfo, moveGoal)
				moveTween:Play()
			end
		end)
	end
	
	Players.PlayerAdded:Connect(function(player)
		local tool = Instance.new("Tool")
		tool.Name = "Test"
		tool.RequiresHandle = false
		tool.Parent = player.Backpack
		
		tool.Activated:Connect(function()
			if blackHole then
				local mouse = player:GetMouse()
				local targetPos = mouse.Hit.Position
				local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
				local moveGoal = { Position = targetPos }
				local moveTween = TweenService:Create(blackHole, tweenInfo, moveGoal)
				moveTween:Play()
			end
		end)
	end)
end

-- Function to pull objects and players
local function pullObjects()
	while blackHole do
		-- Grow black hole over time
		blackHole.Size = blackHole.Size + Vector3.new(GROWTH_RATE, GROWTH_RATE, GROWTH_RATE) / 10
		
		-- Pull players
		for _, player in pairs(Players:GetPlayers()) do
			if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and not trappedPlayers[player] then
				local humanoidRootPart = player.Character.HumanoidRootPart
				local distance = (blackHole.Position - humanoidRootPart.Position).Magnitude
				
				if distance < TRAP_DISTANCE then
					trapPlayer(player)
				elseif distance < PULL_FORCE then
					local direction = (blackHole.Position - humanoidRootPart.Position).Unit
					humanoidRootPart.Velocity = direction * (PULL_FORCE - distance)
				end
			end
		end
		
		-- Pull workspace objects (including anchored parts)
		for _, part in pairs(workspace:GetChildren()) do
			if part:IsA("BasePart") and part ~= blackHole and part ~= darkZone then
				local distance = (blackHole.Position - part.Position).Magnitude
				if distance < PULL_FORCE then
					local direction = (blackHole.Position - part.Position).Unit
					if part.Anchored then
						-- Move anchored parts by updating CFrame
						local newPos = part.Position + direction * (PULL_FORCE - distance) * 0.05 -- Adjust speed with multiplier
						part.CFrame = CFrame.new(newPos)
					else
						-- Move unanchored parts with velocity
						part.Velocity = direction * (PULL_FORCE - distance)
					end
					if distance < TRAP_DISTANCE then
						blackHole.Size = blackHole.Size + Vector3.new(ITEM_GROWTH, ITEM_GROWTH, ITEM_GROWTH) / 10
						Debris:AddItem(part, 0) -- Absorb the part
					end
				end
			end
		end
		
		RunService.Heartbeat:Wait()
	end
end

-- Initialize black hole and dark zone
createBlackHole()
createDarkZone()
setupTelekinesis()

-- Start pulling objects
coroutine.wrap(pullObjects)()

-- Store original SpawnLocations and modify respawn behavior
for _, spawn in pairs(workspace:GetChildren()) do
	if spawn:IsA("SpawnLocation") then
		originalSpawnLocations[spawn] = true
	end
end

-- Handle player respawn to keep them in dark zone
Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		if trappedPlayers[player] then
			wait() -- Wait for character to fully load
			character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(darkZone.Position + Vector3.new(0, 10, 0))
		end
	end)
end)
