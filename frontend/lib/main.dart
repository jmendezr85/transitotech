import 'package:flutter/material.dart';
import 'config/theme/app_config.dart';
import 'config/theme/app_theme.dart';
import 'features/map/presentation/screens/map_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Instanciar configuración de Marca Blanca por defecto
  final config = AppConfig.defaultConfig();

  runApp(MyApp(config: config));
}

class MyApp extends StatelessWidget {
  final AppConfig config;

  const MyApp({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: config.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getTheme(config),
      home: MapScreen(config: config),
    );
  }
}
