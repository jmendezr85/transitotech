import 'package:flutter_test/flutter_test.dart';
import 'package:transitotech/main.dart';

void main() {
  testWidgets('Carga inicial de TransitoTech', (WidgetTester tester) async {
    await tester.pumpWidget(const TransitoTechApp());
    expect(find.byType(TransitoTechApp), findsOneWidget);
  });
}
