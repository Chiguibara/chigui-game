import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Synthesized sound effects in `assets/sounds` (see tools/make_sounds.py).
enum Sfx {
  pet('pet'),
  chomp('chomp'),
  refuse('refuse'),
  coin('coin'),
  buy('buy'),
  bonk('bonk'),
  reward('reward'),
  start('start'),
  stepLeft('step_left'),
  stepRight('step_right'),
  flush('flush'),
  plop('plop'),
  uhOh('uh_oh'),
  sparkle('sparkle'),
  vet('vet'),
  lullaby('lullaby'),
  pop('pop');

  const Sfx(this.file);

  final String file;
}

/// Plays sound effects unless the player muted them. The mute choice is a
/// device preference, kept apart from the game save.
class SoundEffects extends ChangeNotifier {
  SoundEffects({void Function(Sfx)? player, SharedPreferences? prefs})
    : _player = player,
      _prefs = prefs,
      _muted = prefs?.getBool(mutedKey) ?? false;

  /// Real audio, used by the app. Tests use the silent default.
  static Future<SoundEffects> load() async => SoundEffects(
    player: _playAsset,
    prefs: await SharedPreferences.getInstance(),
  );

  static const mutedKey = 'settings.muted';

  final void Function(Sfx)? _player;
  final SharedPreferences? _prefs;
  bool _muted;

  bool get muted => _muted;

  void play(Sfx sfx) {
    if (!_muted) _player?.call(sfx);
  }

  void toggleMuted() {
    _muted = !_muted;
    _prefs?.setBool(mutedKey, _muted);
    notifyListeners();
  }

  static void _playAsset(Sfx sfx) {
    // One short-lived player per effect, so effects can overlap.
    final player = AudioPlayer()..setReleaseMode(ReleaseMode.release);
    player.onPlayerComplete.first.then((_) => player.dispose());
    player.play(AssetSource('sounds/${sfx.file}.wav')).catchError((Object e) {
      // E.g. a browser blocking audio before the first tap: stay silent.
      debugPrint('Could not play ${sfx.file}: $e');
      player.dispose();
    });
  }
}

/// The app's sound effects. Silent until `main` loads the real ones, which
/// keeps widget tests quiet.
SoundEffects sfx = SoundEffects();
