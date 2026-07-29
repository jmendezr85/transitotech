import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:transitotech/config/theme/app_config.dart';
import 'package:transitotech/core/services/api_service.dart';
import 'package:transitotech/core/services/websocket_service.dart';

class MapScreen extends StatefulWidget {
  final AppConfig config;

  const MapScreen({super.key, required this.config});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final ApiService _apiService = ApiService();
  final WebSocketService _wsService = WebSocketService();
  final MapController _mapController = MapController();

  // Coordenadas iniciales por defecto (Centro de la Ciudad)
  final LatLng _currentPassengerLocation = const LatLng(7.8890, -72.5070);
  List<dynamic> _routes = [];
  String? _selectedRouteId;
  bool _isLoading = true;

  // Ubicaciones de buses en tiempo real recibidas por WebSocket
  final Map<String, LatLng> _liveBuses = {};

  @override
  void initState() {
    super.initState();
    _initPassengerMap();
  }

  Future<void> _initPassengerMap() async {
    try {
      final routesData = await _apiService.getRoutes();
      if (mounted) {
        setState(() {
          _routes = routesData;
          if (_routes.isNotEmpty) {
            _selectedRouteId = _routes.first['id'].toString();
            _subscribeToRouteLiveTracking(_selectedRouteId!);
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('⚠️ Error cargando rutas en el mapa: $e');
      if (mounted) {
        setState(() {
          _isLoading = false; // Desbloquear la UI siempre
        });
      }
    }
  }

  void _subscribeToRouteLiveTracking(String routeId) {
    _wsService.disconnect();
    _liveBuses.clear();

    _wsService.connect(routeId, (data) {
      if (data != null && data['lat'] != null && data['lng'] != null) {
        final String busId = data['bus_id'] ?? 'BUS-ACTIVE';
        final double lat = (data['lat'] as num).toDouble();
        final double lng = (data['lng'] as num).toDouble();

        setState(() {
          _liveBuses[busId] = LatLng(lat, lng);
        });
      }
    });
  }

  @override
  void dispose() {
    _wsService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.config.appName} | Mapa en Vivo'),
        backgroundColor: widget.config.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            tooltip: 'Centrar en mi ubicación',
            onPressed: () {
              _mapController.move(_currentPassengerLocation, 15.0);
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar Sesión',
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                // 1. Mapa Interactivo de OpenStreetMap
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _currentPassengerLocation,
                    initialZoom: 14.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.transitotech.app',
                    ),
                    // Capa de Marcadores (Pasajero + Buses en Vivo)
                    MarkerLayer(
                      markers: [
                        // Marcador Ubicación Pasajero
                        Marker(
                          point: _currentPassengerLocation,
                          width: 40,
                          height: 40,
                          child: const Icon(
                            Icons.person_pin_circle,
                            color: Colors.blue,
                            size: 40,
                          ),
                        ),
                        // Marcadores de Autobuses transmitiendo por WebSockets
                        ..._liveBuses.entries.map((entry) {
                          return Marker(
                            point: entry.value,
                            width: 45,
                            height: 45,
                            child: Tooltip(
                              message: 'Bus en Movimiento (${entry.key})',
                              child: const CircleAvatar(
                                backgroundColor: Colors.green,
                                child: Icon(
                                  Icons.directions_bus,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ],
                ),

                // 2. Panel Flotante Superior: Selector de Ruta
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedRouteId,
                          isExpanded: true,
                          hint: const Text('Selecciona una Ruta'),
                          items: _routes.map((route) {
                            return DropdownMenuItem<String>(
                              value: route['id'].toString(),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.alt_route,
                                    color: Colors.blue,
                                  ),
                                  const SizedBox(width: 12),
                                  Text('${route['code']} - ${route['name']}'),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedRouteId = value;
                              });
                              _subscribeToRouteLiveTracking(value);
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),

                // 3. Indicador Flotante de Conexión en Tiempo Real
                Positioned(
                  bottom: 24,
                  left: 16,
                  right: 16,
                  child: Card(
                    color: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _liveBuses.isNotEmpty ? Icons.wifi : Icons.wifi_off,
                            color: _liveBuses.isNotEmpty
                                ? Colors.greenAccent
                                : Colors.orangeAccent,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            _liveBuses.isNotEmpty
                                ? 'Buses rastreados en vivo: ${_liveBuses.length}'
                                : 'Esperando transmisión de vehículos en esta ruta...',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
