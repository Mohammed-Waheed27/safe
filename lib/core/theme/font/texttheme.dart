import 'package:flutter/material.dart';

import '../colors/C.dart';

class Texttheme {
  static TextTheme get textTheme {
    return const TextTheme(
      displayLarge: TextStyle(
          fontSize: 32, fontWeight: FontWeight.bold, color: C.orange1),
      displayMedium: TextStyle(
        fontFamily: 'CustomFont',
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'CustomFont',
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'CustomFont',
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
    );
  }
}
