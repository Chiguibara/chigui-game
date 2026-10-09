import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Sound effects in `assets/sounds`: synthesized by tools/make_sounds.py,
/// except the bites, cut from a real recording.
enum Sfx {
  pet('pet'),

  /// Eating: cycles through ten different real bites.
  chomp('bite', variants: 10, extension: 'flac'),
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

  /// A quiet, cute snore while Chigüi sleeps; two variants take turns.
  snore('snore', variants: 2),
  pop('pop');

  const Sfx(this.file, {this.variants = 1, this.extension = 'wav'});

  final String file;

  /// How many recordings take turns (named `file_01`, `file_02`, …).
  final int variants;
  final String extension;

  /// The asset for the [turn]-th time this effect plays.
  String asset(int turn) {
    if (variants == 1) return 'sounds/$file.$extension';
    final n = (turn % variants + 1).toString().padLeft(2, '0');
    return 'sounds/${file}_$n.$extension';
  }
}

/// Plays one sound asset (a path under `assets/`).
typedef SfxPlayer = void Function(Sfx sfx, String asset);

/// Plays sound effects unless the player muted them. The mute choice is a
/// device preference, kept apart from the game save.
class SoundEffects extends ChangeNotifier {
  SoundEffects({this._player, SharedPreferences? prefs})
    : _prefs = prefs,
      _muted = prefs?.getBool(mutedKey) ?? false;

  /// Real audio, used by the app. Tests use the silent default.
  static Future<SoundEffects> load() async => SoundEffects(
    player: _playAsset,
    prefs: await SharedPreferences.getInstance(),
  );

  static const mutedKey = 'settings.muted';

  final SfxPlayer? _player;
  final _turns = <Sfx, int>{};
  final SharedPreferences? _prefs;
  bool _muted;

  bool get muted => _muted;

  void play(Sfx sfx) {
    if (_muted) return;
    final turn = _turns[sfx] ?? 0;
    _turns[sfx] = turn + 1;
    _player?.call(sfx, sfx.asset(turn));
  }

  void toggleMuted() {
    _muted = !_muted;
    _prefs?.setBool(mutedKey, _muted);
    notifyListeners();
  }

  static void _playAsset(Sfx sfx, String asset) {
    // One short-lived player per effect, so effects can overlap.
    final player = AudioPlayer()..setReleaseMode(ReleaseMode.release);
    player.onPlayerComplete.first.then((_) => player.dispose());
    player.play(AssetSource(asset)).catchError((Object e) {
      // E.g. a browser blocking audio before the first tap: stay silent.
      debugPrint('Could not play $asset: $e');
      player.dispose();
    });
  }
}

/// The app's sound effects. Silent until `main` loads the real ones, which
/// keeps widget tests quiet.
SoundEffects sfx = SoundEffects();
