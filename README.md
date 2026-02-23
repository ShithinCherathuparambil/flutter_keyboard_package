# Customizable Flutter Keyboard

A highly customizable on-screen virtual keyboard package for Flutter. Build flexible numeric, alphanumeric, and customized keyboard layouts for your apps effortlessly without worrying about complex state management. Features direct integration with `TextEditingController`.

## Features
* 🎨 **Deeply Customizable**: Build completely unique layouts and control the styles (colors, border radiuses, flexible widths).
* 🚀 **Future Keyboard Included**: Use `FutureKeyboard` for live theme switching, snippets, suggestions, and interactive key sizing.
* ⌨️ **Default Layouts Provided**: Quick factories for numeric, alphanumeric, email, URL, phone, hexadecimal, and calculator keyboards.
* 🔌 **Plug and Play**: Easily binds to your existing `TextEditingController` to instantly manage selections, insertions, and backspaces automatically.
* 🛠 **Custom Actions**: Map any key to a completely custom action and UI logic using custom keys and `onKeyPress`.
* ✅ **Input Control**: Optional `maxLength`, `onTextChanged`, `onSubmitted`, and configurable enter-key behavior.
* 🧮 **Calculator Keyboard**: Use `CalculatorKeyboard` to evaluate typed expressions with `=` or the check key.

## Screenshots
<p align="center">
  <img src="https://raw.githubusercontent.com/ShithinCherathuparambil/flutter_keyboard_package/main/assets/screenshots/screenshot_1.png" width="30%" />
  <img src="https://raw.githubusercontent.com/ShithinCherathuparambil/flutter_keyboard_package/main/assets/screenshots/screenshot_2.png" width="30%" />
  <img src="https://raw.githubusercontent.com/ShithinCherathuparambil/flutter_keyboard_package/main/assets/screenshots/screenshot_3.png" width="30%" />
  <img src="https://raw.githubusercontent.com/ShithinCherathuparambil/flutter_keyboard_package/main/assets/screenshots/screenshot_4.png" width="30%" />
  <img src="https://raw.githubusercontent.com/ShithinCherathuparambil/flutter_keyboard_package/main/assets/screenshots/screenshot_5.png" width="30%" />
</p>

## Getting started

Add `future_keyboard_kit` to your `pubspec.yaml`:

```yaml
dependencies:
  future_keyboard_kit: ^0.0.2
```

## TextField Setup (Required)

Use a `TextEditingController` and make your `TextField` read-only so the system keyboard does not appear.

```dart
import 'package:flutter/material.dart';
import 'package:future_keyboard_kit/future_keyboard_kit.dart';

class KeyboardInputPage extends StatefulWidget {
  const KeyboardInputPage({super.key});

  @override
  State<KeyboardInputPage> createState() => _KeyboardInputPageState();
}

class _KeyboardInputPageState extends State<KeyboardInputPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          readOnly: true,
          showCursor: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Type using custom keyboard',
          ),
        ),
        const SizedBox(height: 12),
        FlutterKeyboard(
          controller: _controller,
          layout: VirtualKeyboardLayout.alphanumeric(),
          specialCharactersLayout: VirtualKeyboardLayout.specialCharacters(),
          specialCharactersSecondaryLayout:
              VirtualKeyboardLayout.specialCharactersSecondary(),
        ),
      ],
    );
  }
}
```

## Basic Usage

Simply drop a `FlutterKeyboard` into your widget tree, provide it with a layout and an optional `TextEditingController`. 

```dart
import 'package:future_keyboard_kit/future_keyboard_kit.dart';
// ...

final TextEditingController _controller = TextEditingController();

// A basic Numeric Keyboard.
FlutterKeyboard(
  controller: _controller,
  layout: VirtualKeyboardLayout.numeric(),
  style: VirtualKeyboardStyle(
     backgroundColor: Colors.transparent,
     keyBackgroundColor: Colors.grey.shade200,
     keyBorderRadius: 8.0,
     keyTextStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  ),
  onKeyPress: (key) {
    if (key.action == VirtualKeyboardKeyAction.actionCustom) {
      print('Custom key was pressed!');
    }
  },
);
```

## Configure Text Behavior

Use these options to control editing behavior:

- `maxLength`: limit input size
- `allowMultipleDecimals`: prevent multiple decimal points
- `insertNewLineOnEnter`: disable newline on enter and treat enter as submit
- `onTextChanged`: listen to every text update
- `onSubmitted`: listen when enter is tapped

```dart
FlutterKeyboard(
  controller: _controller,
  layout: VirtualKeyboardLayout.numericDecimal(),
  maxLength: 8,
  allowMultipleDecimals: false,
  insertNewLineOnEnter: false,
  onTextChanged: (value) => debugPrint('Changed: $value'),
  onSubmitted: (value) => debugPrint('Submitted: $value'),
)
```

For advanced usage including fully custom layouts, run the `example` application included in the repository.

## Advanced Input Options

```dart
FlutterKeyboard(
  controller: _controller,
  layout: VirtualKeyboardLayout.phone(),
  maxLength: 15,
  insertNewLineOnEnter: false,
  onTextChanged: (value) => debugPrint('Changed: $value'),
  onSubmitted: (value) => debugPrint('Submitted: $value'),
)
```

Available built-in layouts now include:
`numeric`, `numericDecimal`, `alphanumeric`, `alphabetic`, `specialCharacters`,
`specialCharactersSecondary`, `email`, `url`, `phone`, `hexadecimal`,
`calculator`, `otp`, `date`, `time`, `currency`, `scientificCalculator`.

## Future Keyboard

```dart
final controller = TextEditingController();

FutureKeyboard(
  controller: controller,
  quickSnippets: const ['.ai', '.dev', '@future.io', 'https://'],
  suggestionDictionary: const ['future', 'interactive', 'customizable', 'flutter'],
  onSubmitted: (value) => debugPrint('Submitted: $value'),
);
```

## Calculator Keyboard

```dart
final controller = TextEditingController();

CalculatorKeyboard(
  controller: controller,
  onEvaluated: (result) => debugPrint('Result: $result'),
  onError: (message) => debugPrint('Error: $message'),
);
```

## Custom Layouts
You can define your precise key matrix by simply creating your own `VirtualKeyboardLayout`:

```dart
final customLayout = VirtualKeyboardLayout(keys: [
  // First Row
  [
    VirtualKeyboardKey(text: 'A', flex: 1),
    VirtualKeyboardKey(text: 'B', flex: 1),
  ],
  // Second Row
  [
    VirtualKeyboardKey(
      action: VirtualKeyboardKeyAction.actionCustom,
      child: const Icon(Icons.star), // Provide custom widget inside key
      flex: 2, // Take up twice the horizontal space
    ),
  ]
]);
```
