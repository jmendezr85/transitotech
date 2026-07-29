import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class WebSocketService {
  io.Socket? _socket;

  void connect(String routeId, Function(dynamic) onLocationReceived) {
    final cleanRouteId = routeId.trim();

    if (_socket == null) {
      _socket = io.io('http://localhost:3000', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });

      _socket?.connect();

      _socket?.onConnect((_) {
        debugPrint('⚡ Conectado al servidor de WebSockets Local');
        _socket?.emit('join_route', cleanRouteId);
      });
    } else {
      if (!_socket!.connected) {
        _socket?.connect();
      }
      _socket?.emit('join_route', cleanRouteId);
    }

    // Limpieza de listeners previos y registro del evento re-emitido por Node.js
    _socket?.off('location_updated');
    _socket?.on('location_updated', (data) {
      debugPrint('📩 Coordenada recibida en tiempo real: $data');
      onLocationReceived(data);
    });

    _socket?.onDisconnect((_) {
      debugPrint('🔌 Desconectado del servicio WebSocket');
    });
  }

  void emitLocationUpdate({
    required String routeId,
    required String busId,
    required double lat,
    required double lng,
  }) {
    if (_socket != null && _socket!.connected) {
      _socket?.emit('update_location', {
        'route_id': routeId.trim(),
        'bus_id': busId,
        'lat': lat,
        'lng': lng,
      });
    }
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }
}
