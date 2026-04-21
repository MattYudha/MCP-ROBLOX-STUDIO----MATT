# NowiiieRumble Project Context

## Architecture
- Source of truth is local files, synced to Roblox Studio using Rojo.
- Server code lives in `src/server`
- Client code lives in `src/client`
- Shared modules live in `src/shared`

## Folder Conventions
- `Services` = server-side systems
- `Controllers` = client-side systems
- `Modules` = shared reusable modules
- `Remotes` = remote communication definitions

## Rules
- Never trust client input for important game logic
- Server validates all gameplay actions
- Shared code should stay lightweight and safe for both server and client
- New systems should follow modular architecture
