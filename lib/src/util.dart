import 'package:flutter/material.dart';

/// Converts the [color] to a hex string.
///
/// Example:
/// ```dart
/// Color color = Color(0xFFFF5733); // Color in ARGB format
/// String hexString = colorToHexString(color); // hexColor will be '#FF5733'
/// ```
String colorToHexString(Color color) {
  /// The [color] is converted to a hex string and the first two characters
  /// representing the alpha value of the color (which is not needed) are
  /// discarded.
  final hex = color.value.toRadixString(16).substring(2);

  /// Returns the hex string, preceded by a '#' to denote a color in hex format.
  return '#$hex';
}

/// Converts the [hexString] to a [Color].
///
/// Example:
/// ```dart
/// String hexString = '#FF5733';
/// Color color = hexStringToColor(hexString); // color will be Color(0xFFFF5733)
/// ```
Color hexStringToColor(String hex) {
  /// The hex string is converted to an integer.
  final int hexColor = int.parse('0xff${hex.substring(1)}');

  /// The integer is converted to a color.
  return Color(hexColor);
}
