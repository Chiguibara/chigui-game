# Claude Code Project Instructions

This file is the project's source of truth for working principles and confirmed decisions. The MVP scope is not fully documented yet; anything not listed under "Confirmed decisions" is a hypothesis or an open question until the user confirms it.

## Confirmed decisions
- Engine: Flutter + Dart. Flame is not a default dependency; add it only for a minigame that needs a game loop, and only inside that minigame.
- Platforms: the team develops and tests on Flutter web for now. Children will play on Windows desktop; Android comes after. iOS is deferred (no macOS available). Only the `web` platform exists until the others are added.
- Tooling runs in Docker through the `Makefile`. Do not require Flutter, SDKs, or other toolchains installed on the host.
- Windows builds cannot be produced from Linux Docker; they will come from a Windows CI runner (e.g. GitHub Actions) when Windows is added.
- Design for the phone even on web and desktop: portrait, phone-shaped layout; touch-sized targets (≥48 dp); nothing may depend on hover, right-click, or keyboard shortcuts.
- Android application ID: `es.chiguibara.chigui_game` (pass `--org es.chiguibara` when adding the platform).
- Pet needs: hunger, affection, and fun. They decay gently while away, never to zero, and never block actions or harm Chigüi.
- Offline and local saves only, using storage that works on web, Windows, and Android.
- Repository is private and all rights reserved (see `LICENSE`). Do not add open-source licenses or third-party art without approval.

## Open questions
- Rest of the MVP scope (working hypothesis: petting, feeding, one minigame with coins, earnable cosmetics, local save).
- Whether needs are shown as meters or mainly through Chigüi's mood.
- When the Windows build is needed, and how it reaches the children (zip, installer).
- Who produces the art and with which tool (defines asset formats).
- Target player age (affects store policies for children before the Android release).

## Working principles
- Inspect the repository and its configuration before proposing changes.
- Keep scope small and prioritize a playable prototype.
- Do not add a backend, accounts, invasive analytics, payments, or commerce integrations without a demonstrated need.
- Avoid premature abstractions and unnecessary dependencies.
- Respect Chigüibara's visual identity: handmade-feeling kawaii, geeky, and playful; not generic or excessively childish.
- Never punish players for being away or pressure them to spend.
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
