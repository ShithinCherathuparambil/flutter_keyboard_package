import 'package:flutter/material.dart';

import 'flutter_keyboard.dart';
import 'virtual_keyboard_key.dart';
import 'virtual_keyboard_layout.dart';
import 'virtual_keyboard_style.dart';

/// A purpose-built calculator keyboard backed by [FlutterKeyboard].
///
/// Press `=` or the check key to evaluate the current expression.
class CalculatorKeyboard extends StatelessWidget {
  const CalculatorKeyboard({
    super.key,
    required this.controller,
    this.style = const VirtualKeyboardStyle(),
    this.onEvaluated,
    this.onError,
  });

  final TextEditingController controller;
  final VirtualKeyboardStyle style;
  final ValueChanged<String>? onEvaluated;
  final ValueChanged<String>? onError;

  @override
  Widget build(BuildContext context) {
    return FlutterKeyboard(
      controller: controller,
      layout: VirtualKeyboardLayout.calculator(),
      style: style,
      insertNewLineOnEnter: false,
      onKeyPress: (key) {
        if (key.action == VirtualKeyboardKeyAction.actionCustom) {
          _evaluateExpression();
          return;
        }

        if (key.action == VirtualKeyboardKeyAction.actionText &&
            key.text == '=') {
          // '=' is inserted by [FlutterKeyboard] after onKeyPress. Evaluate on
          // the next microtask so we see the final expression.
          Future.microtask(_evaluateExpression);
        }
      },
    );
  }

  void _evaluateExpression() {
    final raw = controller.text.trim();
    if (raw.isEmpty) return;

    final expression = raw.endsWith('=')
        ? raw.substring(0, raw.length - 1)
        : raw;

    try {
      final value = CalculatorExpressionEvaluator.evaluate(expression);
      final formatted = CalculatorExpressionEvaluator.format(value);
      controller.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
      onEvaluated?.call(formatted);
    } on FormatException catch (e) {
      onError?.call(e.message);
    }
  }
}

/// Small expression evaluator used by [CalculatorKeyboard].
class CalculatorExpressionEvaluator {
  static const _operators = <String>{'+', '-', '*', '/'};

  static double evaluate(String expression) {
    final tokens = _tokenize(expression);
    final rpn = _toRpn(tokens);
    return _evalRpn(rpn);
  }

  static String format(double value) {
    if (!value.isFinite) {
      throw const FormatException('Result is not finite.');
    }

    if ((value - value.roundToDouble()).abs() < 1e-10) {
      return value.round().toString();
    }

    final fixed = value.toStringAsFixed(10);
    return fixed
        .replaceFirst(RegExp(r'0+$'), '')
        .replaceFirst(RegExp(r'\.$'), '');
  }

  static List<String> _tokenize(String input) {
    final tokens = <String>[];
    int i = 0;

    while (i < input.length) {
      final c = input[i];

      if (c.trim().isEmpty) {
        i++;
        continue;
      }

      final isUnaryMinus =
          c == '-' &&
          (tokens.isEmpty ||
              _operators.contains(tokens.last) ||
              tokens.last == '(');

      if (_isDigitOrDot(c) || isUnaryMinus) {
        final nextChar = (i + 1 < input.length) ? input[i + 1] : '';
        if (isUnaryMinus && nextChar == '(') {
          tokens.add('0');
          tokens.add('-');
          i++;
          continue;
        }

        final start = i;
        bool hasDot = false;

        if (c == '-') {
          i++;
        }

        while (i < input.length) {
          final ch = input[i];
          if (_isDigit(ch)) {
            i++;
            continue;
          }
          if (ch == '.') {
            if (hasDot) {
              throw const FormatException('Invalid number format.');
            }
            hasDot = true;
            i++;
            continue;
          }
          break;
        }

        final token = input.substring(start, i);
        if (token == '-' || token == '.') {
          throw const FormatException('Invalid number format.');
        }
        tokens.add(token);
        continue;
      }

      if (_operators.contains(c) || c == '(' || c == ')') {
        tokens.add(c);
        i++;
        continue;
      }

      throw FormatException('Unsupported token: $c');
    }

    return tokens;
  }

  static List<String> _toRpn(List<String> tokens) {
    final output = <String>[];
    final ops = <String>[];

    for (final token in tokens) {
      if (_isNumber(token)) {
        output.add(token);
      } else if (_operators.contains(token)) {
        while (ops.isNotEmpty &&
            _operators.contains(ops.last) &&
            _precedence(ops.last) >= _precedence(token)) {
          output.add(ops.removeLast());
        }
        ops.add(token);
      } else if (token == '(') {
        ops.add(token);
      } else if (token == ')') {
        while (ops.isNotEmpty && ops.last != '(') {
          output.add(ops.removeLast());
        }
        if (ops.isEmpty || ops.last != '(') {
          throw const FormatException('Mismatched parentheses.');
        }
        ops.removeLast();
      }
    }

    while (ops.isNotEmpty) {
      final top = ops.removeLast();
      if (top == '(' || top == ')') {
        throw const FormatException('Mismatched parentheses.');
      }
      output.add(top);
    }

    return output;
  }

  static double _evalRpn(List<String> rpn) {
    final stack = <double>[];

    for (final token in rpn) {
      if (_isNumber(token)) {
        stack.add(double.parse(token));
        continue;
      }

      if (stack.length < 2) {
        throw const FormatException('Invalid expression.');
      }

      final b = stack.removeLast();
      final a = stack.removeLast();

      switch (token) {
        case '+':
          stack.add(a + b);
          break;
        case '-':
          stack.add(a - b);
          break;
        case '*':
          stack.add(a * b);
          break;
        case '/':
          if (b.abs() < 1e-12) {
            throw const FormatException('Division by zero.');
          }
          stack.add(a / b);
          break;
      }
    }

    if (stack.length != 1) {
      throw const FormatException('Invalid expression.');
    }

    return stack.single;
  }

  static bool _isDigit(String c) =>
      c.codeUnitAt(0) >= 48 && c.codeUnitAt(0) <= 57;

  static bool _isDigitOrDot(String c) => _isDigit(c) || c == '.';

  static bool _isNumber(String token) => double.tryParse(token) != null;

  static int _precedence(String op) {
    if (op == '+' || op == '-') return 1;
    if (op == '*' || op == '/') return 2;
    return 0;
  }
}
