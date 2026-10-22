---
name: release-notes
description: Writes the Google Play "What's new" notes (distribution/whatsnew/) for a new version from the changes since the last release, in Chigüibara's voice, before tagging it.
---

# Release Notes

Google Play shows `distribution/whatsnew/` as the version's "What's new" in the store and in the update screen. The `deploy.yml` workflow uploads it with every version tag and fails if the notes are empty, longer than 500 characters, or unchanged since the previous production tag. Read `CLAUDE.md` first.

The game also shows these notes once after an update, on the web and in the Android app (`lib/ui/whats_new.dart`, bundled as assets): Spanish players read `whatsnew-es-ES`, Catalan players `distribution/whatsnew-game/whatsnew-ca-ES`, and everyone else `whatsnew-en-US`. The Catalan file lives outside `distribution/whatsnew/` because every file there is uploaded to Google Play; the workflow also fails if it has not changed. A change to the English notes is what shows the dialog again, so write them for players of both the web and the app.

## When
Before tagging a new version (see Deployment in `README.md`). Test tags of a version (`v0.2.0-rc.1`, `v0.2.0-beta.1`) and its final tag (`v0.2.0`) share the same notes: write them once for the version and refine them between test tags if needed.

## Steps
1. Find the previous production tag: `git describe --tags --abbrev=0 --exclude '*-*'`, and list what changed since then: `git log --oneline <tag>..HEAD`. Read the diffs of anything unclear.
2. Keep only what players or their families notice: new things to do, changes in how the game plays, fixes for problems they could have seen. Leave out CI, tooling, tests, refactors, store assets, and documentation. If nothing visible changed, say so plainly ("Small fixes so Chigüi runs smoother").
3. Write one file per language that has a store listing in Play Console: `whatsnew-es-ES` and `whatsnew-en-US` today. When a listing is added in another language (`de-DE`, `fr-FR`, `ca`), add its file too; notes in a language without a listing are not shown in the store.
4. Translate the same notes into Catalan in `distribution/whatsnew-game/whatsnew-ca-ES` (same title and points, same format, Catalan voice from the `localization-copy` skill).
5. Check each file is at most 500 characters (`python3 -c 'import sys; print(len(open(sys.argv[1]).read().strip()))' <file>`), show the notes to the user, and commit them on their own before the tag.

## Writing
- Spanish is written first (the main market), then English, and the same points in every language. Follow the voice rules in the `localization-copy` skill (friki in Spanish, Chigüi gender-neutral, gentle).
- One short opening line, then up to four "• " points, most fun first. Plain words a child and a parent can both read; no version numbers, technical terms, or internal names.
- Only describe what the build really does (`CLAUDE.md`, code); no promises about future versions.
- Families policy: never push purchases. Paid packs may be mentioned as new cosmetics, never with urgency, prices, or "don't miss".
