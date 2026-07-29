import 'dart:async';
import 'package:flutter/material.dart';
import 'package:transitotech/config/theme/app_config.dart';
import 'package:transitotech/core/services/api_service.dart';
import 'package:transitotech/core/services/websocket_service.dart';

class DriverShiftScreen extends StatefulWidget {
  final AppConfig config;

  const DriverShiftScreen({super.key, required this.config});

  @override
  State<DriverShiftScreen> createState() => _DriverShiftScreenState();
}

class _DriverShiftScreenState extends State<DriverShiftScreen> {
  final ApiService _apiService = ApiService();
  final WebSocketService _wsService = WebSocketService();

  bool _isShiftActive = false;
  bool _isLoading = true;
  List<dynamic> _routes = [];
  String? _selectedRouteId;
  String _busPlate = 'BUS-001';

  // Simulador interno de movimiento GPS para desarrollo local
  Timer? _gpsSimulationTimer;
  double _currentLat = 7.8890;
  double _currentLng = -72.5070;

  @override
  void initState() {
    super.initState();
    _loadRoutes();
  }

  Future<void> _loadRoutes() async {
    final routesData = await _apiService.getRoutes();
    if (mounted) {
      setState(() {
        _routes = routesData;
        if (_routes.isNotEmpty) {
          _selectedRouteId = _routes.first['id'].toString();
        }
        _isLoading = false;
      });
    }
  }

  void _toggleShift() {
    if (_isShiftActive) {
      _stopGpsTransmission();
    } else {
      _startGpsTransmission();
    }
  }

  void _startGpsTransmission() {
    if (_selectedRouteId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor selecciona una ruta activa.')),
      );
      return;
    }

    setState(() {
      _isShiftActive = true;
    });

    // Conectar al canal WebSocket de la ruta seleccionada
    _wsService.connect(_selectedRouteId!, (data) {
      debugPrint('📍 Coordenada confirmada por servidor: $data');
    });

    // Transmitir evento periódicamente cada 3 segundos hacia el servidor Node.js
    _gpsSimulationTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        _currentLat += 0.0003;
        _currentLng += 0.0003;
      });

      // Emitir paquete WebSocket que el backend retransmite al pasajero
      _wsService.emitLocationUpdate(
        routeId: _selectedRouteId!,
        busId: _busPlate,
        lat: _currentLat,
        lng: _currentLng,
      );

      debugPrint(
        '⚡ Transmitiendo GPS Local: Lat $_currentLat, Lng $_currentLng',
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Turno iniciado. Transmitiendo GPS en tiempo real.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _stopGpsTransmission() {
    _gpsSimulationTimer?.cancel();
    _wsService.disconnect();

    setState(() {
      _isShiftActive = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Turno finalizado. Transmisión de GPS detenida.'),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  @override
  void dispose() {
    _gpsSimulationTimer?.cancel();
    _wsService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel del Conductor | Transmisión GPS'),
        backgroundColor: widget.config.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar Sesión',
            onPressed: () {
              if (_isShiftActive) _stopGpsTransmission();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    elevation: 4,
                    color: _isShiftActive
                        ? Colors.green.shade50
                        : Colors.grey.shade100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: _isShiftActive
                            ? Colors.green
                            : Colors.grey.shade400,
                        width: 2,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Icon(
                            _isShiftActive
                                ? Icons.sensors_rounded
                                : Icons.sensors_off_rounded,
                            size: 64,
                            color: _isShiftActive ? Colors.green : Colors.grey,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _isShiftActive
                                ? 'TRANSMITIENDO EN VIVO 🔴'
                                : 'TURNO INACTIVO (EN ESPERA)',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: _isShiftActive
                                  ? Colors.green.shade900
                                  : Colors.grey.shade800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _isShiftActive
                                ? 'Ubicación actual: ${_currentLat.toStringAsFixed(4)}, ${_currentLng.toStringAsFixed(4)}'
                                : 'Selecciona tu ruta e inicia turno para transmitir.',
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Configuración de Turno',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  DropdownButtonFormField<String>(
                    value: _selectedRouteId,
                    decoration: const InputDecoration(
                      labelText: 'Ruta Asignada',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.alt_route),
                    ),
                    items: _routes.map((route) {
                      return DropdownMenuItem<String>(
                        value: route['id'].toString(),
                        child: Text('${route['code']} - ${route['name']}'),
                      );
                    }).toList(),
                    onChanged: _isShiftActive
                        ? null
                        : (value) {
                            setState(() => _selectedRouteId = value);
                          },
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    initialValue: _busPlate,
                    enabled: !_isShiftActive,
                    decoration: const InputDecoration(
                      labelText: 'Placa del Autobús',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.directions_bus),
                    ),
                    onChanged: (val) => _busPlate = val,
                  ),

                  const Spacer(),

                  SizedBox(
                    height: 60,
                    child: ElevatedButton.icon(
                      icon: Icon(
                        _isShiftActive
                            ? Icons.stop_circle
                            : Icons.play_circle_fill,
                      ),
                      label: Text(
                        _isShiftActive ? 'FINALIZAR TURNO' : 'INICIAR TURNO',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isShiftActive
                            ? Colors.red
                            : widget.config.primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _toggleShift,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
