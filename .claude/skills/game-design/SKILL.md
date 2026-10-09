---
name: game-design
description: Designs the core loop and interactions for a relaxed virtual pet with 1–2 minute sessions.
---

# Game Design

Read `CLAUDE.md` for product decisions. Tuning values (decay rates, routine times, thresholds, rewards, prices, season dates) live in the code: `lib/game/rules.dart`, `lib/game/routine.dart`, and `lib/game/catalog.dart`; change and test them there.

When working:
1. Define the session goal and expected reward.
2. Prefer low-tap interactions and immediate visual feedback.
3. Let players leave at any time without losing progress.
4. Distinguish decorative needs from real blockers.
5. Remove systems that do not help validate the prototype.

For each mechanic, describe player action, Chigüi's response, duration, reward, production cost, and risks. Mark unvalidated choices as provisional. Keep player-facing copy easy to localize.
