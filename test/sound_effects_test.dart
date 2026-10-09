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
    expect(assets.first, 'sounds/bite_01.mp3');
    expect(assets[9], 'sounds/bite_10.mp3');
    expect(assets[10], 'sounds/bite_01.mp3');
    expect(assets.take(10).toSet(), hasLength(10));
  });

  test('single sounds keep their file', () {
    final assets = <String>[];
    SoundEffects(player: (_, asset) => assets.add(asset)).play(Sfx.coin);
    expect(assets, ['sounds/coin.wav']);
  });

  test('every bite file exists', () {
    for (var i = 0; i < Sfx.chomp.variants; i++) {
      expect(
        File('assets/${Sfx.chomp.asset(i)}').existsSync(),
        isTrue,
        reason: Sfx.chomp.asset(i),
      );
    }
    for (final sfx in Sfx.values.where((s) => s.variants == 1)) {
      expect(File('assets/${sfx.asset(0)}').existsSync(), isTrue);
    }
  });
}
