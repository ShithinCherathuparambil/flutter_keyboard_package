import 'package:flutter_test/flutter_test.dart';

import 'package:example/main.dart';

void main() {
  testWidgets('keyboard demo smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('All Keyboard Layouts Demo'), findsOneWidget);
    expect(find.text('Future Keyboard Studio'), findsOneWidget);
    expect(find.text('Calculator Keyboard'), findsOneWidget);
    expect(find.text('Special Characters Layout'), findsOneWidget);
    expect(find.text('Secondary Special Characters Layout'), findsOneWidget);

    await tester.tap(find.text('123').first);
    await tester.pump();
    expect(find.text('#+='), findsWidgets);
  });
}
