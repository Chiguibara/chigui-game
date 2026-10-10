---
name: localization-copy
description: Writes and localizes player-facing text (English and Spanish) with gen-l10n, in Chigüibara's voice, and checks that it fits on screen.
---

# Localization and Copy

English is the template language; Spanish, German, French, and Catalan are supported translations (one ARB file each in `lib/l10n/`). No player-facing string may be hard-coded.

## Adding or changing text
- Add the key to `lib/l10n/app_en.arb` with an `@key` entry whose `description` tells translators where it appears and its tone; add the same key to every other ARB file. `test/l10n_test.dart` fails if any language misses a text or a placeholder.
- Use ICU plurals and typed placeholders (`{count, plural, =1{…} other{…}}`) for numbers.
- `make test` and `make analyze` regenerate the code (`make l10n`); commit the generated `app_localizations*.dart` too.
- Not player-facing (dev panel, logs) may stay in plain English.

## Voice
- Chigüibara: handmade kawaii, 50% geek, 50% funny. Jokes like "Error 402", "still in beta", or "compiling the presents" are welcome where something is unavailable.
- Chigüi is gender-neutral: in Spanish, write natural sentences that avoid gendered words about Chigüi ("está de morros", "se le han gastado las pilas") instead of artificial neutral grammar.
- In Spanish say **friki**, never *geek*; German *Nerd*, French *geek*, Catalan *friqui*. Spooktober is "Halloween" outside English.
- French and Catalan adjectives are gendered: rephrase ("Chigüi est aux anges", "Chigüi fa morros") instead of inclusive marks (·e). In Catalan, no personal article before Chigüi (*en/la*). In German, avoid pronouns for Chigüi and for the grown-up.
- Gentle and never guilt-tripping: low needs, sickness, and missed routines are invitations ("A Chigüi le apetecen unos mimos"), not reproaches. No urgency or "last chance" wording.
- Keep lines short; children read them while something animates.

## Check that text fits
- Status lines reserve a fixed height (two lines on the home screen, three in the shop) so controls never move; text that is longer gets cut with an ellipsis.
- `test/text_fit_test.dart` measures, with the real Roboto font, every status line, shop message, and home tile label in every language on a 360×740 phone; add new fixed-size texts there. German and French run longest.
- For anything else, check screenshots with real fonts as described in the `mvp-qa` skill (visual checks).
