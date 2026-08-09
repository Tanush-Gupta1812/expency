import 'package:flutter_test/flutter_test.dart';
import 'package:expency/main.dart';

void main() {
  testWidgets('Expency app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ExpencyApp());
    expect(find.text('FINANCE_CORE'), findsWidgets);
  });
}
