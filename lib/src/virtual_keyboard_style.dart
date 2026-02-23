import 'package:flutter/material.dart';

/// Styling options for the virtual keyboard and its keys.
class VirtualKeyboardStyle {
  const VirtualKeyboardStyle({
    this.backgroundColor = const Color(0xFFD1D5DB), // Modern light grey
    this.backgroundDecoration,
    this.keyBackgroundColor = const Color(0xFFFFFFFF), // White keys
    this.keyDecoration,
    this.keyTextStyle,
    this.keyIconColor,
    this.keyBorderRadius = 6.0,
    this.keyPadding = const EdgeInsets.symmetric(vertical: 12.0),
    this.keyElevation = 1.0, // Slight drop shadow
    this.keyMargin = const EdgeInsets.symmetric(horizontal: 3.0, vertical: 4.0),
    this.keyBorder,
    this.pressedColor = const Color(0xFFE5E7EB),
  });

  /// The background color of the entire keyboard.
  /// Overridden by [backgroundDecoration] if provided.
  final Color backgroundColor;

  /// Advanced decoration for the keyboard's background (e.g., gradients).
  final BoxDecoration? backgroundDecoration;

  /// The background color of individual keys.
  /// Overridden by [keyDecoration] if provided.
  final Color keyBackgroundColor;

  /// Advanced decoration for the individual keys (e.g., glassmorphism, gradients).
  final BoxDecoration? keyDecoration;

  /// The text style for the keys, typically setting font size, weight, and color.
  final TextStyle? keyTextStyle;

  /// The color for any icons rendered in the keys if they aren't explicitly styled.
  final Color? keyIconColor;

  /// The border radius for the standard key shape.
  final double keyBorderRadius;

  /// The internal padding inside each key.
  final EdgeInsetsGeometry keyPadding;

  /// The margin between keys.
  final EdgeInsetsGeometry keyMargin;

  /// Setup the material elevation for the keys.
  final double keyElevation;

  /// A custom border for keys, if required.
  final ShapeBorder? keyBorder;

  /// Color of key when pressed.
  final Color? pressedColor;
}
