import 'package:flutter/material.dart';
import 'package:trackexp_plus/core/constants/colors.dart';

class Glassmorphism {
  static BoxDecoration glassContainer({
    double blur = 10,
    double opacity = 0.2,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(16)),
  }) {
    return BoxDecoration(
      color: AppColors.cardBackground.withOpacity(opacity),
      borderRadius: borderRadius,
      border: Border.all(
        color: Colors.white.withOpacity(0.2),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: blur,
          spreadRadius: 1,
        ),
      ],
    );
  }

  static Widget glassCard({
    required Widget child,
    double blur = 10,
    double opacity = 0.2,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(16)),
  }) {
    return Container(
      decoration: glassContainer(
        blur: blur,
        opacity: opacity,
        borderRadius: borderRadius,
      ),
      child: child,
    );
  }
}
