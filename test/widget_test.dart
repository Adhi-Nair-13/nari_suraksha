import 'package:flutter_test/flutter_test.dart';
import 'package:nari_suraksha/app.dart';

void main() {
  testWidgets('App renders Nari Suraksha title', (WidgetTester tester) async {
    await tester.pumpWidget(const NariSurakshaApp());
    expect(find.text('Nari Suraksha'), findsOneWidget);
  });
}
