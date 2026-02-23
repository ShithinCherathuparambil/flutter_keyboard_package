import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:future_keyboard_kit/future_keyboard_kit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('keyboard integration flow', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    final scrollable = find.byType(Scrollable).first;

    // FutureKeyboard: shift toggles visible labels and input casing.
    final futureFieldFinder = find.widgetWithText(
      TextField,
      'Type with themes, snippets and predictions',
    );
    expect(futureFieldFinder, findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_upward).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Q').first);
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.arrow_upward).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('q').first);
    await tester.pumpAndSettle();

    final futureField = tester.widget<TextField>(futureFieldFinder);
    expect(futureField.controller?.text, 'Qq');

    // CalculatorKeyboard: expression evaluation.
    final calculatorFieldFinder = find.widgetWithText(
      TextField,
      'Example: 12/3+5',
    );
    expect(calculatorFieldFinder, findsOneWidget);

    final calculatorKeyboardFinder = find.byType(CalculatorKeyboard);
    await tester.scrollUntilVisible(
      calculatorKeyboardFinder,
      300,
      scrollable: scrollable,
    );
    await tester.pumpAndSettle();

    await tester.tap(
      find.descendant(of: calculatorKeyboardFinder, matching: find.text('1')),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(of: calculatorKeyboardFinder, matching: find.text('+')),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(of: calculatorKeyboardFinder, matching: find.text('2')),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(of: calculatorKeyboardFinder, matching: find.text('=')),
    );
    await tester.pumpAndSettle();

    final calculatorField = tester.widget<TextField>(calculatorFieldFinder);
    expect(calculatorField.controller?.text, '3');

    // Special layout: 'ABC' returns to alphabetic keys.
    await tester.scrollUntilVisible(
      find.text('Special Characters Layout'),
      500,
      scrollable: scrollable,
    );
    await tester.pumpAndSettle();

    final specialFieldFinder = find.widgetWithText(TextField, 'Type symbols');
    expect(specialFieldFinder, findsOneWidget);

    await tester.tap(find.text('ABC').first);
    await tester.pumpAndSettle();
    expect(find.text('q'), findsWidgets);

    final specialField = tester.widget<TextField>(specialFieldFinder);
    expect(specialField.controller?.text, '');
  });
}
