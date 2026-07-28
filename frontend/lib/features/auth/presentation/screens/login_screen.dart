import 'package:flutter/material.dart';
import '../../../../core/services/api_service.dart';
import '../../../../config/theme/app_config.dart';

class LoginScreen extends StatefulWidget {
  final AppConfig config;

  const LoginScreen({super.key, required this.config});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _apiService = ApiService();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Por favor completa todos los campos.';
      });
      return;
    }

    final response = await _apiService.login(email, password);

    setState(() => _isLoading = false);

    if (response != null && response['success'] == true) {
      final user = response['data']['user'];
      final String role = user['role'] ?? 'passenger';

      if (!mounted) return;

      // Redirección inteligente basada en el Rol (RBAC)
      switch (role) {
        case 'admin':
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Bienvenido Administrador: ${user['full_name']}'),
            ),
          );
          // Redirigir al Dashboard de Admin (Opción 1)
          Navigator.pushReplacementNamed(context, '/admin/dashboard');
          break;
        case 'driver':
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Bienvenido Conductor: ${user['full_name']}'),
            ),
          );
          // Redirigir al Modo Chofer GPS (Opción 2)
          Navigator.pushReplacementNamed(context, '/driver/shift');
          break;
        case 'passenger':
        default:
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Bienvenido Pasajero: ${user['full_name']}'),
            ),
          );
          // Redirigir al Mapa de Rastreo
          Navigator.pushReplacementNamed(context, '/map');
          break;
      }
    } else {
      setState(() {
        _errorMessage =
            response?['message'] ??
            'Credenciales inválidas. Inténtalo de nuevo.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.directions_bus_filled_rounded,
                size: 72,
                color: widget.config.primaryColor,
              ),
              const SizedBox(height: 16),
              Text(
                widget.config.appName,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: widget.config.primaryColor,
                ),
              ),
              const Text(
                'Sistema de Transporte Inteligente',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 32),

              if (_errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Correo Electrónico',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.config.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _isLoading ? null : _handleLogin,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'INICIAR SESIÓN',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
