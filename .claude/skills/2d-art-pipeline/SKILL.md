---
name: 2d-art-pipeline
description: Draws Chigüi, accessories, and sprites in code (Flutter CustomPainter), with moods, layers, and animations, and checks how they look.
---

# 2D Art (drawn in code)

There is no game engine and no image assets for characters: Chigüi, accessories, food, and props are drawn with Flutter's `CustomPainter`. Respect Chigüibara's identity: handmade-feeling, playful kawaii with personality (a sitting capybara with a bow tie); avoid generic AI aesthetics, clutter, and an excessively childish look. Do not replace the art with generated or third-party images without explicit approval.

## Where things are
- `lib/ui/chigui_view.dart`: `ChiguiView` (animated: breathing, blinking, reactions, thought bubble, messes) and `ChiguiPortrait` (still, for previews). Its `_ChiguiPainter` draws Chigüi from `Face` (normal, happy, asleep, sick, grumpy), `blink`, `mouthOpen`, `cheekPuff`, `legLift`, and `wearing`.
- `lib/ui/accessories.dart`: one `case` per item and `Layer` (`behind`, `overBody`, `overHead`, `front`). Items that hide Chigüi's face (the ghost sheet) are drawn by the painter itself so the face keeps showing the mood.
- `lib/ui/sprites.dart` (coin, fruit, footprints, stickers) and `lib/ui/poop.dart`.
- `lib/ui/palette.dart`: every color. Add named colors there; no inline color literals.

## Drawing rules
- Coordinates are fractions of the square canvas (`w * x`, `h * y`), so art scales to any size. Chigüi faces right; useful anchors: head `(0.34, 0.2)–(0.88, 0.6)`, eye `(0.6, 0.34)`, muzzle `(0.7, 0.3)–(0.88, 0.56)`, near ear `(0.44, 0.22)`, bow tie `(0.52, 0.64)`, body `(0.1, 0.4)–(0.72, 0.93)`.
- Shapes: soft rounded forms with a dark outline (`Palette.furOutline`), like a hand-drawn sticker.
- Size by the shorter side of the available space (`min(w, h)`) so wide screens do not get giant art.
- Use Material icons only for generic UI symbols; draw anything with character (poop, fruit, coin, "z") in code. Never rely on emoji (they need a downloaded font on the web).
- An accessory per slot; covering items hide the bow tie. Check every new accessory alone and combined with others.
- Animations come from `AnimationController`s in `ChiguiView` (`Reaction` and its duration); respect reduced motion (`MediaQuery.disableAnimationsOf`): keep faces and text, drop movement.
- Keep widget identity stable in lists (`ValueKey`/`ObjectKey`) so animations are not lost on rebuilds.

## Checking
- Look at the result, do not guess: render screenshots as in the `mvp-qa` skill (visual checks), at a large size for details and in both layouts, and for each mood or animation frame that changed (`ChiguiPortrait(face: …)` helps).
- If final art from an illustrator arrives, keep the `ChiguiView`/`ChiguiPortrait` API and swap what the painter draws, so the rest of the game does not change.
