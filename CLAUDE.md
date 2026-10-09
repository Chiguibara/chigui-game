# Claude Code Project Instructions

This file is the project's source of truth for working principles and confirmed decisions. The MVP scope is not fully documented yet; anything not listed under "Confirmed decisions" is a hypothesis or an open question until the user confirms it.

## Confirmed decisions
- Engine: Flutter + Dart. Flame is not a default dependency; add it only for a minigame that needs a game loop, and only inside that minigame.
- Platform order: desktop first (Linux, then Windows) for the MVP, then Android. iOS is deferred (no macOS available).
- Tooling runs in Docker. Do not require Flutter, SDKs, or other toolchains installed on the host.
- Windows builds cannot be produced from Linux Docker; they come from a Windows CI runner (e.g. GitHub Actions) when needed.
- Design for the phone even on desktop: portrait, phone-shaped window with a fixed aspect ratio; touch-sized targets (≥48 dp); nothing may depend on hover, right-click, or keyboard shortcuts.
- Offline and local saves only, using storage that works the same on desktop and Android.
- Repository is private and all rights reserved (see `LICENSE`). Do not add open-source licenses or third-party art without approval.

## Open questions
- Confirmed MVP scope (current working hypothesis: Chigüi with hunger/affection/fun, petting, feeding, one minigame with coins, earnable cosmetics, local save).
- Who will play the Windows build, and when it is needed.
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
