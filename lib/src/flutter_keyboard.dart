import 'package:flutter/material.dart';
import 'virtual_keyboard_key.dart';
import 'virtual_keyboard_layout.dart';
import 'virtual_keyboard_style.dart';
import 'components/keyboard_key_widget.dart';

/// The main entry point widget for the virtual customizable keyboard.
class FlutterKeyboard extends StatefulWidget {
  const FlutterKeyboard({
    super.key,
    required this.layout,
    this.specialCharactersLayout,
    this.specialCharactersSecondaryLayout,
    this.style = const VirtualKeyboardStyle(),
    this.controller,
    this.onKeyPress,
    this.allowMultipleDecimals = true,
    this.maxLength,
    this.onTextChanged,
    this.onSubmitted,
    this.insertNewLineOnEnter = true,
  });

  /// The default layout mapping defining the keys to show on the keyboard.
  final VirtualKeyboardLayout layout;

  /// Optional secondary layout. The keyboard swaps to this layout when
  /// a key with [VirtualKeyboardKeyAction.actionSpecialCharacters] is pressed.
  final VirtualKeyboardLayout? specialCharactersLayout;

  /// Optional third layout. The keyboard swaps to this layout when
  /// a key with [VirtualKeyboardKeyAction.actionSpecialCharactersSecondary] is pressed.
  final VirtualKeyboardLayout? specialCharactersSecondaryLayout;

  /// The visual style to apply to the keyboard.
  final VirtualKeyboardStyle style;

  /// Optional text editing controller to directly bind to.
  /// Handling insertions and backspaces automatically.
  final TextEditingController? controller;

  /// An optional callback when a key is pressed.
  /// If provided, you can handle custom behaviors.
  /// NOTE: This does NOT stop the text from being inserted if a [controller] is provided.
  final void Function(VirtualKeyboardKey)? onKeyPress;

  /// By default, the keyboard allows typing multiple decimal points.
  /// Set this to false to ignore the dot key if the text already contains a dot.
  final bool allowMultipleDecimals;

  /// Optional maximum number of characters allowed in the bound controller.
  final int? maxLength;

  /// Callback triggered whenever keyboard actions update the controller text.
  final ValueChanged<String>? onTextChanged;

  /// Callback triggered when the enter key is pressed.
  final ValueChanged<String>? onSubmitted;

  /// Whether pressing enter inserts a new line in the controller.
  /// Set to false for search/submit style keyboards.
  final bool insertNewLineOnEnter;

  @override
  State<FlutterKeyboard> createState() => _FlutterKeyboardState();
}

class _FlutterKeyboardState extends State<FlutterKeyboard> {
  VirtualKeyboardShiftState _shiftState = VirtualKeyboardShiftState.lowercase;
  VirtualKeyboardLayoutType _layoutType = VirtualKeyboardLayoutType.primary;
  bool _forceAlphabeticPrimary = false;

  VirtualKeyboardLayout get _resolvedSpecialLayout =>
      widget.specialCharactersLayout ??
      VirtualKeyboardLayout.specialCharacters();

  VirtualKeyboardLayout get _resolvedSpecialSecondaryLayout =>
      widget.specialCharactersSecondaryLayout ??
      VirtualKeyboardLayout.specialCharactersSecondary();

  VirtualKeyboardLayout get _resolvedPrimaryLayout => _forceAlphabeticPrimary
      ? VirtualKeyboardLayout.alphanumeric()
      : widget.layout;

  bool _hasAlphabeticKeys(VirtualKeyboardLayout layout) {
    for (final row in layout.keys) {
      for (final key in row) {
        if (key.action == VirtualKeyboardKeyAction.actionText &&
            (key.text ?? '').contains(RegExp(r'[A-Za-z]'))) {
          return true;
        }
      }
    }
    return false;
  }

  bool _insertText(String insertion) {
    final controller = widget.controller;
    if (controller == null) return false;

    final text = controller.text;
    final selection = controller.selection.isValid
        ? controller.selection
        : TextSelection.collapsed(offset: text.length);
    final selectedLength = selection.end - selection.start;

    if (widget.maxLength != null) {
      final newLength = text.length - selectedLength + insertion.length;
      if (newLength > widget.maxLength!) {
        return false;
      }
    }

    final newText = text.replaceRange(
      selection.start,
      selection.end,
      insertion,
    );
    final newSelectionIndex = selection.start + insertion.length;

    controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newSelectionIndex),
    );
    widget.onTextChanged?.call(newText);
    return true;
  }

  bool _deleteBackward() {
    final controller = widget.controller;
    if (controller == null) return false;

    final text = controller.text;
    if (text.isEmpty) return false;

    final selection = controller.selection.isValid
        ? controller.selection
        : TextSelection.collapsed(offset: text.length);

    if (selection.start != selection.end) {
      final newText = text.replaceRange(selection.start, selection.end, '');
      controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: selection.start),
      );
      widget.onTextChanged?.call(newText);
      return true;
    }

    if (selection.start == 0) return false;

    final newText = text.replaceRange(selection.start - 1, selection.start, '');
    controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: selection.start - 1),
    );
    widget.onTextChanged?.call(newText);
    return true;
  }

  bool _wouldInsertDuplicateDecimal(String insertion) {
    if (widget.allowMultipleDecimals || insertion != '.') {
      return false;
    }

    final controller = widget.controller;
    if (controller == null) return false;

    final text = controller.text;
    if (!text.contains('.')) {
      return false;
    }

    final selection = controller.selection;
    if (!selection.isValid || selection.isCollapsed) {
      return true;
    }

    final textBefore = text.substring(0, selection.start);
    final textAfter = text.substring(selection.end);
    return textBefore.contains('.') || textAfter.contains('.');
  }

  void _handleKeyPress(VirtualKeyboardKey key) {
    if (widget.onKeyPress != null) {
      widget.onKeyPress!(key);
    }

    if (key.action == VirtualKeyboardKeyAction.actionShift) {
      setState(() {
        _shiftState = _shiftState == VirtualKeyboardShiftState.lowercase
            ? VirtualKeyboardShiftState.capsLock
            : VirtualKeyboardShiftState.lowercase;
      });
    }

    if (key.action == VirtualKeyboardKeyAction.actionSpecialCharacters) {
      final label = (key.text ?? '').toUpperCase();
      setState(() {
        if (label == 'ABC') {
          _forceAlphabeticPrimary = !_hasAlphabeticKeys(widget.layout);
          _layoutType = VirtualKeyboardLayoutType.primary;
        } else if (label == '?123' || label == '123') {
          _layoutType = VirtualKeyboardLayoutType.special;
        } else {
          _layoutType = _layoutType == VirtualKeyboardLayoutType.primary
              ? VirtualKeyboardLayoutType.special
              : VirtualKeyboardLayoutType.primary;
        }
      });
    }

    if (key.action ==
        VirtualKeyboardKeyAction.actionSpecialCharactersSecondary) {
      setState(() {
        _layoutType = _layoutType == VirtualKeyboardLayoutType.specialSecondary
            ? VirtualKeyboardLayoutType.special
            : VirtualKeyboardLayoutType.specialSecondary;
      });
    }

    if (widget.controller == null) return;

    switch (key.action) {
      case VirtualKeyboardKeyAction.actionText:
      case VirtualKeyboardKeyAction.actionSpace:
        String insertion = key.action == VirtualKeyboardKeyAction.actionSpace
            ? ' '
            : (key.text ?? '');

        final isUpper = _shiftState != VirtualKeyboardShiftState.lowercase;
        if (isUpper &&
            key.action == VirtualKeyboardKeyAction.actionText &&
            !key.alwaysLowercase) {
          insertion = insertion.toUpperCase();
        }

        if (_wouldInsertDuplicateDecimal(insertion)) {
          break;
        }

        _insertText(insertion);
        break;

      case VirtualKeyboardKeyAction.actionBackspace:
        _deleteBackward();
        break;

      case VirtualKeyboardKeyAction.actionEnter:
        if (widget.insertNewLineOnEnter) {
          _insertText('\n');
        }
        widget.onSubmitted?.call(widget.controller!.text);
        break;

      case VirtualKeyboardKeyAction.actionShift:
      case VirtualKeyboardKeyAction.actionSpecialCharacters:
      case VirtualKeyboardKeyAction.actionSpecialCharactersSecondary:
      case VirtualKeyboardKeyAction.actionCustom:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    VirtualKeyboardLayout activeLayout = _resolvedPrimaryLayout;
    if (_layoutType == VirtualKeyboardLayoutType.special) {
      activeLayout = _resolvedSpecialLayout;
    } else if (_layoutType == VirtualKeyboardLayoutType.specialSecondary) {
      activeLayout = _resolvedSpecialSecondaryLayout;
    }

    return Container(
      decoration: widget.style.backgroundDecoration,
      color: widget.style.backgroundDecoration == null
          ? widget.style.backgroundColor
          : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: activeLayout.keys.map((row) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: row.map((keyboardKey) {
              return KeyboardKeyWidget(
                keyboardKey: keyboardKey,
                style: widget.style,
                isUppercase: _shiftState != VirtualKeyboardShiftState.lowercase,
                onTap: () => _handleKeyPress(keyboardKey),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}
