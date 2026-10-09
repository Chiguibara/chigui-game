---
name: progression-monetization
description: Designs rewards, coins, and optional cosmetics without pressure or dark patterns.
---

# Progression and Monetization

The core game must be enjoyable without paying. Coins are earned by playing and never sold.

Principles:
- No loot boxes, paid progression advantages, or selling pet needs.
- No energy limits, artificial urgency, or absence penalties beyond the daily routine in `CLAUDE.md`.
- Rewards should be understandable and proportionate to effort.
- Paid content and prices must be transparent.
- Because the brand also appeals to children and families, confirm platform requirements and parental protections before implementing purchases.

Seasonal items:
- Only sold in their season (dates in `lib/game/catalog.dart`), wearable any time once owned; buying one gives a one-off fun boost.
- Seasons recur every year: say when an item comes back ("Back every October"), never use countdowns or "last chance" copy.
- Out-of-season and not-enough-coins taps get a half-geeky, half-funny message instead of a disabled button.

Accessory packs (real money, Android only, not built yet):
- Fixed-price packs of cosmetic items (accessories, stickers), shown with their real price in euros as Google Play returns it; never a virtual currency, bundles of coins, or "value" comparisons.
- Sold only through Google Play Billing (one-time, non-consumable products, so they can be restored on a new device). No Stripe or other providers, and nothing paid on the web or Windows (hide packs there rather than teasing them).
- Parents approve through their Google account (Family Link "ask to buy"); the in-game pack screen must also be clearly a purchase, with no urgency, timers, or nagging, and only open on a deliberate tap.
- Small catalog and low prices (around 0.99–1.99 €); content is cosmetic only and every pack must be fun without making free play feel worse.
- Before building: Play Console merchant account, Families policy review for in-app purchases, PEGI "In-game purchases" label, EU guidance on in-game purchases for minors, and terms that cover digital content.

Do not design a complex economy without playtest evidence.
