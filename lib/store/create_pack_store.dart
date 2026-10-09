import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'debug_pack_store.dart';
import 'in_app_purchase_pack_store.dart';
import 'pack_store.dart';

/// The store for this platform: the real one in the Android app (add
/// `TargetPlatform.iOS` here when the iPhone app exists; the same class
/// talks to the App Store), a pretend one in development builds elsewhere,
/// and none on the web release or Windows, where packs are not sold.
Future<PackStore?> createPackStore() async {
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    return InAppPurchasePackStore();
  }
  if (kDebugMode) return DebugPackStore(await SharedPreferences.getInstance());
  return null;
}
