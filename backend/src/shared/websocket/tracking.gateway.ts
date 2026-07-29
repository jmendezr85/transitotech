import { Server, Socket } from 'socket.io';

export const setupTrackingGateway = (io: Server): void => {
  io.on('connection', (socket: Socket) => {
    console.log(`⚡ Cliente WebSocket conectado: ${socket.id}`);

    // Suscripción de Pasajeros o Conductores a la sala de la Ruta
    socket.on('join_route', (routeId: string | number) => {
      const cleanRouteId = String(routeId).trim();
      const roomName = `route_${cleanRouteId}`;
      
      socket.join(roomName);
      console.log(`📌 Cliente ${socket.id} unido exitosamente a la sala: ${roomName}`);
    });

    // Evento de emisión de GPS desde la App del Conductor
    socket.on('update_location', (data: { route_id: string | number; bus_id: string; lat: number; lng: number }) => {
      const cleanRouteId = String(data.route_id).trim();
      const roomName = `route_${cleanRouteId}`;

      console.log(`📍 Re-emitiendo posición de bus [${data.bus_id}] a la sala [${roomName}]: (${data.lat}, ${data.lng})`);

      // Retransmisión a todos los pasajeros conectados a esa sala
      io.to(roomName).emit('location_updated', {
        bus_id: data.bus_id || 'BUS-001',
        lat: Number(data.lat),
        lng: Number(data.lng),
        timestamp: new Date().toISOString(),
      });
    });

    socket.on('disconnect', () => {
      console.log(`🔌 Cliente WebSocket desconectado: ${socket.id}`);
    });
  });
};