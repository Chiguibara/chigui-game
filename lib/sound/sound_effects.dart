import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Sound effects in `assets/sounds`, all FLAC: synthesized by
/// tools/make_sounds.py, except the bites, cut from a real recording.
enum Sfx {
  pet('pet'),

  /// Eating: cycles through ten different real bites.
  chomp('bite', variants: 10),
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

  /// The bath: a splash into the tub, soap bubbles, scrubbing (two variants
  /// take turns), and water poured from the ladle.
  splash('splash'),
  lather('lather'),
  scrub('scrub', variants: 2),
  pour('pour'),

  /// Out of breath after too much tapping on the walk: "huh-huh".
  pant('pant'),

  /// A quiet, cute snore while Chigüi sleeps; two variants take turns.
  snore('snore', variants: 2),
  pop('pop');

  const Sfx(this.file, {this.variants = 1});

  final String file;

  /// How many recordings take turns (named `file_01`, `file_02`, …).
  final int variants;

  /// The asset for the [turn]-th time this effect plays.
  String asset(int turn) {
    if (variants == 1) return 'sounds/$file.flac';
    final n = (turn % variants + 1).toString().padLeft(2, '0');
    return 'sounds/${file}_$n.flac';
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

  /// Real playback: a few players take turns, so frantic tapping never
  /// piles up players. Browsers and Android cap how many may exist at once;
  /// one short-lived player per effect went over that cap and silenced the
  /// game for good.
  static const _channels = 6;
  static final _players = List<AudioPlayer?>.filled(_channels, null);

  /// Each player's last request, so its stop and play never overlap.
  static final _queues = List<Future<void>>.filled(_channels, Future.value());
  static var _next = 0;

  /// The same effect again sooner than this is not heard anyway: skip it.
  static const _minGap = Duration(milliseconds: 60);
  static final _clock = Stopwatch()..start();
  static final _lastPlayed = <Sfx, Duration>{};

  static void _playAsset(Sfx sfx, String asset) {
    final now = _clock.elapsed;
    final last = _lastPlayed[sfx];
    if (last != null && now - last < _minGap) return;
    _lastPlayed[sfx] = now;

    final slot = _next;
    _next = (_next + 1) % _channels;
    final player = _players[slot] ??= AudioPlayer()
      ..setReleaseMode(ReleaseMode.stop);
    _queues[slot] = _queues[slot].then((_) async {
      try {
        await player.stop();
        await player.play(AssetSource(asset));
      } catch (e) {
        // E.g. a browser blocking audio before the first tap: stay silent,
        // and give this turn a fresh player next time.
        debugPrint('Could not play $asset: $e');
        if (identical(_players[slot], player)) _players[slot] = null;
        await player.dispose();
      }
    });
  }
}

/// The app's sound effects. Silent until `main` loads the real ones, which
/// keeps widget tests quiet.
SoundEffects sfx = SoundEffects();
