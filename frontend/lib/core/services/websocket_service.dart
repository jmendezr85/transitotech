import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class WebSocketService {
  late io.Socket _socket;

  void connect(
    String routeId,
    Function(Map<String, dynamic>) onLocationUpdate,
  ) {
    // Configurar cliente de Socket.io apuntando a nuestro backend local
    _socket = io.io(
      'http://localhost:3000',
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    _socket.connect();

    _socket.onConnect((_) {
      debugPrint('⚡ Conectado al servidor de WebSockets');
      // Suscribirse a la sala específica de la ruta seleccionada
      _socket.emit('join:route', routeId);
    });

    // Escuchar el evento de transmisión en tiempo real de los autobuses de esta ruta
    _socket.on('route:$routeId:buses', (data) {
      if (data != null && data is Map<String, dynamic>) {
        onLocationUpdate(data);
      }
    });

    _socket.onDisconnect((_) {
      debugPrint('🔌 Desconectado del servidor de WebSockets');
    });

    _socket.onError((error) {
      debugPrint('❌ Error en WebSocket: $error');
    });
  }

  void disconnect() {
    _socket.disconnect();
    _socket.dispose();
  }
}
