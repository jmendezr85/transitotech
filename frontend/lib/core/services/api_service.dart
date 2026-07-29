import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://localhost:3000/api/v1',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  /// Método de Autenticación Universal
  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      return response.data;
    } catch (e) {
      if (e is DioException && e.response != null) {
        return e.response?.data;
      }
      debugPrint('❌ Error en Login: $e');
      return null;
    }
  }

  /// Obtener el listado de rutas activas
  Future<List<dynamic>> getRoutes() async {
    try {
      final response = await _dio.get('/routes');
      if (response.statusCode == 200) {
        if (response.data is Map && response.data['data'] != null) {
          return response.data['data'] as List<dynamic>;
        } else if (response.data is List) {
          return response.data as List<dynamic>;
        }
      }
      return [];
    } catch (e) {
      debugPrint(' Error al obtener rutas: $e');
      return [];
    }
  }

  /// Obtener detalle de una ruta específica
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

  /// Obtener la lista de buses activos
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
