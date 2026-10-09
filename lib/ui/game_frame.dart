import 'package:flutter/widgets.dart';

/// The single layout breakpoint: wide landscape screens (PCs) get the wide
/// layout; narrow or portrait ones get the phone layout Android will use.
bool isWide(BoxConstraints constraints) =>
    constraints.maxWidth >= 720 && constraints.maxWidth > constraints.maxHeight;

/// Frames a screen: a portrait, phone-shaped column on narrow screens, or
/// the full width (up to [maxWideWidth]) on wide ones.
class GameFrame extends StatelessWidget {
  const GameFrame({super.key, required this.child});

  static const phoneAspectRatio = 9 / 19.5;
  static const maxWideWidth = 1280.0;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width;
        if (isWide(constraints)) {
          width = constraints.maxWidth.clamp(0.0, maxWideWidth);
        } else if (constraints.maxHeight.isFinite) {
          width = (constraints.maxHeight * phoneAspectRatio).clamp(
            0.0,
            constraints.maxWidth,
          );
        } else {
          width = constraints.maxWidth;
        }
        return Center(
          child: SizedBox(width: width, child: child),
        );
      },
    );
  }
}
