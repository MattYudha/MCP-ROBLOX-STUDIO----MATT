# Architecture: Nowiiie Rumble Game

## Overview
This game uses a modern, modular Roblox architecture synchronized via **Rojo**. It divides the game logic strictly into Server (`src/server`), Client (`src/client`), and Shared (`src/shared`) boundaries.

## Core Layers
1. **Server Services (`src/server/Services/`)**
   - Handles the core gameplay logic, data saving, security, and game state.
   - Example entry point: `Main.server.luau`.
   - Planned services: `CombatService`, `PlayerDataService`.
   
2. **Client Controllers (`src/client/Controllers/`)**
   - Handles player input, UI rendering, camera, and receiving replicate states from the server.
   - Example entry point: `Main.client.luau`.
   - Cannot make authoritative decisions; relies on Server via Remotes.

3. **Shared Context (`src/shared/`)**
   - **Modules (`Modules/`):** Contains helpers, constants, configuration tables, and math utilities accessible by both the Server and Client.
   - **Remotes (`Remotes/`):** A centralized `Remotes.luau` module that strictly definitions and manages the instantiation of `RemoteEvent` and `RemoteFunction` objects. 
     - Prevents "race conditions" where Client looks for Remotes before the Server generates them.

## Communication Flow (Remotes)
Instead of manually creating single RemoteEvents in Studio, we define them via code in `Remotes.luau`:
```lua
return {
    TestEvent = getRemoteEvent("TestEvent"),
    -- New remotes go here
}
```
* **Client** imports `Remotes.luau` and calls `:FireServer()` or listens via `.OnClientEvent`.
* **Server** imports `Remotes.luau` and listens via `.OnServerEvent` or calls `:FireClient()`.

## Best Practices
- **Scaling:** As the game expands, create modular scripts (e.g., `CombatService.luau`), which are then required and started by `Main.server.luau`.
- **Initialization:** Let the `Main` script be the central bootstrapper that requires all child Services/Controllers and fires their `.Start()` or `.Init()` lifecycle functions.
