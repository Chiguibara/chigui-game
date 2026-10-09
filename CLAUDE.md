# Claude Code Project Instructions

This file is the project's source of truth for working principles and confirmed decisions. The MVP scope is not fully documented yet; anything not listed under "Confirmed decisions" is a hypothesis or an open question until the user confirms it.

## Confirmed decisions
- Engine: Flutter + Dart. Flame is not a default dependency; add it only for a minigame that needs a game loop, and only inside that minigame.
- Platforms: children play on the web first, embedded in https://chiguibara.es/juego/ (mostly from PCs). A Windows build may follow; Android comes after. iOS is deferred (no macOS available). Only the `web` platform exists until the others are added.
- Tooling runs in Docker through the `Makefile`. Do not require Flutter, SDKs, or other toolchains installed on the host.
- Windows builds cannot be produced from Linux Docker; they will come from a Windows CI runner (e.g. GitHub Actions) when Windows is added.
- Responsive layout with one breakpoint: narrow or portrait screens use the phone layout (single column, what Android will use); wide landscape screens (PCs) use a wide layout. Every screen must work and be tested in both. Touch-sized targets (≥48 dp) everywhere; nothing may depend on hover, right-click, or keyboard shortcuts.
- Android application ID: `es.chiguibara.chigui_game` (pass `--org es.chiguibara` when adding the platform).
- Pet needs: hunger, affection, and fun. They decay gently while away, never to zero, and never block actions or harm Chigüi on their own.
- Daily routine (decided by the product owner to teach responsibility; tuning is provisional and lives in `lib/game/routine.dart` and `lib/game/rules.dart`):
  - Only outside school hours, in local time: weekdays 17:00–21:00, weekends 10:00–21:00; never at night.
  - Mealtimes: feeding inside the window counts as on time. Potty urges at random times: taking Chigüi to the toilet in time avoids an accident (a mess that smells until cleaned).
  - Bedtime (21:00, or 21:30 before a non-school day): sending Chigüi to bed raises fun; otherwise Chigüi goes alone, grumpy, without the bonus.
  - 3 accidents in 24 h or 2 missed meals in a row make Chigüi sick. The vet is always free, cute (no blood), and cures instantly. Being sick blocks nothing and is never permanent.
  - Time away counts, but with limits: at most 1 accident and 1 missed meal per absence, and the routine pauses after 24 h without playing.
- Coins are earned by playing (minigame, walks) and spent in the shop on accessories (one per slot, worn on Chigüi) and collectible stickers. No real-money purchases. Catalog and prices live in `lib/game/catalog.dart`.
- Seasonal items can only be bought in their season (Spooktober 1 Oct–1 Nov, Christmas 1 Dec–6 Jan, spring 20 Mar–20 Jun, summer 21 Jun–22 Sep) but can be worn any time, and buying one gives a one-off fun boost. Seasons recur yearly: the shop says when an item comes back, never uses countdowns or "last chance" copy. Out-of-season and not-enough-coins messages are half geeky, half funny.
- Walks turn daily steps into walks that raise fun and earn coins (capped per day). Only rewards, never penalties for not walking, and no weight or body changes. Step sources: on the web, a walk scene counts real steps from the phone's motion sensor while open, or, without a sensor (PCs), steps from tapping the feet; on Android, the device pedometer (not built yet; check Play policies for children's activity data and parental consent first).
- Persistence goes through `GameRepository` (domain types only). The current implementation is JSON in `shared_preferences`; switching to SQLite with drift must only require a new implementation. An event log (meals, accidents, vet visits, bedtime…) keeps the last 90 days.
- Offline and local saves only, using storage that works on web, Windows, and Android.
- Repository is private and all rights reserved (see `LICENSE`). Do not add open-source licenses or third-party art without approval.

## Open questions
- Rest of the MVP scope beyond what is built (needs, routine, minigame, walks logic, shop).
- Needs display (provisional, validate in playtests): mainly Chigüi's mood (thought bubble and status line) with small secondary meters. Tuning values live in `lib/game/rules.dart`.
- When the Windows build is needed, and how it reaches the children (zip, installer).
- Who produces the art and with which tool (defines asset formats).
- Target player age (affects store policies for children before the Android release).

## Working principles
- Inspect the repository and its configuration before proposing changes.
- Keep scope small and prioritize a playable prototype.
- Analytics: only page-level analytics on the website hosting the game (Google Analytics behind the site's consent banner), to know whether children play. The game itself sends no tracking or personal data. Note: in Spain, consent for under-14s must come from a parent; review the banner with whoever handles legal.
- Do not add a backend, accounts, invasive analytics, payments, or commerce integrations without a demonstrated need.
- Avoid premature abstractions and unnecessary dependencies.
- Respect Chigüibara's visual identity: handmade-feeling kawaii, geeky, and playful; not generic or excessively childish.
- Consequences for neglect stay mild, curable, and capped for time away (see Daily routine); no guilt-tripping copy. Never pressure players to spend.
- Distinguish confirmed decisions, hypotheses, and open questions.
- Write code and technical documentation in English unless the existing repository has a clear convention otherwise. The game must be designed for localization from the start, with English as the initial language and Spanish as a supported translation. Do not hard-code player-facing strings; use Flutter's `gen-l10n` with ARB files.

## Workflow
1. Inspect the project first.
2. Briefly summarize what exists and what decisions remain open.
3. If asked to analyze, do not implement.
4. If implementation is approved, make the smallest coherent change and run available checks.
5. Use only the agents and skills relevant to the task.

## Agents and skills
- Game design: `.claude/agents/game-designer.md`
- Technical architecture: `.claude/agents/game-architect.md`
- Review: `.claude/agents/reviewer.md`
- Skills: `.claude/skills/`
