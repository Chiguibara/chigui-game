# Claude Code Project Instructions

This file is the project's source of truth for working principles. The product vision, confirmed decisions, and MVP scope are not documented yet; treat them as open questions until the user confirms them.

## Working principles
- Inspect the repository and its configuration before proposing changes.
- Keep scope small and prioritize a playable prototype.
- Flutter + Dart + Flame is a candidate, not a mandatory choice.
- Do not add a backend, accounts, invasive analytics, payments, or commerce integrations without a demonstrated need.
- Avoid premature abstractions and unnecessary dependencies.
- Respect Chigüibara's visual identity: handmade-feeling kawaii, geeky, and playful; not generic or excessively childish.
- Never punish players for being away or pressure them to spend.
- Distinguish confirmed decisions, hypotheses, and open questions.
- Write code and technical documentation in English unless the existing repository has a clear convention otherwise. The game must be designed for localization from the start, with English as the initial language and Spanish as a supported translation. Do not hard-code player-facing strings; use the project's localization system or recommend a lightweight one after inspecting the stack.

## Workflow
1. Inspect the project first.
2. Briefly summarize what exists and what decisions remain open.
3. If asked to analyze, do not implement.
4. If implementation is approved, make the smallest coherent change and run available checks.
5. Use only the agents and skills relevant to the task.

## Agents and skills
- Game design: `.claude/agents/game-designer/AGENT.md`
- Technical architecture: `.claude/agents/game-architect.md`
- Review: `.claude/agents/reviewer/AGENT.md`
- Skills: `.claude/skills/`
