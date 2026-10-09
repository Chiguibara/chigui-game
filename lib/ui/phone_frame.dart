import 'package:flutter/widgets.dart';

/// Keeps the game in a portrait, phone-shaped area on wide screens (web,
/// desktop) so the layout we test there is the one Android will get.
class PhoneFrame extends StatelessWidget {
  const PhoneFrame({super.key, required this.child});

  static const aspectRatio = 9 / 19.5;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxHeight.isFinite
            ? (constraints.maxHeight * aspectRatio).clamp(
                0.0,
                constraints.maxWidth,
              )
            : constraints.maxWidth;
        return Center(
          child: SizedBox(width: width, child: child),
        );
      },
    );
  }
}
