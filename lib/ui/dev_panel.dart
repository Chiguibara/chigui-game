import 'package:flutter/material.dart';

import '../game/pet_controller.dart';
import 'palette.dart';

/// Development-only time controls, shown only in debug builds, so the daily
/// routine can be tried without waiting. Not player-facing, so its labels are
/// intentionally not localized.
class DevPanel extends StatelessWidget {
  const DevPanel({super.key, required this.controller, required this.onSteps});

  final PetController controller;

  /// Simulates the pedometer, which browsers and desktops do not have.
  final ValueChanged<int> onSteps;

  @override
  Widget build(BuildContext context) {
    final now = controller.now;
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    String two(int n) => n.toString().padLeft(2, '0');
    final time =
        '${days[now.weekday - 1]} ${two(now.day)}/${two(now.month)} '
        '${two(now.hour)}:${two(now.minute)}';

    Widget skip(String label, Duration duration) => _DevButton(
      label: label,
      onPressed: () => controller.debugSkip(duration),
    );

    return Container(
      color: Palette.ink.withValues(alpha: 0.85),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 4,
        children: [
          Text(
            'DEV $time',
            style: const TextStyle(color: Palette.mint, fontSize: 12),
          ),
          skip('+15m', const Duration(minutes: 15)),
          skip('+1h', const Duration(hours: 1)),
          skip('+6h', const Duration(hours: 6)),
          _DevButton(
            label: 'Next event',
            onPressed: controller.debugSkipToNextEvent,
          ),
          _DevButton(label: '+1000 steps', onPressed: () => onSteps(1000)),
          _DevButton(label: 'Reset', onPressed: controller.debugReset),
        ],
      ),
    );
  }
}

class _DevButton extends StatelessWidget {
  const _DevButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => TextButton(
    onPressed: onPressed,
    style: TextButton.styleFrom(
      foregroundColor: Palette.mint,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      minimumSize: const Size(0, 32),
      textStyle: const TextStyle(fontSize: 12),
    ),
    child: Text(label),
  );
}
