import 'package:flutter/material.dart';
import 'config/theme/app_config.dart';
import 'config/theme/app_theme.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/map/presentation/screens/map_screen.dart';
import 'features/admin/presentation/screens/admin_dashboard_screen.dart';

void main() {
  runApp(const TransitoTechApp());
}

class TransitoTechApp extends StatelessWidget {
  const TransitoTechApp({super.key});

  @override
  Widget build(BuildContext context) {
    final defaultConfig = AppConfig.defaultConfig();

    return MaterialApp(
      title: defaultConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getTheme(defaultConfig),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(config: defaultConfig),
        '/map': (context) => MapScreen(config: defaultConfig),
        '/admin/dashboard': (context) =>
            AdminDashboardScreen(config: defaultConfig),
        '/driver/shift': (context) => Scaffold(
          appBar: AppBar(title: const Text('Modo Conductor - Transmisión GPS')),
          body: const Center(
            child: Text('🚌 Módulo 2: App Conductor (Próximo paso)'),
          ),
        ),
      },
    );
  }
}
