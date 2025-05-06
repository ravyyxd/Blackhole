# Black Hole Script for Roblox

## Overview
This Roblox server script creates a **black hole** in the game that:
- Pulls all `BasePart` objects (including anchored parts) and players towards it.
- Grows over time and when absorbing objects.
- Traps players in a "dark zone" when they get too close.
- Allows players to move the black hole using a telekinesis tool.

The black hole has visual effects (swirling animation and particle emitter) and immersive mechanics, such as trapping players with a blacked-out screen.

## Installation
1. **Open Roblox Studio** and load your game.
2. In the **Explorer**, navigate to `ServerScriptService`.
3. Create a new **Script** and name it (e.g., `BlackHoleScript`).
4. Copy and paste the provided Lua script into the script editor.
5. Save and test the game in Roblox Studio or publish it to Roblox.

## Configuration
The script includes several configurable parameters at the top. Adjust these to customize the black hole's behavior:

| Parameter           | Description                                      | Default Value |
|---------------------|--------------------------------------------------|---------------|
| `BLACK_HOLE_SIZE`   | Initial size of the black hole (in studs).       | 10            |
| `GROWTH_RATE`       | Size increase per second (in studs).             | 0.1           |
| `ITEM_GROWTH`       | Size increase per absorbed object (in studs).    | 2             |
| `PULL_FORCE`        | Maximum distance for pulling objects/players.    | 50            |
| `TRAP_DISTANCE`     | Distance at which players are trapped.           | 5             |
| `DARK_ZONE_SIZE`    | Size of the underground dark zone (in studs).    | 50            |

### Example
To make the black hole pull objects from farther away, increase `PULL_FORCE`:
```lua
local PULL_FORCE = 100
```

## Usage
1. **Black Hole Mechanics**:
   - The black hole spawns at `(0, 50, 0)` in the air.
   - It pulls all `BasePart` objects (anchored or unanchored) and players within `PULL_FORCE` studs.
   - Objects and players within `TRAP_DISTANCE` are absorbed (objects are destroyed, players are trapped).
   - The black hole grows over time (`GROWTH_RATE`) and when absorbing objects (`ITEM_GROWTH`).

2. **Dark Zone**:
   - Players trapped by the black hole are teleported to an underground dark zone at `(0, -100, 0)`.
   - Their UI is disabled, and their screen turns black.
   - Trapped players cannot escape, even by resetting their character.

3. **Telekinesis Tool**:
   - Each player receives a tool named `Тест` (or `Telekinesis` for new players) in their backpack.
   - Activate the tool by clicking to move the black hole to the mouse's hit position.
   - The black hole moves smoothly using a tween animation.

## Performance Notes
- **Anchored Parts**: The script pulls all `BasePart` objects, including anchored ones, which may affect critical map elements. To exclude specific parts, add a `StringValue` named `NoPull` to those parts and modify the script to check for it:
  ```lua
  if part:IsA("BasePart") and part ~= blackHole and part ~= darkZone and not part:FindFirstChild("NoPull") then
  ```
- **Optimization**: Pulling many objects can cause lag. Consider limiting the pull radius (`PULL_FORCE`) or the number of objects processed per frame.
- **Testing**: Test in a small environment first to ensure performance and gameplay balance.

## Troubleshooting
- **Black hole not moving**: Ensure the telekinesis tool is equipped and the mouse is clicking on a valid surface.
- **Performance issues**: Reduce `PULL_FORCE` or add a `NoPull` tag to non-essential anchored parts.
- **Players not trapped**: Verify `TRAP_DISTANCE` is set appropriately and the dark zone is correctly positioned.

## Future Improvements
- Add a filter to exclude specific parts (e.g., map structures) from being pulled.
- Implement a particle effect for absorbed anchored parts to enhance visuals.
- Add a cooldown or limit to the telekinesis tool to balance gameplay.

For questions or contributions, contact the script creator or modify the script as needed.
