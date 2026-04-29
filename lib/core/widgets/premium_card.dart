import 'package:flutter/material.dart';

class PremiumCard extends StatelessWidget {
  const PremiumCard({required this.child, super.key, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [
            primary.withOpacity(0.97),
            Color.lerp(primary, secondary, 0.28)!.withOpacity(0.92),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white.withOpacity(0.22), width: 1.1),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.26),
            blurRadius: 26,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -24,
            top: -28,
            child: Container(
              height: 110,
              width: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.16),
              ),
            ),
          ),
          DefaultTextStyle.merge(
            style: const TextStyle(color: Colors.white),
            child: child,
          ),
        ],
      ),
    );
  }
}
