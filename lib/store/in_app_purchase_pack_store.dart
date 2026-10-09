import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

import 'pack_store.dart';

/// Packs through the official `in_app_purchase` plugin, which speaks to
/// Google Play Billing on Android and to the App Store on iOS with the same
/// API. Only [ownedPacks] differs per platform.
///
/// Packs are one-time, non-consumable products whose store product ids are
/// the pack ids in `catalog.dart`. There is no server: purchases belong to
/// the player's store account and are trusted as the store reports them.
class InAppPurchasePackStore implements PackStore {
  InAppPurchasePackStore({InAppPurchase? iap})
    : _iap = iap ?? InAppPurchase.instance {
    _subscription = _iap.purchaseStream.listen(_onPurchases);
  }

  /// How long to collect restored purchases where the store has no direct
  /// "what do I own?" query (iOS, until a StoreKit-specific path is added).
  static const restoreWindow = Duration(seconds: 5);

  final InAppPurchase _iap;
  late final StreamSubscription<List<PurchaseDetails>> _subscription;
  final _updates = StreamController<PackUpdate>.broadcast();
  final _products = <String, ProductDetails>{};

  @override
  Stream<PackUpdate> get updates => _updates.stream;

  @override
  Future<bool> isAvailable() async {
    try {
      return await _iap.isAvailable();
    } catch (error) {
      debugPrint('Store unavailable: $error');
      return false;
    }
  }

  @override
  Future<Map<String, String>> prices(Set<String> packIds) async {
    final response = await _iap.queryProductDetails(packIds);
    for (final product in response.productDetails) {
      _products[product.id] = product;
    }
    return {for (final p in response.productDetails) p.id: p.price};
  }

  @override
  Future<Set<String>> ownedPacks() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final android = _iap
          .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
      final response = await android.queryPastPurchases();
      if (response.error != null) throw StateError('${response.error}');
      final owned = <String>{};
      for (final purchase in response.pastPurchases) {
        if (purchase.status == PurchaseStatus.purchased ||
            purchase.status == PurchaseStatus.restored) {
          owned.add(purchase.productID);
          await _complete(purchase);
        }
      }
      return owned;
    }
    // Elsewhere (iOS): ask the store to replay owned purchases and collect
    // them for a moment.
    final owned = <String>{};
    final listener = _iap.purchaseStream.listen((purchases) {
      for (final p in purchases) {
        if (p.status == PurchaseStatus.restored) owned.add(p.productID);
      }
    });
    await _iap.restorePurchases();
    await Future<void>.delayed(restoreWindow);
    await listener.cancel();
    return owned;
  }

  @override
  Future<void> buy(String packId) async {
    final product =
        _products[packId] ??
        (await _iap.queryProductDetails({packId})).productDetails.firstOrNull;
    if (product == null) {
      _updates.add(PackUpdate(packId, PackStatus.error));
      return;
    }
    try {
      await _iap.buyNonConsumable(
        purchaseParam: PurchaseParam(productDetails: product),
      );
    } catch (error) {
      debugPrint('Could not start buying $packId: $error');
      _updates.add(PackUpdate(packId, PackStatus.error));
    }
  }

  Future<void> _onPurchases(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      final status = switch (purchase.status) {
        PurchaseStatus.pending => PackStatus.pending,
        PurchaseStatus.purchased ||
        PurchaseStatus.restored => PackStatus.purchased,
        PurchaseStatus.canceled => PackStatus.canceled,
        PurchaseStatus.error => PackStatus.error,
      };
      // Give the items first, then tell the store we are done (Google
      // refunds purchases that are never acknowledged).
      _updates.add(PackUpdate(purchase.productID, status));
      await _complete(purchase);
    }
  }

  Future<void> _complete(PurchaseDetails purchase) async {
    if (purchase.pendingCompletePurchase) {
      await _iap.completePurchase(purchase);
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    _updates.close();
  }
}
