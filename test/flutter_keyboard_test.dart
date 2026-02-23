import 'package:flutter/material.dart';
import 'package:future_keyboard_kit/future_keyboard_kit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('numeric layout generates 4 rows', () {
    final layout = VirtualKeyboardLayout.numeric();
    expect(layout.keys.length, 4);
  });

  test('new preset layouts expose expected rows', () {
    expect(VirtualKeyboardLayout.phone().keys.length, 5);
    expect(VirtualKeyboardLayout.hexadecimal().keys.length, 5);
    expect(VirtualKeyboardLayout.calculator().keys.length, 5);
    expect(VirtualKeyboardLayout.otp().keys.length, 4);
    expect(VirtualKeyboardLayout.date().keys.length, 4);
    expect(VirtualKeyboardLayout.time().keys.length, 5);
    expect(VirtualKeyboardLayout.currency().keys.length, 5);
    expect(VirtualKeyboardLayout.scientificCalculator().keys.length, 5);
  });

  test('new layouts include expected special keys', () {
    final dateKeys = VirtualKeyboardLayout.date().keys.expand((r) => r);
    final timeKeys = VirtualKeyboardLayout.time().keys.expand((r) => r);
    final currencyKeys = VirtualKeyboardLayout.currency().keys.expand((r) => r);
    final scientificKeys = VirtualKeyboardLayout.scientificCalculator().keys
        .expand((r) => r);

    expect(dateKeys.any((k) => k.text == '/'), isTrue);
    expect(timeKeys.any((k) => k.text == 'AM'), isTrue);
    expect(currencyKeys.any((k) => k.text == '+/-'), isTrue);
    expect(scientificKeys.any((k) => k.text == '^'), isTrue);
  });

  testWidgets('maxLength prevents overflow insertions', (tester) async {
    final controller = TextEditingController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FlutterKeyboard(
            controller: controller,
            layout: VirtualKeyboardLayout.numeric(),
            maxLength: 3,
          ),
        ),
      ),
    );

    await tester.tap(find.text('1'));
    await tester.pump();
    await tester.tap(find.text('2'));
    await tester.pump();
    await tester.tap(find.text('3'));
    await tester.pump();
    await tester.tap(find.text('4'));
    await tester.pump();

    expect(controller.text, '123');
  });

  testWidgets('onTextChanged and onSubmitted callbacks are triggered', (
    tester,
  ) async {
    final controller = TextEditingController();
    final changes = <String>[];
    String submitted = '';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FlutterKeyboard(
            controller: controller,
            layout: VirtualKeyboardLayout.alphanumeric(),
            onTextChanged: changes.add,
            onSubmitted: (value) => submitted = value,
            insertNewLineOnEnter: false,
          ),
        ),
      ),
    );

    await tester.tap(find.text('q'));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.keyboard_return));
    await tester.pump();

    expect(controller.text, 'q');
    expect(changes, ['q']);
    expect(submitted, 'q');
  });

  testWidgets('shift key uppercases letters in shift-enabled layouts', (
    tester,
  ) async {
    final controller = TextEditingController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FlutterKeyboard(
            controller: controller,
            layout: VirtualKeyboardLayout.email(),
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.arrow_upward));
    await tester.pump();
    await tester.tap(find.text('Q'));
    await tester.pump();

    expect(controller.text, 'Q');
  });

  testWidgets('shift key toggles uppercase mode on and off', (tester) async {
    final controller = TextEditingController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FlutterKeyboard(
            controller: controller,
            layout: VirtualKeyboardLayout.alphanumeric(),
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.arrow_upward));
    await tester.pump();
    await tester.tap(find.text('Q'));
    await tester.pump();
    await tester.tap(find.text('W'));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.arrow_upward));
    await tester.pump();
    await tester.tap(find.text('e'));
    await tester.pump();

    expect(controller.text, 'QWe');
  });

  testWidgets(
    'special character toggles work without explicit alternate layouts',
    (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlutterKeyboard(
              controller: controller,
              layout: VirtualKeyboardLayout.email(),
            ),
          ),
        ),
      );

      await tester.tap(find.text('?123'));
      await tester.pump();
      expect(find.text('#+='), findsOneWidget);

      await tester.tap(find.text('#+='));
      await tester.pump();
      expect(find.text('123'), findsOneWidget);

      await tester.tap(find.text('ABC'));
      await tester.pump();
      expect(find.text('q'), findsOneWidget);
    },
  );

  testWidgets('ABC works when primary layout is special characters', (
    tester,
  ) async {
    final controller = TextEditingController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FlutterKeyboard(
            controller: controller,
            layout: VirtualKeyboardLayout.specialCharacters(),
          ),
        ),
      ),
    );

    await tester.tap(find.text('ABC'));
    await tester.pump();

    expect(find.text('q'), findsOneWidget);
  });

  testWidgets('ABC works when primary layout is secondary special characters', (
    tester,
  ) async {
    final controller = TextEditingController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FlutterKeyboard(
            controller: controller,
            layout: VirtualKeyboardLayout.specialCharactersSecondary(),
          ),
        ),
      ),
    );

    await tester.tap(find.text('ABC'));
    await tester.pump();

    expect(find.text('q'), findsOneWidget);
  });

  testWidgets('future keyboard inserts text and supports mode switching', (
    tester,
  ) async {
    final controller = TextEditingController();
    String submitted = '';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FutureKeyboard(
            controller: controller,
            onSubmitted: (value) => submitted = value,
          ),
        ),
      ),
    );

    await tester.tap(find.text('q'));
    await tester.pump();
    await tester.tap(find.text('123'));
    await tester.pump();
    await tester.tap(find.text('1'));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.keyboard_return));
    await tester.pump();

    expect(controller.text, 'q1\n');
    expect(submitted, 'q1\n');
  });

  testWidgets('future keyboard suggestion replaces current word', (
    tester,
  ) async {
    final controller = TextEditingController(text: 'fut');
    controller.selection = const TextSelection.collapsed(offset: 3);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FutureKeyboard(
            controller: controller,
            suggestionDictionary: const ['future', 'futon'],
          ),
        ),
      ),
    );

    await tester.pump();
    await tester.tap(find.text('future').first);
    await tester.pump();

    expect(controller.text, 'future');
  });

  testWidgets('future keyboard shift toggles visible key case and input', (
    tester,
  ) async {
    final controller = TextEditingController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: FutureKeyboard(controller: controller)),
      ),
    );

    await tester.tap(find.byIcon(Icons.arrow_upward));
    await tester.pump();
    expect(find.text('Q'), findsOneWidget);

    await tester.tap(find.text('Q'));
    await tester.pump();
    await tester.tap(find.text('W'));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.arrow_upward));
    await tester.pump();
    expect(find.text('q'), findsOneWidget);

    await tester.tap(find.text('e'));
    await tester.pump();

    expect(controller.text, 'QWe');
  });

  testWidgets('calculator keyboard evaluates using equals key', (tester) async {
    final controller = TextEditingController();
    String? evaluated;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CalculatorKeyboard(
            controller: controller,
            onEvaluated: (value) => evaluated = value,
          ),
        ),
      ),
    );

    await tester.tap(find.text('1'));
    await tester.pump();
    await tester.tap(find.text('+'));
    await tester.pump();
    await tester.tap(find.text('2'));
    await tester.pump();
    await tester.tap(find.text('='));
    await tester.pump();
    await tester.pump();

    expect(controller.text, '3');
    expect(evaluated, '3');
  });

  testWidgets('calculator keyboard evaluates using custom check key', (
    tester,
  ) async {
    final controller = TextEditingController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: CalculatorKeyboard(controller: controller)),
      ),
    );

    await tester.tap(find.text('8'));
    await tester.pump();
    await tester.tap(find.text('/'));
    await tester.pump();
    await tester.tap(find.text('4'));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.check));
    await tester.pump();

    expect(controller.text, '2');
  });
}
