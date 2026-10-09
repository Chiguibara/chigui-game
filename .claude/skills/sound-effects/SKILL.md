---
name: sound-effects
description: Adds or changes Chigüi's sound effects: synthesized FLAC sounds, real recordings cut into variants, playback rules, and checks.
---

# Sound Effects

All game audio lives in `assets/sounds/` and is **FLAC** (one format for everything). Read `CLAUDE.md` first.

## Synthesized sounds (default)
- Synthesized sounds need no entry beyond the existing row in `assets/SOURCES.md`.
- Recipes are in `tools/make_sounds.py` (pure standard-library Python, 8-bit style, built from tones and noise). It writes a temporary WAV and encodes it with `flac`, which is installed in the Docker image.
- Add or tweak a recipe in `SOUNDS`, then run `make sounds`. Background sounds (e.g. snores) go in `QUIET` so they peak lower than the rest.
- Variants that take turns are named `name_01`, `name_02`, ….

## Real recordings (when synthesis is not convincing)
- Only use recordings supplied or approved by the product owner; record where each file came from (and its license) in `assets/SOURCES.md`, and ask about the license before publishing.
- Copy the source into the scratchpad, never into the repo. Do not commit the original recording, only the cuts.
- With `ffmpeg` (installed on the host; only for these one-off cuts, never needed to build): find the pauses with `silencedetect` (e.g. `noise=-35dB:d=0.3`), cut each sound with ~30 ms before and ~80 ms after, add short fades (5 ms in, 80 ms out), cap overly long cuts, then **measure the peak after the fades** and normalize to -1 dB. Encode straight to FLAC (`-c:a flac -sample_fmt s16`); never re-encode a lossy source to another lossy format.
- Keep about ten distinct variants; skip cuts that contain several sounds or are only tails.

## Wiring
- Add the effect to `Sfx` in `lib/sound/sound_effects.dart` (`variants:` for sounds that take turns; `SoundEffects.play` cycles through them).
- Play it with `sfx.play(Sfx.x)` at the moment it happens. Sounds must respect mute (they do through `sfx`), and ambient ones only play on the visible screen (see the snore in `home_screen.dart`).
- Player-facing labels for sound controls go through `gen-l10n` like any other text.

## Checks
- `test/sound_effects_test.dart` verifies that every `Sfx` file and variant exists and that variants cycle; widget tests record played sounds with `SoundEffects(player: …)`.
- To confirm browsers can decode new files, load them in headless Chrome with an `Audio` element and wait for `canplaythrough`.
- After adding, renaming, or deleting files in `assets/`, tell the user to restart `make web` (`q`, then start it again); reloading the page is not enough.
- You cannot hear the result: say so, describe what each sound is meant to be, and ask the user for feedback.
