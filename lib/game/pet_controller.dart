import 'package:flutter/foundation.dart';

import '../save/save_store.dart';
import 'pet_state.dart';
import 'rules.dart' as rules;

/// Single source of truth for the pet. Every change is saved right away, so
/// the player can leave at any moment without losing anything.
class PetController extends ChangeNotifier {
  PetController(this._store, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now {
    _state = rules.elapse(_store.load(_clock()), _clock());
  }

  final SaveStore _store;
  final DateTime Function() _clock;
  late PetState _state;

  PetState get state => _state;
  Need? get wish => rules.wish(_state);

  void pet() => _update(rules.pet(_state, _clock()));

  /// Returns false when Chigüi is too full to eat.
  bool feed() {
    final full = rules.isFull(rules.elapse(_state, _clock()));
    _update(rules.feed(_state, _clock()));
    return !full;
  }

  /// Catches up on time spent away, e.g. when the app comes back to the
  /// foreground.
  void refresh() => _update(rules.elapse(_state, _clock()));

  void _update(PetState next) {
    _state = next;
    _store.save(next);
    notifyListeners();
  }
}
