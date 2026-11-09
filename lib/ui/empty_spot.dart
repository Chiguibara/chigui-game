import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../minigame/catch_game.dart' show FruitKind;
import 'palette.dart';
import 'sprites.dart';

/// Where Chigüi usually is, while Chigüi is gone: Chigüi's note, and the
/// fruit the player left piling up in front of it.
class EmptySpot extends StatelessWidget {
  const EmptySpot({
    super.key,
    required this.size,
    required this.note,
    this.foodLeft = 0,
  });

  final double size;

  /// What Chigüi wrote, signed with Chigüi's name.
  final String note;
  final int foodLeft;

  static const _fruits = [
    FruitKind.apple,
    FruitKind.banana,
    FruitKind.orange,
    FruitKind.watermelon,
    FruitKind.mango,
    FruitKind.guava,
    FruitKind.melon,
    FruitKind.starApple,
  ];

  @override
  Widget build(BuildContext context) {
    final fruit = size * 0.16;
    return SizedBox.square(
      dimension: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Chigüi's flattened spot on the grass.
          Positioned(
            left: size * 0.12,
            top: size * 0.78,
            child: Container(
              width: size * 0.76,
              height: size * 0.14,
              decoration: BoxDecoration(
                color: Palette.leaf.withValues(alpha: 0.25),
                borderRadius: BorderRadius.all(Radius.elliptical(size, size)),
              ),
            ),
          ),
          Positioned(
            left: size * 0.18,
            top: size * 0.3,
            width: size * 0.64,
            child: Transform.rotate(angle: -0.06, child: _note(context)),
          ),
          // Two rows of fruit in front of the note, the newest on top.
          for (var i = 0; i < foodLeft; i++)
            Positioned(
              left: size * (0.14 + 0.16 * (i % 4) + (i >= 4 ? 0.08 : 0)),
              top: size * (0.74 - (i >= 4 ? 0.08 : 0)),
              child: ExcludeSemantics(
                child: Transform.rotate(
                  angle: math.sin(i * 2.3) * 0.4,
                  child: FruitSprite(
                    kind: _fruits[i % _fruits.length],
                    size: fruit,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// A little handwritten note on lined paper, with a bit of tape.
  Widget _note(BuildContext context) => Stack(
    clipBehavior: Clip.none,
    alignment: Alignment.topCenter,
    children: [
      Container(
        padding: EdgeInsets.fromLTRB(
          size * 0.05,
          size * 0.06,
          size * 0.05,
          size * 0.05,
        ),
        decoration: BoxDecoration(
          color: Palette.cloud,
          borderRadius: BorderRadius.circular(size * 0.02),
          border: Border.all(color: Palette.furOutline, width: 2),
          boxShadow: const [
            BoxShadow(color: Color(0x33000000), offset: Offset(2, 3)),
          ],
        ),
        child: Text(
          note,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: (size * 0.06).clamp(13, 18),
            height: 1.3,
            color: Palette.ink,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      Positioned(
        top: -size * 0.02,
        child: Container(
          width: size * 0.18,
          height: size * 0.05,
          color: Palette.sparkle.withValues(alpha: 0.7),
        ),
      ),
    ],
  );
}
