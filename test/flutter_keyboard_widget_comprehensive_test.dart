import 'package:flutter/material.dart';
import 'package:future_keyboard_kit/future_keyboard_kit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('comprehensive widget coverage', () {
    final layoutCases =
        <
          ({
            String name,
            VirtualKeyboardLayout layout,
            String tapText,
            String expected,
          })
        >[
          (
            name: 'numeric',
            layout: VirtualKeyboardLayout.numeric(),
            tapText: '1',
            expected: '1',
          ),
          (
            name: 'numericDecimal',
            layout: VirtualKeyboardLayout.numericDecimal(),
            tapText: '.',
            expected: '.',
          ),
          (
            name: 'alphanumeric',
            layout: VirtualKeyboardLayout.alphanumeric(),
            tapText: 'q',
            expected: 'q',
          ),
          (
            name: 'alphabetic',
            layout: VirtualKeyboardLayout.alphabetic(),
            tapText: 'a',
            expected: 'a',
          ),
          (
            name: 'specialCharacters',
            layout: VirtualKeyboardLayout.specialCharacters(),
            tapText: '1',
            expected: '1',
          ),
          (
            name: 'specialCharactersSecondary',
            layout: VirtualKeyboardLayout.specialCharactersSecondary(),
            tapText: '[',
            expected: '[',
          ),
          (
            name: 'email',
            layout: VirtualKeyboardLayout.email(),
            tapText: '@',
            expected: '@',
          ),
          (
            name: 'url',
            layout: VirtualKeyboardLayout.url(),
            tapText: '/',
            expected: '/',
          ),
          (
            name: 'phone',
            layout: VirtualKeyboardLayout.phone(),
            tapText: '*',
            expected: '*',
          ),
          (
            name: 'hexadecimal',
            layout: VirtualKeyboardLayout.hexadecimal(),
            tapText: 'a',
            expected: 'a',
          ),
          (
            name: 'calculator',
            layout: VirtualKeyboardLayout.calculator(),
            tapText: '7',
            expected: '7',
          ),
          (
            name: 'otp',
            layout: VirtualKeyboardLayout.otp(),
            tapText: '1',
            expected: '1',
          ),
          (
            name: 'date',
            layout: VirtualKeyboardLayout.date(),
            tapText: '/',
            expected: '/',
          ),
          (
            name: 'time',
            layout: VirtualKeyboardLayout.time(),
            tapText: 'AM',
            expected: 'AM',
          ),
          (
            name: 'currency',
            layout: VirtualKeyboardLayout.currency(),
            tapText: '\$',
            expected: '\$',
          ),
          (
            name: 'scientificCalculator',
            layout: VirtualKeyboardLayout.scientificCalculator(),
            tapText: '^',
            expected: '^',
          ),
        ];

    for (final c in layoutCases) {
      testWidgets('${c.name} inserts tapped key text', (tester) async {
        final controller = TextEditingController();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: FlutterKeyboard(controller: controller, layout: c.layout),
            ),
          ),
        );

        await tester.tap(find.text(c.tapText).first);
        await tester.pump();

        expect(controller.text, c.expected);
      });
    }

    testWidgets('shift toggles uppercase and lowercase in alphanumeric', (
      tester,
    ) async {
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
      await tester.tap(find.byIcon(Icons.arrow_upward));
      await tester.pump();
      await tester.tap(find.text('w'));
      await tester.pump();

      expect(controller.text, 'Qw');
    });

    testWidgets('special toggle path ?123 -> #+= -> ABC works', (tester) async {
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
    });

    testWidgets('calculator keyboard evaluates and reports errors', (
      tester,
    ) async {
      final controller = TextEditingController();
      String? error;
      String? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CalculatorKeyboard(
              controller: controller,
              onError: (value) => error = value,
              onEvaluated: (value) => result = value,
            ),
          ),
        ),
      );

      await tester.tap(find.text('1').first);
      await tester.pump();
      await tester.tap(find.text('/').first);
      await tester.pump();
      await tester.tap(find.text('0').first);
      await tester.pump();
      await tester.tap(find.text('=').first);
      await tester.pump();
      await tester.pump();

      expect(error, isNotNull);

      controller.clear();
      await tester.tap(find.text('9').first);
      await tester.pump();
      await tester.tap(find.text('/').first);
      await tester.pump();
      await tester.tap(find.text('3').first);
      await tester.pump();
      await tester.tap(find.byIcon(Icons.check));
      await tester.pump();

      expect(result, '3');
      expect(controller.text, '3');
    });
  });
}
