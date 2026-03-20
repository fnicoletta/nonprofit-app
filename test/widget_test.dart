import 'package:flutter_test/flutter_test.dart';
import 'package:nonprofit_app/app.dart';

void main() {
  testWidgets('App renders home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const NonprofitApp());
    expect(find.text('Hope Foundation'), findsOneWidget);
  });
}
