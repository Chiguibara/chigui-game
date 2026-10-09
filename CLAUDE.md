# Claude Code Project Instructions

This file holds the project's working principles and confirmed decisions; anything not listed here is a hypothesis or an open question until the user confirms it. How-to details live in the skills under `.claude/skills/`, and tuning values live in the code.

## Confirmed decisions
- Engine: Flutter + Dart, with everything (Chigüi, accessories, sprites) drawn in code; no game engine. Flame only if a future minigame truly needs a game loop, and only inside it.
- Platforms: children play on the web first, embedded in https://chiguibara.es/juego/ (mostly from PCs). A Windows build may follow; Android comes after. iOS is deferred (no macOS available). Only the `web` platform exists until the others are added.
- Tooling runs in Docker through the `Makefile`. Do not require Flutter, SDKs, or other toolchains installed on the host. Windows builds will come from a Windows CI runner.
- Responsive layout with one breakpoint: narrow or portrait screens use the phone layout (what Android will use); wide landscape screens (PCs) use a wide layout. Every screen must work in both. Touch-sized targets (≥48 dp); nothing may depend on hover, right-click, or keyboard shortcuts.
- Android: application ID `es.chiguibara.chigui_game`; the app must work fully offline and its release build must not request the INTERNET permission. The web version only needs a connection to load.
- Pet needs (hunger, affection, fun) decay gently, never to zero, and never block actions or harm Chigüi on their own.
- Daily routine (mealtimes, potty, bedtime, sickness and a free, cute vet) teaches responsibility, but only outside school hours and never at night. Consequences stay mild and curable, nothing is permanent, and time away counts only up to a cap, pausing after a day without playing. Times and thresholds live in `lib/game/routine.dart` and `lib/game/rules.dart`.
- Coins come only from playing (minigame, walks) and buy accessories and stickers in the shop; coins are never sold. Seasonal items return every year and are never sold with urgency. Catalog, prices, and season dates live in `lib/game/catalog.dart`.
- Real money: only fixed-price accessory packs, priced in euros, through the platform's own store (Google Play Billing on Android; App Store in-app purchases if an iPhone app comes, where Apple does not allow Apple Pay for digital items), with parents' approval through their store account (Family Link / Ask to Buy). No other payment providers, no purchases on the web or Windows, and paid content is only cosmetic (never needs, cures, or skipping the routine). Code: `lib/store/` behind the `PackStore` interface; packs in `lib/game/catalog.dart`. See the `progression-monetization` skill.
- No server for restoring on a new device: packs belong to the store account and are synced from the store at start; the save (progress, coins) travels with the platform's own backup (Android Auto Backup, iCloud), which must stay enabled.
- Walks turn real steps (or tapped feet on PCs) into fun and coins, capped per day. Only rewards: no penalties for not walking and no weight or body changes. On phones' browsers the game listens to the motion sensor from the start (iPhone asks on the first tap) and opens the walk by itself after about 10 m of walking on the home screen; tuning lives in `lib/walk/step_watcher.dart`.
- All game audio is FLAC; players can mute it (see the `sound-effects` skill).
- Persistence goes through `GameRepository` (domain types only); today it is JSON in `shared_preferences`, and moving to SQLite with drift must only need a new implementation. Saves are local only. An event log keeps the last 90 days.
- Analytics: only page-level analytics on the website hosting the game (behind its consent banner), to know whether children play. The game itself sends no tracking or personal data. In Spain, consent for under-14s must come from a parent; review the banner with whoever handles legal.
- Repository is private and all rights reserved (see `LICENSE`). Do not add open-source licenses or third-party art or audio without approval.

## Open questions
- Rest of the MVP scope beyond what is built.
- Needs display (provisional, validate in playtests): mainly Chigüi's mood with small secondary meters.
- When the Windows build is needed, and how it reaches the children.
- Who produces the final art and with which tool.
- Target player age (affects store policies for children before the Android release).

## Working principles
- Inspect the repository and its configuration before proposing changes.
- Keep scope small and prioritize a playable prototype.
- Do not add a backend, accounts, invasive analytics, or commerce integrations without a demonstrated need; payments only as decided above.
- Avoid premature abstractions and unnecessary dependencies; use the newest versions that resolve with the pinned Flutter SDK.
- Respect Chigüibara's visual identity: handmade-feeling kawaii, geeky, and playful; not generic or excessively childish.
- Consequences for neglect stay mild, curable, and capped; no guilt-tripping copy. Never pressure players to spend.
- Distinguish confirmed decisions, hypotheses, and open questions.
- Code and technical documentation in English. Player-facing text is always localized (English first, Spanish supported); see the `localization-copy` skill.

## Workflow
1. Inspect the project first.
2. Briefly summarize what exists and what decisions remain open.
3. If asked to analyze, do not implement.
4. If implementation is approved, make the smallest coherent change and run available checks.
5. Use only the agents and skills relevant to the task.

## Agents and skills
- Agents: game design `.claude/agents/game-designer.md`, technical architecture `.claude/agents/game-architect.md`, review `.claude/agents/reviewer.md`.
- Skills in `.claude/skills/`: `game-design`, `progression-monetization`, `mobile-architecture` (including adding Android), `2d-art-pipeline` (code-drawn art), `sound-effects`, `localization-copy`, and `mvp-qa` (including visual checks).
