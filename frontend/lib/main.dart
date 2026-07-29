import 'package:flutter/material.dart';
import 'package:transitotech/config/theme/app_config.dart';
import 'package:transitotech/config/theme/app_theme.dart';
import 'package:transitotech/features/auth/presentation/screens/login_screen.dart';
import 'package:transitotech/features/map/presentation/screens/map_screen.dart';
import 'package:transitotech/features/admin/presentation/screens/admin_dashboard_screen.dart';
import 'package:transitotech/features/driver/presentation/screens/driver_shift_screen.dart';

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
        '/driver/shift': (context) => DriverShiftScreen(config: defaultConfig),
      },
    );
  }
}
