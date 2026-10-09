import 'package:flutter/material.dart';

import 'palette.dart';

/// A compact action button with an icon above its label, so four always
/// fit in a row on a phone. Disabled when [onPressed] is null.
class ActionTile extends StatelessWidget {
  const ActionTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    final color = enabled ? Palette.mint : Palette.mint.withValues(alpha: 0.5);
    return Material(
      color: enabled ? Palette.ink : Palette.ink.withValues(alpha: 0.4),
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        // Fixed height with room for a two-line label, so tiles line up.
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 76,
            minHeight: 84,
            maxHeight: 84,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 26),
                const SizedBox(height: 4),
                Text(
                  label,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
