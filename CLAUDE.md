# Claude Code Project Instructions

This file holds the project's working principles and confirmed decisions; anything not listed here is a hypothesis or an open question until the user confirms it. How-to details live in the skills under `.claude/skills/`, and tuning values live in the code.

## Confirmed decisions
- Engine: Flutter + Dart, with everything (Chigüi, accessories, sprites) drawn in code; no game engine. Flame only if a future minigame truly needs a game loop, and only inside it.
- Platforms: children play on the web first (mostly from PCs): the game is its own static Cloudflare Worker at https://juego.chiguibara.es, deployed by GitHub Actions when a version tag (`v*`) is pushed (pushes to `main` are only checked), and embedded with an iframe in https://chiguibara.es/juego/ (the Astro website deploys separately). The Android app goes to Google Play from the same workflow: `v0.2.0` tags go to production (after Google's review), `v0.2.0-rc.1` tags only to closed testing and `v0.2.0-beta.1` tags only to internal testing (neither deploys the web). It is signed with the upload key from GitHub secrets; Google holds the app signing key (Play App Signing). A Windows build may follow. iOS is deferred until there is an Apple Developer account and a macOS runner.
- Tooling runs in Docker through the `Makefile`. Do not require Flutter, SDKs, or other toolchains installed on the host. Windows builds will come from a Windows CI runner.
- Responsive layout with one breakpoint: narrow or portrait screens use the phone layout (what Android will use); wide landscape screens (PCs) use a wide layout. Every screen must work in both. Touch-sized targets (≥48 dp); nothing may depend on hover, right-click, or keyboard shortcuts.
- Android: application ID `es.chiguibara.chigui_game`; the app must work fully offline and its release build must not request the INTERNET permission. The web version only needs a connection to load.
- Class time (weekday mornings outside summer and Christmas holidays; hours and holidays in `lib/game/routine.dart`): the minigame waits until after school and Chigüi is shown studying and says so. Feeding, the shop, and walks stay available.
- Pet needs (hunger, affection, fun) decay gently, never to zero, and never block actions or harm Chigüi on their own.
- Daily routine (mealtimes, potty, bedtime, sickness and a free, cute vet) teaches responsibility, but only outside school hours and never at night. Consequences stay mild and curable, nothing is permanent, and time away counts only up to a cap, pausing after a day without playing. At night (from bedtime until waking up) Chigüi falls asleep alone, with no bedtime button and no penalty, but sleeping never blocks any action: cuddles, playing, walks, or feeding wake Chigüi up (cuddles with a yawn), and Chigüi falls asleep again an hour after the last interaction. Times and thresholds live in `lib/game/routine.dart` and `lib/game/rules.dart`.
- Coins come only from playing (minigame, walks) and buy accessories and stickers in the shop; coins are never sold. Seasonal items return every year and are never sold with urgency. Catalog, prices, and season dates live in `lib/game/catalog.dart`.
- Real money: only fixed-price accessory packs, priced in euros, through the platform's own store (Google Play Billing on Android; App Store in-app purchases if an iPhone app comes, where Apple does not allow Apple Pay for digital items), with parents' approval through their store account (Family Link / Ask to Buy). No other payment providers, no purchases on the web or Windows, and paid content is only cosmetic (never needs, cures, or skipping the routine). Code: `lib/store/` behind the `PackStore` interface; packs in `lib/game/catalog.dart`. See the `progression-monetization` skill.
- No server for restoring on a new device: packs belong to the store account and are synced from the store at start; the save (progress, coins) travels with the platform's own backup (Android Auto Backup, iCloud), which must stay enabled.
- Walks turn real steps (or tapped feet) into fun and coins, capped per day; tapped feet count for only a few walks a day so they are for playing while sitting still, not for farming coins. Four minigames (fruit catch, memory, hide-and-seek, bath time, under `lib/minigame/`) share one daily coin limit and pay little, so the shop lasts; rates and the limit live in `lib/game/rules.dart`, and mistakes never cost anything. After the limit they can still be played (and still raise fun), they just give no coins until tomorrow. Never block playing or tie it to walking. Only rewards: no penalties for not walking and no weight or body changes. On phones' browsers the game listens to the motion sensor from the start (iPhone asks on the first tap) and opens the walk by itself after about 10 m of walking on the home screen. In the Android app, the system step counter (`MainActivity.kt` + `lib/walk/pedometer.dart`, "physical activity" permission) counts every step, also with the app closed, and opens the walk after about 100 m. Tuning lives in `lib/walk/step_watcher.dart` and `lib/walk/pedometer.dart`.
- All game audio is FLAC; players can mute it (see the `sound-effects` skill).
- Notifications: none on the web (closed-page notifications would need Web Push and a server). In the Android app, local notifications (`lib/notify/`) at mealtimes and potty urges, on by default: the system asks for permission once on the first launch, and a "no" (or blocking them later in the phone's settings) turns them off; the bell on the home screen turns them on (asking again) or off. Scheduled only while the game is in the background, never in class or at night, stopping a day after the game was last open, gentle copy.
- Persistence goes through `GameRepository` (domain types only); today it is JSON in `shared_preferences`, and moving to SQLite with drift must only need a new implementation. Saves are local only. An event log keeps the last 90 days. JSON stays for production; switch to SQLite only for a concrete need (e.g. a history screen with queries).
- Audience: all ages, content for PEGI 3. On Google Play every age group is selected, so the app is under the Families policy: no ads, no data or identifiers leave the device, child-appropriate content, and paid packs only with a grown-up's approval through the store.
- Analytics: only page-level analytics on the website hosting the game (behind its consent banner), to know whether children play. The game itself sends no tracking or personal data. In Spain, consent for under-14s must come from a parent; review the banner with whoever handles legal.
- The repository is public but not open source: all rights reserved (see `LICENSE`). The code is Daniel Ripoll's; the Chigüibara brand (name, logo, Chigüi character) is Karina Antequera's. Never commit secrets (signing keys, tokens, `key.properties`); they live in GitHub secrets. Do not add open-source licenses or third-party art or audio without approval.

## Open questions
- Rest of the MVP scope beyond what is built.
- Needs display (provisional, validate in playtests): mainly Chigüi's mood with small secondary meters.
- When the Windows build is needed, and how it reaches the children.
- Who produces the final art and with which tool.

## Working principles
- Inspect the repository and its configuration before proposing changes.
- Keep scope small and prioritize a playable prototype.
- Do not add a backend, accounts, invasive analytics, or commerce integrations without a demonstrated need; payments only as decided above.
- Avoid premature abstractions and unnecessary dependencies; use the newest versions that resolve with the pinned Flutter SDK.
- Respect Chigüibara's visual identity: handmade-feeling kawaii, geeky, and playful; not generic or excessively childish.
- Consequences for neglect stay mild, curable, and capped; no guilt-tripping copy. Never pressure players to spend.
- Distinguish confirmed decisions, hypotheses, and open questions.
- Keep diffs small: run `make format` before committing; write lists, argument lists, maps, and enums that may grow one item per line with a trailing comma; in JSON (no trailing commas) insert new entries before the last one, never after it.
- Code and technical documentation in English. Player-facing text is always localized: English (template), Spanish, German, French, and Catalan; see the `localization-copy` skill.

## Workflow
1. Inspect the project first.
2. Briefly summarize what exists and what decisions remain open.
3. If asked to analyze, do not implement.
4. If implementation is approved, make the smallest coherent change and run available checks.
5. Use only the agents and skills relevant to the task.

## Agents and skills
- Agents: game design `.claude/agents/game-designer.md`, technical architecture `.claude/agents/game-architect.md`, review `.claude/agents/reviewer.md`.
- Skills in `.claude/skills/`: `game-design`, `progression-monetization`, `mobile-architecture` (including adding Android), `2d-art-pipeline` (code-drawn art), `sound-effects`, `localization-copy`, `mvp-qa` (including visual checks), and `release-notes` (Google Play "What's new" before each version tag).
