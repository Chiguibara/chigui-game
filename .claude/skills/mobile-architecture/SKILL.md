---
name: mobile-architecture
description: Evaluates a minimal mobile architecture for a 2D MVP, prioritizing offline play and local saves.
---

# Mobile Architecture

Inspect existing files, versions, configuration, and dependencies before deciding. The stack is Flutter + Dart with Docker tooling; Flame only if a minigame needs it.

Evaluate only what is needed for:
- 2D scene and animations;
- hunger, affection, and fun state;
- actions, rewards, and minigame;
- equipped cosmetics and coins;
- local save/load, including elapsed-time handling;
- basic unit and integration tests.

Prefer a clear source of truth for game state, versionable persistence that tolerates missing data, offline play, and small maintained dependencies.

Do not add a backend, accounts, sync, or multiplayer architecture to the MVP. Before recommending a package, check that it supports web, Windows, and Android (iOS is deferred), runs in the Docker toolchain, and is the newest version that resolves with the pinned Flutter SDK (`flutter pub outdated`). Ensure player-facing strings are localizable.

## Adding Android
- Create the platform with `flutter create --platforms android --org es.chiguibara .` so the ID is `es.chiguibara.chigui_game` (without `--org`, Flutter uses `com.example`).
- The app must work fully offline: check the merged manifest of the **release** APK and confirm there is no `android.permission.INTERNET` (Flutter adds it only to debug/profile; plugins may add it). Test the release build in airplane mode.
- Steps come from the system step counter (it counts while the app is closed; add the steps since the last visit). Before building it, review Google Play policies for children's activity data, Families requirements, and parental consent.
- Re-check that every plugin in use supports Android and adds no unexpected permissions.
- Accessory packs (see `progression-monetization`): use the official `in_app_purchase` plugin with Google Play Billing, one-time non-consumable products; acknowledge purchases, restore them on start, and treat Google Play as the source of truth for paid items (do not trust the local save alone). Buying needs the Play Store's connection, not the app's: confirm the billing plugin does not add the INTERNET permission, and that owned packs keep working offline. Test with license testers on an internal testing track.
