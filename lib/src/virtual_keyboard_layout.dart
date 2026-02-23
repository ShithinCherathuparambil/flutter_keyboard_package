import 'package:flutter/material.dart';
import 'virtual_keyboard_key.dart';

/// Defines the layout of keys on the virtual keyboard.
class VirtualKeyboardLayout {
  const VirtualKeyboardLayout({required this.keys});

  /// The rows of keys. Each list represents a row,
  /// containing multiple [VirtualKeyboardKey]s.
  final List<List<VirtualKeyboardKey>> keys;

  /// Creates a standard 10-key numeric layout with an extra row for actions.
  factory VirtualKeyboardLayout.numeric() {
    return const VirtualKeyboardLayout(
      keys: [
        [
          VirtualKeyboardKey(text: '1'),
          VirtualKeyboardKey(text: '2'),
          VirtualKeyboardKey(text: '3'),
        ],
        [
          VirtualKeyboardKey(text: '4'),
          VirtualKeyboardKey(text: '5'),
          VirtualKeyboardKey(text: '6'),
        ],
        [
          VirtualKeyboardKey(text: '7'),
          VirtualKeyboardKey(text: '8'),
          VirtualKeyboardKey(text: '9'),
        ],
        [
          VirtualKeyboardKey(
            action: VirtualKeyboardKeyAction.actionCustom,
            child: Icon(Icons.check),
          ),
          VirtualKeyboardKey(text: '0'),
          VirtualKeyboardKey(
            action: VirtualKeyboardKeyAction.actionBackspace,
            child: Icon(Icons.backspace_outlined),
          ),
        ],
      ],
    );
  }

  /// Creates a 10-key numeric layout with a decimal point and backspace.
  factory VirtualKeyboardLayout.numericDecimal() {
    return const VirtualKeyboardLayout(
      keys: [
        [
          VirtualKeyboardKey(text: '1'),
          VirtualKeyboardKey(text: '2'),
          VirtualKeyboardKey(text: '3'),
        ],
        [
          VirtualKeyboardKey(text: '4'),
          VirtualKeyboardKey(text: '5'),
          VirtualKeyboardKey(text: '6'),
        ],
        [
          VirtualKeyboardKey(text: '7'),
          VirtualKeyboardKey(text: '8'),
          VirtualKeyboardKey(text: '9'),
        ],
        [
          VirtualKeyboardKey(text: '.'),
          VirtualKeyboardKey(text: '0'),
          VirtualKeyboardKey(
            action: VirtualKeyboardKeyAction.actionBackspace,
            child: Icon(Icons.backspace_outlined),
          ),
        ],
      ],
    );
  }

  /// Creates a standard QWERTY alphanumeric layout.
  factory VirtualKeyboardLayout.alphanumeric() {
    return const VirtualKeyboardLayout(
      keys: [
        [
          VirtualKeyboardKey(text: 'q'),
          VirtualKeyboardKey(text: 'w'),
          VirtualKeyboardKey(text: 'e'),
          VirtualKeyboardKey(text: 'r'),
          VirtualKeyboardKey(text: 't'),
          VirtualKeyboardKey(text: 'y'),
          VirtualKeyboardKey(text: 'u'),
          VirtualKeyboardKey(text: 'i'),
          VirtualKeyboardKey(text: 'o'),
          VirtualKeyboardKey(text: 'p'),
        ],
        [
          VirtualKeyboardKey(text: 'a'),
          VirtualKeyboardKey(text: 's'),
          VirtualKeyboardKey(text: 'd'),
          VirtualKeyboardKey(text: 'f'),
          VirtualKeyboardKey(text: 'g'),
          VirtualKeyboardKey(text: 'h'),
          VirtualKeyboardKey(text: 'j'),
          VirtualKeyboardKey(text: 'k'),
          VirtualKeyboardKey(text: 'l'),
        ],
        [
          VirtualKeyboardKey(
            action: VirtualKeyboardKeyAction.actionShift,
            child: Icon(Icons.arrow_upward),
            flex: 2,
          ),
          VirtualKeyboardKey(text: 'z'),
          VirtualKeyboardKey(text: 'x'),
          VirtualKeyboardKey(text: 'c'),
          VirtualKeyboardKey(text: 'v'),
          VirtualKeyboardKey(text: 'b'),
          VirtualKeyboardKey(text: 'n'),
          VirtualKeyboardKey(text: 'm'),
          VirtualKeyboardKey(
            action: VirtualKeyboardKeyAction.actionBackspace,
            child: Icon(Icons.backspace_outlined),
            flex: 2,
          ),
        ],
        [
          VirtualKeyboardKey(
            action: VirtualKeyboardKeyAction.actionSpecialCharacters,
            text: '?123',
            flex: 2,
          ),
          VirtualKeyboardKey(
            action: VirtualKeyboardKeyAction.actionSpace,
            text: ' ',
            flex: 6,
          ),
          VirtualKeyboardKey(
            action: VirtualKeyboardKeyAction.actionEnter,
            child: Icon(Icons.keyboard_return),
            flex: 2,
          ),
        ],
      ],
    );
  }

  /// Creates a standard layout containing numbers and common symbols.
  /// Typically used as the alternate layout when '?123' is pressed.
  factory VirtualKeyboardLayout.specialCharacters() {
    return const VirtualKeyboardLayout(
      keys: [
        [
          VirtualKeyboardKey(text: '1'),
          VirtualKeyboardKey(text: '2'),
          VirtualKeyboardKey(text: '3'),
          VirtualKeyboardKey(text: '4'),
          VirtualKeyboardKey(text: '5'),
          VirtualKeyboardKey(text: '6'),
          VirtualKeyboardKey(text: '7'),
          VirtualKeyboardKey(text: '8'),
          VirtualKeyboardKey(text: '9'),
          VirtualKeyboardKey(text: '0'),
        ],
        [
          VirtualKeyboardKey(text: '-'),
          VirtualKeyboardKey(text: '/'),
          VirtualKeyboardKey(text: ':'),
          VirtualKeyboardKey(text: ';'),
          VirtualKeyboardKey(text: '('),
          VirtualKeyboardKey(text: ')'),
          VirtualKeyboardKey(text: '\$'),
          VirtualKeyboardKey(text: '&'),
          VirtualKeyboardKey(text: '@'),
          VirtualKeyboardKey(text: '"'),
        ],
        [
          VirtualKeyboardKey(
            action: VirtualKeyboardKeyAction.actionSpecialCharactersSecondary,
            text: '#+=',
            flex: 2,
          ),
          VirtualKeyboardKey(text: '.'),
          VirtualKeyboardKey(text: ','),
          VirtualKeyboardKey(text: '?'),
          VirtualKeyboardKey(text: '!'),
          VirtualKeyboardKey(text: '\''),
          VirtualKeyboardKey(
            action: VirtualKeyboardKeyAction.actionBackspace,
            child: Icon(Icons.backspace_outlined),
            flex: 2,
          ),
        ],
        [
          VirtualKeyboardKey(
            action: VirtualKeyboardKeyAction.actionSpecialCharacters,
            text: 'ABC',
            flex: 2,
          ),
          VirtualKeyboardKey(
            action: VirtualKeyboardKeyAction.actionSpace,
            text: ' ',
            flex: 6,
          ),
          VirtualKeyboardKey(
            action: VirtualKeyboardKeyAction.actionEnter,
            child: Icon(Icons.keyboard_return),
            flex: 2,
          ),
        ],
      ],
    );
  }

  /// Creates the secondary special characters layout.
  factory VirtualKeyboardLayout.specialCharactersSecondary() {
    return const VirtualKeyboardLayout(
      keys: [
        [
          VirtualKeyboardKey(text: '['),
          VirtualKeyboardKey(text: ']'),
          VirtualKeyboardKey(text: '{'),
          VirtualKeyboardKey(text: '}'),
          VirtualKeyboardKey(text: '#'),
          VirtualKeyboardKey(text: '%'),
          VirtualKeyboardKey(text: '^'),
          VirtualKeyboardKey(text: '*'),
          VirtualKeyboardKey(text: '+'),
          VirtualKeyboardKey(text: '='),
        ],
        [
          VirtualKeyboardKey(text: '_'),
          VirtualKeyboardKey(text: '\\'),
          VirtualKeyboardKey(text: '|'),
          VirtualKeyboardKey(text: '~'),
          VirtualKeyboardKey(text: '<'),
          VirtualKeyboardKey(text: '>'),
          VirtualKeyboardKey(text: '€'),
          VirtualKeyboardKey(text: '£'),
          VirtualKeyboardKey(text: '¥'),
          VirtualKeyboardKey(text: '•'),
        ],
        [
          VirtualKeyboardKey(
            action: VirtualKeyboardKeyAction.actionSpecialCharacters,
            text: '123',
            flex: 2,
          ),
          VirtualKeyboardKey(text: '.'),
          VirtualKeyboardKey(text: ','),
          VirtualKeyboardKey(text: '?'),
          VirtualKeyboardKey(text: '!'),
          VirtualKeyboardKey(text: '\''),
          VirtualKeyboardKey(
            action: VirtualKeyboardKeyAction.actionBackspace,
            child: Icon(Icons.backspace_outlined),
            flex: 2,
          ),
        ],
        [
          VirtualKeyboardKey(
            action: VirtualKeyboardKeyAction.actionSpecialCharacters,
            text: 'ABC',
            flex: 2,
          ),
          VirtualKeyboardKey(
            action: VirtualKeyboardKeyAction.actionSpace,
            text: ' ',
            flex: 6,
          ),
          VirtualKeyboardKey(
            action: VirtualKeyboardKeyAction.actionEnter,
            child: Icon(Icons.keyboard_return),
            flex: 2,
          ),
        ],
      ],
    );
  }

  /// Creates a purely alphabetic QWERTY layout
  factory VirtualKeyboardLayout.alphabetic() {
    return const VirtualKeyboardLayout(
      keys: [
        [
          VirtualKeyboardKey(text: 'q'),
          VirtualKeyboardKey(text: 'w'),
          VirtualKeyboardKey(text: 'e'),
          VirtualKeyboardKey(text: 'r'),
          VirtualKeyboardKey(text: 't'),
          VirtualKeyboardKey(text: 'y'),
          VirtualKeyboardKey(text: 'u'),
          VirtualKeyboardKey(text: 'i'),
          VirtualKeyboardKey(text: 'o'),
          VirtualKeyboardKey(text: 'p'),
        ],
        [
          VirtualKeyboardKey(text: 'a'),
          VirtualKeyboardKey(text: 's'),
          VirtualKeyboardKey(text: 'd'),
          VirtualKeyboardKey(text: 'f'),
          VirtualKeyboardKey(text: 'g'),
          VirtualKeyboardKey(text: 'h'),
          VirtualKeyboardKey(text: 'j'),
          VirtualKeyboardKey(text: 'k'),
          VirtualKeyboardKey(text: 'l'),
        ],
        [
          VirtualKeyboardKey(
            action: VirtualKeyboardKeyAction.actionShift,
            child: Icon(Icons.arrow_upward),
            flex: 2,
          ),
          VirtualKeyboardKey(text: 'z'),
          VirtualKeyboardKey(text: 'x'),
          VirtualKeyboardKey(text: 'c'),
          VirtualKeyboardKey(text: 'v'),
          VirtualKeyboardKey(text: 'b'),
          VirtualKeyboardKey(text: 'n'),
          VirtualKeyboardKey(text: 'm'),
          VirtualKeyboardKey(
            action: VirtualKeyboardKeyAction.actionBackspace,
            child: Icon(Icons.backspace_outlined),
            flex: 2,
          ),
        ],
        [
          VirtualKeyboardKey(
            action: VirtualKeyboardKeyAction.actionSpace,
            text: ' ',
            flex: 7,
          ),
          VirtualKeyboardKey(
            action: VirtualKeyboardKeyAction.actionEnter,
            child: Icon(Icons.keyboard_return),
            flex: 3,
          ),
        ],
      ],
    );
  }

  /// Creates an alphanumeric layout optimized for email input.
  factory VirtualKeyboardLayout.email() {
    return const VirtualKeyboardLayout(
      keys: [
        [
          VirtualKeyboardKey(text: '1'),
          VirtualKeyboardKey(text: '2'),
          VirtualKeyboardKey(text: '3'),
          VirtualKeyboardKey(text: '4'),
          VirtualKeyboardKey(text: '5'),
          VirtualKeyboardKey(text: '6'),
          VirtualKeyboardKey(text: '7'),
          VirtualKeyboardKey(text: '8'),
          VirtualKeyboardKey(text: '9'),
          VirtualKeyboardKey(text: '0'),
        ],
        [
          VirtualKeyboardKey(text: 'q'),
          VirtualKeyboardKey(text: 'w'),
          VirtualKeyboardKey(text: 'e'),
          VirtualKeyboardKey(text: 'r'),
          VirtualKeyboardKey(text: 't'),
          VirtualKeyboardKey(text: 'y'),
          VirtualKeyboardKey(text: 'u'),
          VirtualKeyboardKey(text: 'i'),
          VirtualKeyboardKey(text: 'o'),
          VirtualKeyboardKey(text: 'p'),
        ],
        [
          VirtualKeyboardKey(text: 'a'),
          VirtualKeyboardKey(text: 's'),
          VirtualKeyboardKey(text: 'd'),
          VirtualKeyboardKey(text: 'f'),
          VirtualKeyboardKey(text: 'g'),
          VirtualKeyboardKey(text: 'h'),
          VirtualKeyboardKey(text: 'j'),
          VirtualKeyboardKey(text: 'k'),
          VirtualKeyboardKey(text: 'l'),
          VirtualKeyboardKey(text: '@'),
        ],
        [
          VirtualKeyboardKey(
            action: VirtualKeyboardKeyAction.actionShift,
            child: Icon(Icons.arrow_upward),
            flex: 2,
          ),
          VirtualKeyboardKey(text: 'z'),
          VirtualKeyboardKey(text: 'x'),
          VirtualKeyboardKey(text: 'c'),
          VirtualKeyboardKey(text: 'v'),
          VirtualKeyboardKey(text: 'b'),
          VirtualKeyboardKey(text: 'n'),
          VirtualKeyboardKey(text: 'm'),
          VirtualKeyboardKey(
            action: VirtualKeyboardKeyAction.actionBackspace,
            child: Icon(Icons.backspace_outlined),
            flex: 2,
          ),
        ],
        [
          VirtualKeyboardKey(
            action: VirtualKeyboardKeyAction.actionSpecialCharacters,
            text: '?123',
            flex: 2,
          ),
          VirtualKeyboardKey(text: '_'),
          VirtualKeyboardKey(text: '-'),
          VirtualKeyboardKey(
            action: VirtualKeyboardKeyAction.actionSpace,
            text: ' ',
            flex: 3,
          ),
          VirtualKeyboardKey(text: '.', flex: 2),
          VirtualKeyboardKey(text: '.com', flex: 2, alwaysLowercase: true),
        ],
      ],
    );
  }

  /// Creates an alphanumeric layout optimized for URL input.
  factory VirtualKeyboardLayout.url() {
    return const VirtualKeyboardLayout(
      keys: [
        [
          VirtualKeyboardKey(text: '1'),
          VirtualKeyboardKey(text: '2'),
          VirtualKeyboardKey(text: '3'),
          VirtualKeyboardKey(text: '4'),
          VirtualKeyboardKey(text: '5'),
          VirtualKeyboardKey(text: '6'),
          VirtualKeyboardKey(text: '7'),
          VirtualKeyboardKey(text: '8'),
          VirtualKeyboardKey(text: '9'),
          VirtualKeyboardKey(text: '0'),
        ],
        [
          VirtualKeyboardKey(text: 'q'),
          VirtualKeyboardKey(text: 'w'),
          VirtualKeyboardKey(text: 'e'),
          VirtualKeyboardKey(text: 'r'),
          VirtualKeyboardKey(text: 't'),
          VirtualKeyboardKey(text: 'y'),
          VirtualKeyboardKey(text: 'u'),
          VirtualKeyboardKey(text: 'i'),
          VirtualKeyboardKey(text: 'o'),
          VirtualKeyboardKey(text: 'p'),
        ],
        [
          VirtualKeyboardKey(text: 'a'),
          VirtualKeyboardKey(text: 's'),
          VirtualKeyboardKey(text: 'd'),
          VirtualKeyboardKey(text: 'f'),
          VirtualKeyboardKey(text: 'g'),
          VirtualKeyboardKey(text: 'h'),
          VirtualKeyboardKey(text: 'j'),
          VirtualKeyboardKey(text: 'k'),
          VirtualKeyboardKey(text: 'l'),
          VirtualKeyboardKey(text: '/'),
        ],
        [
          VirtualKeyboardKey(
            action: VirtualKeyboardKeyAction.actionShift,
            child: Icon(Icons.arrow_upward),
            flex: 2,
          ),
          VirtualKeyboardKey(text: 'z'),
          VirtualKeyboardKey(text: 'x'),
          VirtualKeyboardKey(text: 'c'),
          VirtualKeyboardKey(text: 'v'),
          VirtualKeyboardKey(text: 'b'),
          VirtualKeyboardKey(text: 'n'),
          VirtualKeyboardKey(text: 'm'),
          VirtualKeyboardKey(
            action: VirtualKeyboardKeyAction.actionBackspace,
            child: Icon(Icons.backspace_outlined),
            flex: 2,
          ),
        ],
        [
          VirtualKeyboardKey(
            action: VirtualKeyboardKeyAction.actionSpecialCharacters,
            text: '?123',
            flex: 2,
          ),
          VirtualKeyboardKey(text: '-'),
          VirtualKeyboardKey(
            action: VirtualKeyboardKeyAction.actionSpace,
            text: ' ',
            flex: 4,
          ),
          VirtualKeyboardKey(text: '.', flex: 1),
          VirtualKeyboardKey(text: '.com', flex: 2, alwaysLowercase: true),
          VirtualKeyboardKey(
            action: VirtualKeyboardKeyAction.actionEnter,
            child: Icon(Icons.keyboard_return),
            flex: 2,
          ),
        ],
      ],
    );
  }

  /// Creates a phone dial pad style layout with *, # and quick + key.
  factory VirtualKeyboardLayout.phone() {
    return const VirtualKeyboardLayout(
      keys: [
        [
          VirtualKeyboardKey(text: '1'),
          VirtualKeyboardKey(text: '2'),
          VirtualKeyboardKey(text: '3'),
        ],
        [
          VirtualKeyboardKey(text: '4'),
          VirtualKeyboardKey(text: '5'),
          VirtualKeyboardKey(text: '6'),
        ],
        [
          VirtualKeyboardKey(text: '7'),
          VirtualKeyboardKey(text: '8'),
          VirtualKeyboardKey(text: '9'),
        ],
        [
          VirtualKeyboardKey(text: '*'),
          VirtualKeyboardKey(text: '0'),
          VirtualKeyboardKey(text: '#'),
        ],
        [
          VirtualKeyboardKey(text: '+'),
          VirtualKeyboardKey(
            action: VirtualKeyboardKeyAction.actionBackspace,
            child: Icon(Icons.backspace_outlined),
          ),
          VirtualKeyboardKey(
            action: VirtualKeyboardKeyAction.actionEnter,
            child: Icon(Icons.keyboard_return),
          ),
        ],
      ],
    );
  }

  /// Creates a hexadecimal keyboard with 0-9 and A-F.
  factory VirtualKeyboardLayout.hexadecimal() {
    return const VirtualKeyboardLayout(
      keys: [
        [
          VirtualKeyboardKey(text: '0'),
          VirtualKeyboardKey(text: '1'),
          VirtualKeyboardKey(text: '2'),
          VirtualKeyboardKey(text: '3'),
        ],
        [
          VirtualKeyboardKey(text: '4'),
          VirtualKeyboardKey(text: '5'),
          VirtualKeyboardKey(text: '6'),
          VirtualKeyboardKey(text: '7'),
        ],
        [
          VirtualKeyboardKey(text: '8'),
          VirtualKeyboardKey(text: '9'),
          VirtualKeyboardKey(text: 'a'),
          VirtualKeyboardKey(text: 'b'),
        ],
        [
          VirtualKeyboardKey(text: 'c'),
          VirtualKeyboardKey(text: 'd'),
          VirtualKeyboardKey(text: 'e'),
          VirtualKeyboardKey(text: 'f'),
        ],
        [
          VirtualKeyboardKey(
            action: VirtualKeyboardKeyAction.actionBackspace,
            child: Icon(Icons.backspace_outlined),
            flex: 2,
          ),
          VirtualKeyboardKey(
            action: VirtualKeyboardKeyAction.actionEnter,
            child: Icon(Icons.keyboard_return),
            flex: 2,
          ),
        ],
      ],
    );
  }

  /// Creates a calculator style layout with arithmetic operators.
  factory VirtualKeyboardLayout.calculator() {
    return const VirtualKeyboardLayout(
      keys: [
        [
          VirtualKeyboardKey(text: '7'),
          VirtualKeyboardKey(text: '8'),
          VirtualKeyboardKey(text: '9'),
          VirtualKeyboardKey(text: '/'),
        ],
        [
          VirtualKeyboardKey(text: '4'),
          VirtualKeyboardKey(text: '5'),
          VirtualKeyboardKey(text: '6'),
          VirtualKeyboardKey(text: '*'),
        ],
        [
          VirtualKeyboardKey(text: '1'),
          VirtualKeyboardKey(text: '2'),
          VirtualKeyboardKey(text: '3'),
          VirtualKeyboardKey(text: '-'),
        ],
        [
          VirtualKeyboardKey(text: '0'),
          VirtualKeyboardKey(text: '.'),
          VirtualKeyboardKey(text: '='),
          VirtualKeyboardKey(text: '+'),
        ],
        [
          VirtualKeyboardKey(
            action: VirtualKeyboardKeyAction.actionBackspace,
            child: Icon(Icons.backspace_outlined),
          ),
          VirtualKeyboardKey(
            action: VirtualKeyboardKeyAction.actionCustom,
            child: Icon(Icons.check),
          ),
        ],
      ],
    );
  }

  /// Creates a compact OTP/PIN keypad with submit.
  factory VirtualKeyboardLayout.otp() {
    return const VirtualKeyboardLayout(
      keys: [
        [
          VirtualKeyboardKey(text: '1'),
          VirtualKeyboardKey(text: '2'),
          VirtualKeyboardKey(text: '3'),
        ],
        [
          VirtualKeyboardKey(text: '4'),
          VirtualKeyboardKey(text: '5'),
          VirtualKeyboardKey(text: '6'),
        ],
        [
          VirtualKeyboardKey(text: '7'),
          VirtualKeyboardKey(text: '8'),
          VirtualKeyboardKey(text: '9'),
        ],
        [
          VirtualKeyboardKey(
            action: VirtualKeyboardKeyAction.actionCustom,
            child: Icon(Icons.check),
          ),
          VirtualKeyboardKey(text: '0'),
          VirtualKeyboardKey(
            action: VirtualKeyboardKeyAction.actionBackspace,
            child: Icon(Icons.backspace_outlined),
          ),
        ],
      ],
    );
  }

  /// Creates a date-entry layout with separators.
  /// Useful for inputs like MM/DD/YYYY or DD-MM-YYYY.
  factory VirtualKeyboardLayout.date() {
    return const VirtualKeyboardLayout(
      keys: [
        [
          VirtualKeyboardKey(text: '1'),
          VirtualKeyboardKey(text: '2'),
          VirtualKeyboardKey(text: '3'),
          VirtualKeyboardKey(text: '/'),
        ],
        [
          VirtualKeyboardKey(text: '4'),
          VirtualKeyboardKey(text: '5'),
          VirtualKeyboardKey(text: '6'),
          VirtualKeyboardKey(text: '-'),
        ],
        [
          VirtualKeyboardKey(text: '7'),
          VirtualKeyboardKey(text: '8'),
          VirtualKeyboardKey(text: '9'),
          VirtualKeyboardKey(text: '.'),
        ],
        [
          VirtualKeyboardKey(text: '0'),
          VirtualKeyboardKey(
            action: VirtualKeyboardKeyAction.actionBackspace,
            child: Icon(Icons.backspace_outlined),
          ),
          VirtualKeyboardKey(
            action: VirtualKeyboardKeyAction.actionEnter,
            child: Icon(Icons.keyboard_return),
            flex: 2,
          ),
        ],
      ],
    );
  }

  /// Creates a time-entry layout with colon and AM/PM shortcuts.
  factory VirtualKeyboardLayout.time() {
    return const VirtualKeyboardLayout(
      keys: [
        [
          VirtualKeyboardKey(text: '1'),
          VirtualKeyboardKey(text: '2'),
          VirtualKeyboardKey(text: '3'),
        ],
        [
          VirtualKeyboardKey(text: '4'),
          VirtualKeyboardKey(text: '5'),
          VirtualKeyboardKey(text: '6'),
        ],
        [
          VirtualKeyboardKey(text: '7'),
          VirtualKeyboardKey(text: '8'),
          VirtualKeyboardKey(text: '9'),
        ],
        [
          VirtualKeyboardKey(text: ':'),
          VirtualKeyboardKey(text: '0'),
          VirtualKeyboardKey(text: 'AM'),
        ],
        [
          VirtualKeyboardKey(text: 'PM'),
          VirtualKeyboardKey(
            action: VirtualKeyboardKeyAction.actionBackspace,
            child: Icon(Icons.backspace_outlined),
          ),
          VirtualKeyboardKey(
            action: VirtualKeyboardKeyAction.actionEnter,
            child: Icon(Icons.keyboard_return),
          ),
        ],
      ],
    );
  }

  /// Creates a currency-focused numeric layout.
  factory VirtualKeyboardLayout.currency() {
    return const VirtualKeyboardLayout(
      keys: [
        [
          VirtualKeyboardKey(text: '1'),
          VirtualKeyboardKey(text: '2'),
          VirtualKeyboardKey(text: '3'),
          VirtualKeyboardKey(text: '\$'),
        ],
        [
          VirtualKeyboardKey(text: '4'),
          VirtualKeyboardKey(text: '5'),
          VirtualKeyboardKey(text: '6'),
          VirtualKeyboardKey(text: ','),
        ],
        [
          VirtualKeyboardKey(text: '7'),
          VirtualKeyboardKey(text: '8'),
          VirtualKeyboardKey(text: '9'),
          VirtualKeyboardKey(text: '.'),
        ],
        [
          VirtualKeyboardKey(text: '00'),
          VirtualKeyboardKey(text: '0'),
          VirtualKeyboardKey(text: '+/-'),
          VirtualKeyboardKey(
            action: VirtualKeyboardKeyAction.actionBackspace,
            child: Icon(Icons.backspace_outlined),
          ),
        ],
        [
          VirtualKeyboardKey(text: '€'),
          VirtualKeyboardKey(text: '£'),
          VirtualKeyboardKey(
            action: VirtualKeyboardKeyAction.actionEnter,
            child: Icon(Icons.keyboard_return),
            flex: 2,
          ),
        ],
      ],
    );
  }

  /// Creates a scientific calculator-oriented key layout.
  /// This layout is ideal when expression parsing is handled by app logic.
  factory VirtualKeyboardLayout.scientificCalculator() {
    return const VirtualKeyboardLayout(
      keys: [
        [
          VirtualKeyboardKey(text: '('),
          VirtualKeyboardKey(text: ')'),
          VirtualKeyboardKey(text: '^'),
          VirtualKeyboardKey(text: '/'),
        ],
        [
          VirtualKeyboardKey(text: '7'),
          VirtualKeyboardKey(text: '8'),
          VirtualKeyboardKey(text: '9'),
          VirtualKeyboardKey(text: '*'),
        ],
        [
          VirtualKeyboardKey(text: '4'),
          VirtualKeyboardKey(text: '5'),
          VirtualKeyboardKey(text: '6'),
          VirtualKeyboardKey(text: '-'),
        ],
        [
          VirtualKeyboardKey(text: '1'),
          VirtualKeyboardKey(text: '2'),
          VirtualKeyboardKey(text: '3'),
          VirtualKeyboardKey(text: '+'),
        ],
        [
          VirtualKeyboardKey(text: '0'),
          VirtualKeyboardKey(text: '.'),
          VirtualKeyboardKey(text: '='),
          VirtualKeyboardKey(
            action: VirtualKeyboardKeyAction.actionBackspace,
            child: Icon(Icons.backspace_outlined),
          ),
        ],
      ],
    );
  }
}
