/// What happened to a purchase of a pack.
enum PackStatus {
  /// Waiting for approval, e.g. a parent through Family Link (Google) or
  /// Ask to Buy (Apple). It may complete much later, even after a restart.
  pending,

  /// Paid (or restored); the pack's items can be given.
  purchased,

  /// The player backed out; nothing happened.
  canceled,

  /// The store reported a problem; nothing was charged by the game.
  error,
}

class PackUpdate {
  const PackUpdate(this.packId, this.status);

  final String packId;
  final PackStatus status;
}

/// The platform's own store for real-money packs (Google Play Billing on
/// Android, App Store in-app purchases on iOS). The game only talks to this
/// interface, so porting to another store means a new implementation, not
/// new game code. Purchases are tied to the player's store account, so
/// [ownedPacks] restores them on a new device without any server.
abstract interface class PackStore {
  /// False where packs are not sold (web, Windows) or the store is
  /// unreachable right now.
  Future<bool> isAvailable();

  /// Localized prices from the store (e.g. "0,99 €"), by pack id. Packs the
  /// store does not know are left out.
  Future<Map<String, String>> prices(Set<String> packIds);

  /// Packs the player's store account currently owns (refunded ones are not
  /// included).
  Future<Set<String>> ownedPacks();

  /// Starts buying; the result arrives through [updates].
  Future<void> buy(String packId);

  Stream<PackUpdate> get updates;

  void dispose();
}
