import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_app/config/theme/app_config.dart';
import 'package:frontend_app/main.dart';

void main() {
  testWidgets('Carga inicial de la aplicación TransitoTech', (
    WidgetTester tester,
  ) async {
    final config = AppConfig.defaultConfig();
    await tester.pumpWidget(MyApp(config: config));
  });
}
