import '../game/game_event.dart';
import '../game/pet_state.dart';

/// Where the game is persisted. Only domain types cross this boundary, so a
/// storage backend (JSON today, SQLite with drift later) can be swapped by
/// writing a new implementation.
///
/// Implementations must never throw: unreadable data is recovered from or
/// reported as missing, and failed writes are retried by the next save.
abstract interface class GameRepository {
  /// The saved pet, or null when there is none (first launch, or unreadable).
  Future<PetState?> loadState();

  Future<void> saveState(PetState state);

  /// Appends to the history log. Entries older than [eventRetention] may be
  /// discarded.
  Future<void> addEvents(List<GameEvent> events);

  /// History entries at or after [since], oldest first.
  Future<List<GameEvent>> eventsSince(DateTime since);
}

const eventRetention = Duration(days: 90);
