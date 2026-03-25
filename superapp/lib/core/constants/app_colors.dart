import 'package:flutter/material.dart';

class AppColors {
  static const Color gradientStart = Color(0xFF0D4226);
  static const Color gradientEnd = Color(0xFF21A861);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [gradientStart, gradientEnd],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient splashGradient = LinearGradient(
    colors: [
      Color(0xFFC8CAC9),
      Color(0xFFC8CAC9),
      Color(0xFFFFFFFF),
      Color(0xFFBFBFBF),
    ],
    stops: [0.0, 0.56, 0.81, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
