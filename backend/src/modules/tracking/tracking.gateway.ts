import { Server, Socket } from 'socket.io';
import { TrackingService } from './tracking.service.js';

export class TrackingGateway {
  private io: Server;
  private trackingService: TrackingService;

  constructor(io: Server) {
    this.io = io;
    this.trackingService = new TrackingService();
    this.initialize();
  }

  private initialize() {
    this.io.on('connection', (socket: Socket) => {
      console.log(`🔌 Cliente WebSocket conectado: ${socket.id}`);

      // Suscribir a pasajero a una sala específica de su ruta
      socket.on('join:route', (route_id: string) => {
        socket.join(`route:${route_id}`);
        console.log(`📍 Cliente ${socket.id} suscrito al canal en vivo de la ruta: ${route_id}`);
      });

      // Recibir actualización de coordenadas desde el conductor/GPS
      socket.on('bus:location:update', async (payload: {
        bus_id: string;
        route_id: string;
        latitude: number;
        longitude: number;
        speed?: number;
        heading?: number;
      }) => {
        try {
          // 1. Guardar/Actualizar en la base de datos de manera asíncrona
          await this.trackingService.processLocationUpdate({
            bus_id: payload.bus_id,
            latitude: payload.latitude,
            longitude: payload.longitude,
          });

          // 2. Emitir las nuevas coordenadas en tiempo real a los pasajeros suscritos a la ruta
          const broadcastPayload = {
            ...payload,
            timestamp: new Date().toISOString(),
          };

          this.io.to(`route:${payload.route_id}`).emit(`route:${payload.route_id}:buses`, broadcastPayload);
        } catch (error: any) {
          console.error(`❌ Error al procesar coordenadas WebSocket: ${error.message}`);
        }
      });

      socket.on('disconnect', () => {
        console.log(`🔌 Cliente WebSocket desconectado: ${socket.id}`);
      });
    });
  }
}