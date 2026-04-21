# Nowiiie Rumble Framework 🚀

A modern, scalable, and AI-ready Roblox game framework built on top of [Rojo](https://rojo.space/). This framework implements strict Server-Client separation and centralized Remote Event management, heavily optimized for "Vibe Coding" alongside AI Agents.

## 🌟 Key Features

* **Rojo Powered:** Write your code in your favorite IDE (VS Code) and sync seamlessly to Roblox Studio.
* **Strict Architecture:** Clear boundaries between Server (`Services`), Client (`Controllers`/`UI`), and Shared logic (`Modules`).
* **Centralized Remotes:** Say goodbye to chaotic `Instance.new("RemoteEvent")` scattered everywhere. All network traffic is defined and spawned centrally in `Remotes.luau`.
* **AI-Agent Ready:** Includes built-in `AGENT_CONTEXT.md` and `ARCHITECTURE.md` specifically designed to guide AI coding assistants on your project's strict rules, letting you generate production-ready code rapidly without hallucinated bad practices.
* **Built-in Interaction System:** Ships with a robust 2-step verification Interaction system out-of-the-box, securing client requests against exploiters while offering smooth UX rendering dynamically.

## 📁 Directory Structure

```text
nowiiie-rumble-game/
├── default.project.json
├── AGENT_CONTEXT.md      # AI guardrails & context guidelines
├── ARCHITECTURE.md       # Technical explanation of the codebase
└── src/
    ├── client/           # Mapped to StarterPlayerScripts
    │   ├── Controllers/  # Client-side core logic
    │   └── UI/           # Client-side ScreenGui visual logic
    ├── server/           # Mapped to ServerScriptService
    │   └── Services/     # Server-side authoritative logic
    └── shared/           # Mapped to ReplicatedStorage
        ├── Modules/      # Reusable utilities and states
        └── Remotes/      # Network Remote Event definitions
```

## 🚀 Getting Started

### Prerequisites
* [Roblox Studio](https://create.roblox.com/)
* [Rojo](https://rojo.space/) CLI and Roblox Studio Plugin.
* Visual Studio Code (or your preferred editor).

### Installation
1. Clone this repository to your local machine.
2. Open the directory in your terminal and ensure you are in the root folder.
3. Run `rojo serve` to start the local sync server.
4. In Roblox Studio, open the Rojo plugin window and hit **Connect**.
5. Once synced, click **Play** to test the default Interaction workflow.

## 🤖 Vibe Coding & AI Integration
To use this with an AI assistant (like ChatGPT, Cursor, Copilot):
1. Provide the AI with the contents of `AGENT_CONTEXT.md` and `ARCHITECTURE.md`.
2. Ask the AI to build features by simply instructing: *"Create a new `CombatService` in the server and `CombatController` in the client. Add necessary remotes."*
3. The AI will perfectly adhere to the structure without hallucinatory Remote allocations.

## 📜 License
Distributed under the MIT License. See `LICENSE` for more information.
