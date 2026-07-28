import 'package:flutter/material.dart';

/// Configuración de Marca Blanca (White-Label)
/// Permite cambiar el nombre, logos y colores corporativos según el cliente/empresa.
class AppConfig {
  final String appName;
  final String logoPath;
  final Color primaryColor;
  final Color secondaryColor;
  final Color backgroundColor;
  final Color surfaceColor;

  const AppConfig({
    required this.appName,
    required this.logoPath,
    required this.primaryColor,
    required this.secondaryColor,
    this.backgroundColor = const Color(0xFFF8F9FA),
    this.surfaceColor = Colors.white,
  });

  /// Configuración por Defecto (TransitoTech Standard)
  factory AppConfig.defaultConfig() {
    return const AppConfig(
      appName: 'TransitoTech',
      logoPath: 'assets/images/logo.png',
      primaryColor: Color(0xFF1E88E5), // Azul corporativo por defecto
      secondaryColor: Color(0xFF4CAF50), // Verde indicador online
    );
  }
}
