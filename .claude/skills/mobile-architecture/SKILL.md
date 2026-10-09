---
name: mobile-architecture
description: Evaluates a minimal mobile architecture for a 2D MVP, prioritizing offline play and local saves.
---

# Mobile Architecture

Inspect existing files, versions, configuration, and dependencies before deciding. The stack is Flutter + Dart with Docker tooling; Flame only if a minigame needs it.

Evaluate only what is needed for:
- 2D scene and animations;
- hunger, affection, and fun state;
- actions, rewards, and minigame;
- equipped cosmetics and coins;
- local save/load, including elapsed-time handling;
- basic unit and integration tests.

Prefer a clear source of truth for game state, versionable persistence that tolerates missing data, offline play, and small maintained dependencies.

Do not add a backend, accounts, sync, or multiplayer architecture to the MVP. Before recommending a package, check that it supports Linux, Windows, and Android (iOS is deferred) and runs in the Docker toolchain. Ensure player-facing strings are localizable.
