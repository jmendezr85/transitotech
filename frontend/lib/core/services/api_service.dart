import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://localhost:3000/api/v1',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );

  /// Obtener el listado de rutas activas
  Future<List<dynamic>> getRoutes() async {
    try {
      final response = await _dio.get('/routes');
      if (response.data['success'] == true) {
        return response.data['data'] as List<dynamic>;
      }
      return [];
    } catch (e) {
      debugPrint('❌ Error al obtener rutas: $e');
      return [];
    }
  }

  /// Obtener detalle de una ruta específica con sus coordenadas GeoJSON
  Future<Map<String, dynamic>?> getRouteDetails(String routeId) async {
    try {
      final response = await _dio.get('/routes/$routeId');
      if (response.data['success'] == true) {
        return response.data['data'] as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      debugPrint('❌ Error al obtener detalle de ruta: $e');
      return null;
    }
  }

  /// Obtener la lista de buses activos en línea
  Future<List<dynamic>> getActiveBuses() async {
    try {
      final response = await _dio.get('/tracking/buses/active');
      if (response.data['success'] == true) {
        return response.data['data'] as List<dynamic>;
      }
      return [];
    } catch (e) {
      debugPrint('❌ Error al obtener buses activos: $e');
      return [];
    }
  }
}
