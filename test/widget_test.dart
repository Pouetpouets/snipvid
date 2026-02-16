import 'package:flutter_test/flutter_test.dart';
import 'package:snipvid/main.dart';

void main() {
  testWidgets('App should build', (WidgetTester tester) async {
    await tester.pumpWidget(const SnipvidApp());
    expect(find.text('SNIPVID'), findsOneWidget);
  });
}
