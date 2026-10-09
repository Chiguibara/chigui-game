---
name: mvp-qa
description: Reviews quality, scope, save behavior, and mobile experience for the Chigüibara prototype.
---

# MVP QA

Turn the confirmed decisions and MVP scope in `CLAUDE.md` into a small set of tests.

Check at least:
- launch and resume;
- petting, feeding, and minigame;
- meter boundaries, daily-routine timing, and absence limits (caps and 24 h pause);
- reward calculations and coin spending;
- equipping and removing cosmetics;
- save/load and missing or corrupted data;
- elapsed time while offline;
- small screens and touch accessibility, both the phone and the wide (PC) layouts, and no reliance on hover or keyboard;
- offline behavior and recoverable errors;
- performance and reasonable resource use;
- localization coverage and fallback behavior.

Run available tests and clearly report what was tested, what was not, and remaining risks. Do not add disproportionate testing infrastructure for a prototype.

## Visual checks
Widget tests prove behavior, not looks. After visual changes, look at screenshots:
- Write a temporary test (e.g. `test/zz_shot_test.dart`) that pumps the screen and calls `matchesGoldenFile('shots/name.png')`, run it with `flutter test <file> --update-goldens` in the container, view the PNGs, then delete the test and `test/shots/`.
- Check both layouts: phone (360×740 logical) and wide/PC (1280×720), with `tester.view.physicalSize` and `devicePixelRatio`.
- For anything with text, load real fonts first; the default test font draws blocks and hides truncation. Load Roboto and MaterialIcons from `/sdks/flutter/bin/cache/artifacts/material_fonts/` with `FontLoader` inside `tester.runAsync`, and check both languages (`tester.platformDispatcher.localesTestValue`).
- To freeze an animation at a moment, pump to that time (`tester.pump(Duration(...))`); pump one frame before long waits, since animations start on the next frame.
- For the web build, `make build-site` and open it in headless Chrome (`--screenshot`, `--log-net-log`) to confirm it renders and contacts no external host.
