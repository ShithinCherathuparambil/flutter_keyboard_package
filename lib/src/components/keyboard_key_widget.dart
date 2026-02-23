import 'package:flutter/material.dart';
import '../virtual_keyboard_key.dart';
import '../virtual_keyboard_style.dart';

/// A widget that renders a single key of the virtual keyboard.
class KeyboardKeyWidget extends StatelessWidget {
  const KeyboardKeyWidget({
    super.key,
    required this.keyboardKey,
    required this.style,
    required this.onTap,
    this.isUppercase = false,
  });

  final VirtualKeyboardKey keyboardKey;
  final VirtualKeyboardStyle style;
  final VoidCallback onTap;
  final bool isUppercase;

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (keyboardKey.child != null) {
      // If a custom widget/icon is provided, use it.
      content = keyboardKey.child!;
    } else {
      // Otherwise, fall back to rendering the text.
      String displayText = keyboardKey.text ?? '';
      if (isUppercase &&
          keyboardKey.action == VirtualKeyboardKeyAction.actionText &&
          !keyboardKey.alwaysLowercase) {
        displayText = displayText.toUpperCase();
      }

      content = Text(
        displayText,
        style:
            style.keyTextStyle ??
            Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
        textAlign: TextAlign.center,
      );
    }

    // Wrap the icon if needed
    if (style.keyIconColor != null) {
      content = IconTheme(
        data: IconThemeData(color: style.keyIconColor),
        child: content,
      );
    }

    return Expanded(
      flex: keyboardKey.flex,
      child: Padding(
        padding: style.keyMargin,
        child: Material(
          color: style.keyDecoration == null
              ? style.keyBackgroundColor
              : Colors.transparent,
          elevation: style.keyElevation,
          shape:
              style.keyBorder ??
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(style.keyBorderRadius),
              ),
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            onTap: onTap,
            splashColor: style.pressedColor,
            highlightColor: style.pressedColor,
            child: Container(
              decoration: style.keyDecoration,
              padding: style.keyPadding,
              alignment: Alignment.center,
              child: content,
            ),
          ),
        ),
      ),
    );
  }
}
