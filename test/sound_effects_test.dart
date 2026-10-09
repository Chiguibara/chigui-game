import 'dart:io';

import 'package:chigui_game/sound/sound_effects.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('each bite sounds different, cycling through all ten', () {
    final assets = <String>[];
    final sounds = SoundEffects(player: (_, asset) => assets.add(asset));
    for (var i = 0; i < 11; i++) {
      sounds.play(Sfx.chomp);
    }
    expect(assets.first, 'sounds/bite_01.flac');
    expect(assets[9], 'sounds/bite_10.flac');
    expect(assets[10], 'sounds/bite_01.flac');
    expect(assets.take(10).toSet(), hasLength(10));
  });

  test('snores alternate between two variants', () {
    final assets = <String>[];
    final sounds = SoundEffects(player: (_, asset) => assets.add(asset));
    for (var i = 0; i < 3; i++) {
      sounds.play(Sfx.snore);
    }
    expect(assets, [
      'sounds/snore_01.wav',
      'sounds/snore_02.wav',
      'sounds/snore_01.wav',
    ]);
  });

  test('single sounds keep their file', () {
    final assets = <String>[];
    SoundEffects(player: (_, asset) => assets.add(asset)).play(Sfx.coin);
    expect(assets, ['sounds/coin.wav']);
  });

  test('every sound file exists', () {
    for (final sfx in Sfx.values) {
      for (var i = 0; i < sfx.variants; i++) {
        expect(
          File('assets/${sfx.asset(i)}').existsSync(),
          isTrue,
          reason: sfx.asset(i),
        );
      }
    }
  });
}
