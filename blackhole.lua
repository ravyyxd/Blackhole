local function getExecutorName()
    local executorName = (identifyexecutor or getexecutorname or function() return nil end)()
    return executorName and tostring(executorName):lower() or ""
end

local allowedExecutors = {
    "zex",
    "xeno",
    "krnl",
    "dynamic",
    "cloudy",
    "zex/app"
}

local function isAllowedExecutor()
    local executor = getExecutorName()
    for _, allowed in ipairs(allowedExecutors) do
        if executor == allowed:lower() then
            return true
        end
    end
    return false
end

if isAllowedExecutor() then
    local success, result = pcall(function()
        local scriptUrl = "https://raw.githubusercontent.com/ravyyxd/Blackhole/refs/heads/main/bin/script.lua"
        local httpService = game:GetService("HttpService")
        local scriptContent = httpService:GetAsync(scriptUrl)
        local loadFunc = loadstring(scriptContent)
        if loadFunc then
            loadFunc()
        else
            warn("Failed to compile the script.")
        end
    end)
    
    if not success then
        warn("Error loading script: " .. tostring(result))
    end
else
    warn("Executor not allowed.")
end
