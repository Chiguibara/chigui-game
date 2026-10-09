---
name: progression-monetization
description: Designs rewards, coins, and optional cosmetics without pressure or dark patterns.
---

# Progression and Monetization

The core game must be enjoyable without paying. In the MVP, validate rewards and earnable cosmetics first; postpone real-money purchases.

Principles:
- No loot boxes, paid progression advantages, or selling pet needs.
- No energy limits, artificial urgency, or absence penalties beyond the daily routine in `CLAUDE.md`.
- Rewards should be understandable and proportionate to effort.
- Paid content and prices must be transparent.
- Because the brand also appeals to children and families, identify relevant platform requirements and parental protections before implementing purchases.

Seasonal items:
- Only sold in their season (dates in `lib/game/catalog.dart`), wearable any time once owned; buying one gives a one-off fun boost.
- Seasons recur every year: say when an item comes back ("Back every October"), never use countdowns or "last chance" copy.
- Out-of-season and not-enough-coins taps get a half-geeky, half-funny message instead of a disabled button.

Do not design a complex economy without playtest evidence.
