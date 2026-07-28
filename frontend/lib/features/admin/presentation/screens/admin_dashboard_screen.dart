import 'package:flutter/material.dart';
import '../../../../config/theme/app_config.dart';
import '../../../../core/services/api_service.dart';

class AdminDashboardScreen extends StatefulWidget {
  final AppConfig config;

  const AdminDashboardScreen({super.key, required this.config});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final ApiService _apiService = ApiService();
  int _selectedMenuIndex = 0;
  bool _isLoading = true;
  List<dynamic> _routes = [];
  List<dynamic> _activeBuses = [];

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);
    final routesData = await _apiService.getRoutes();
    final busesData = await _apiService.getActiveBuses();

    if (mounted) {
      setState(() {
        _routes = routesData;
        _activeBuses = busesData;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.config.appName} | Panel de Control Administrativo',
        ),
        backgroundColor: widget.config.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar Datos',
            onPressed: _loadDashboardData,
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
      body: Row(
        children: [
          // 1. Panel Lateral de Navegación (Sidebar)
          NavigationRail(
            selectedIndex: _selectedMenuIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedMenuIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: Text('Métricas'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.alt_route_outlined),
                selectedIcon: Icon(Icons.alt_route),
                label: Text('Rutas'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.directions_bus_outlined),
                selectedIcon: Icon(Icons.directions_bus),
                label: Text('Flota'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),

          // 2. Área Contenedora Principal
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildSelectedTabContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedTabContent() {
    switch (_selectedMenuIndex) {
      case 0:
        return _buildMetricsTab();
      case 1:
        return _buildRoutesTab();
      case 2:
        return _buildFleetTab();
      default:
        return _buildMetricsTab();
    }
  }

  // Vista 1: Métricas Principales del Sistema
  Widget _buildMetricsTab() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Resumen Operativo',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildMetricCard(
                title: 'Rutas Registradas',
                value: '${_routes.length}',
                icon: Icons.map_outlined,
                color: Colors.blue,
              ),
              const SizedBox(width: 16),
              _buildMetricCard(
                title: 'Buses en Servicio',
                value: '${_activeBuses.length}',
                icon: Icons.directions_bus_filled_outlined,
                color: Colors.green,
              ),
              const SizedBox(width: 16),
              _buildMetricCard(
                title: 'Estado del Servidor',
                value: 'Online (Cloud)',
                icon: Icons.cloud_done_outlined,
                color: Colors.purple,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: color.withValues(alpha: 0.1),
                child: Icon(icon, color: color, size: 30),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Vista 2: Lista de Rutas
  Widget _buildRoutesTab() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Gestión de Rutas',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Nueva Ruta'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.config.primaryColor,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Formulario de creación de rutas en desarrollo.',
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _routes.isEmpty
                ? const Center(child: Text('No hay rutas registradas.'))
                : ListView.builder(
                    itemCount: _routes.length,
                    itemBuilder: (context, index) {
                      final route = _routes[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue.shade100,
                            child: const Icon(
                              Icons.alt_route,
                              color: Colors.blue,
                            ),
                          ),
                          title: Text('${route['code']} - ${route['name']}'),
                          subtitle: Text('ID: ${route['id']}'),
                          trailing: const Icon(Icons.chevron_right),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Vista 3: Estado de la Flota
  Widget _buildFleetTab() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Estado de la Flota de Autobuses',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _activeBuses.isEmpty
                ? const Center(
                    child: Text(
                      'No hay vehículos transmitiendo en vivo actualmente.',
                    ),
                  )
                : ListView.builder(
                    itemCount: _activeBuses.length,
                    itemBuilder: (context, index) {
                      final bus = _activeBuses[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.greenAccent,
                            child: Icon(
                              Icons.directions_bus,
                              color: Colors.green,
                            ),
                          ),
                          title: Text('Placa: ${bus['plate']}'),
                          subtitle: Text(
                            'Ruta Asignada: ${bus['route_code'] ?? "Sin Asignar"}',
                          ),
                          trailing: const Chip(
                            label: Text(
                              'EN LÍNEA',
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.green,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
