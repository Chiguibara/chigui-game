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
- Accessory packs (see `progression-monetization`) are already coded in `lib/store/`: `InAppPurchasePackStore` (official `in_app_purchase` plugin, one-time non-consumable products whose ids are the pack ids in `catalog.dart`), chosen by `createPackStore()`. When adding Android: create the products in Play Console with those ids, confirm the billing plugin does not add the INTERNET permission (buying uses the Play Store app's connection) and that owned packs keep working offline, and test with license testers on an internal testing track (purchase, pending approval via Family Link, refund, new device restore).
- Keep Android Auto Backup enabled (`android:allowBackup`, the default) so the save comes back on a new phone; packs come back from Google Play.

## Porting to iPhone (later)
- Add `TargetPlatform.iOS` in `createPackStore()`; the same `InAppPurchasePackStore` talks to the App Store. Create the same product ids in App Store Connect.
- Apple requires App Store in-app purchases for digital items (no Apple Pay or other providers); Ask to Buy arrives as a pending purchase, already handled.
- `ownedPacks()` on iOS uses a restore window; verify it, and consider a StoreKit-specific query if refunds must be detected there. iCloud backup restores the save.
