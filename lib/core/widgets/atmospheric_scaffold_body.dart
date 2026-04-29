import 'package:flutter/material.dart';

class AtmosphericScaffoldBody extends StatelessWidget {
  const AtmosphericScaffoldBody({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = Theme.of(context).scaffoldBackgroundColor;
    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;

    return Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                base,
                isDark ? const Color(0xFF0E2536) : const Color(0xFFEAF2F7),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        IgnorePointer(
          child: CustomPaint(
            painter: _AtmospherePainter(
              primary: primary.withOpacity(isDark ? 0.17 : 0.13),
              secondary: secondary.withOpacity(isDark ? 0.13 : 0.1),
            ),
          ),
        ),
        child,
      ],
    );
  }
}

class _AtmospherePainter extends CustomPainter {
  const _AtmospherePainter({required this.primary, required this.secondary});

  final Color primary;
  final Color secondary;

  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()..style = PaintingStyle.fill;

    fill.color = primary;
    canvas.drawCircle(
        Offset(size.width * 0.12, size.height * 0.1), size.width * 0.26, fill);

    fill.color = secondary;
    canvas.drawCircle(
        Offset(size.width * 0.85, size.height * 0.18), size.width * 0.24, fill);

    fill.color = secondary.withOpacity(0.62);
    canvas.drawCircle(
        Offset(size.width * 0.7, size.height * 0.86), size.width * 0.32, fill);
  }

  @override
  bool shouldRepaint(covariant _AtmospherePainter oldDelegate) {
    return oldDelegate.primary != primary || oldDelegate.secondary != secondary;
  }
}
