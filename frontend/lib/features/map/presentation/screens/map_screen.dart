import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../config/theme/app_config.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/websocket_service.dart';

class MapScreen extends StatefulWidget {
  final AppConfig config;

  const MapScreen({super.key, required this.config});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final ApiService _apiService = ApiService();
  final WebSocketService _webSocketService = WebSocketService();
  final MapController _mapController = MapController();

  List<LatLng> _routePoints = [];
  final Map<String, LatLng> _busPositions = {};
  bool _isLoading = true;
  String _activeRouteName = 'Cargando ruta...';
  final String _testRouteId = 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11';

  @override
  void initState() {
    super.initState();
    _loadInitialMapData();
    _initLiveTracking();
  }

  @override
  void dispose() {
    _webSocketService.disconnect();
    super.dispose();
  }

  Future<void> _loadInitialMapData() async {
    setState(() => _isLoading = true);

    // 1. Cargar trazado GeoJSON de la ruta
    final routeData = await _apiService.getRouteDetails(_testRouteId);
    if (routeData != null && routeData['path'] != null) {
      final coordinates = routeData['path']['coordinates'] as List<dynamic>;
      _routePoints = coordinates
          .map((coord) => LatLng(coord[1].toDouble(), coord[0].toDouble()))
          .toList();

      _activeRouteName = '${routeData['code']} - ${routeData['name']}';
    }

    // 2. Cargar la última posición conocida de los autobuses desde la API REST
    final buses = await _apiService.getActiveBuses();
    for (var bus in buses) {
      final location = bus['last_location'];
      if (location != null && location['coordinates'] != null) {
        final coords = location['coordinates'];
        _busPositions[bus['bus_id']] = LatLng(
          coords[1].toDouble(),
          coords[0].toDouble(),
        );
      }
    }

    setState(() => _isLoading = false);
  }

  void _initLiveTracking() {
    // Escuchar actualizaciones GPS en vivo por WebSockets
    _webSocketService.connect(_testRouteId, (data) {
      final String? busId = data['bus_id'];
      final double? lat = (data['latitude'] as num?)?.toDouble();
      final double? lng = (data['longitude'] as num?)?.toDouble();

      if (busId != null && lat != null && lng != null) {
        setState(() {
          _busPositions[busId] = LatLng(lat, lng);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final defaultCenter = LatLng(7.889, -72.507);

    // Construir marcadores reactivos desde el mapa de posiciones
    final markers = _busPositions.entries.map((entry) {
      return Marker(
        point: entry.value,
        width: 42,
        height: 42,
        child: Container(
          decoration: BoxDecoration(
            color: widget.config.secondaryColor,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2.5),
            boxShadow: const [
              BoxShadow(
                color: Colors.black38,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.directions_bus,
            color: Colors.white,
            size: 22,
          ),
        ),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.config.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadInitialMapData,
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: defaultCenter,
              initialZoom: 14.5,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.transitotech.app',
              ),
              if (_routePoints.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _routePoints,
                      strokeWidth: 5.0,
                      color: widget.config.primaryColor,
                    ),
                  ],
                ),
              MarkerLayer(markers: markers),
            ],
          ),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Icon(Icons.alt_route, color: widget.config.primaryColor),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _activeRouteName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (_isLoading)
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
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
