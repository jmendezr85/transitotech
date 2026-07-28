import { io } from 'socket.io-client';

// Coordenadas reales del trazado de la RUTA-101 (Cúcuta)
const routeCoordinates = [
  { lat: 7.8890, lng: -72.5070 },
  { lat: 7.8895, lng: -72.5073 },
  { lat: 7.8900, lng: -72.5078 },
  { lat: 7.8905, lng: -72.5082 },
  { lat: 7.8910, lng: -72.5085 },
  { lat: 7.8920, lng: -72.5090 },
  { lat: 7.8935, lng: -72.5095 },
  { lat: 7.8950, lng: -72.5100 }
];

const busData = {
  bus_id: 'f47ac10b-58cc-4372-a567-0e02b2c3d479', // ID del BUS-001 cargado en el seeder
  route_id: 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', // ID de la RUTA-101
  plate: 'BUS-001'
};

const socket = io('http://localhost:3000', {
  transports: ['websocket']
});

socket.on('connect', () => {
  console.log('📡 [Simulador GPS]: Conectado al servidor WebSocket de TransitoTech');
  console.log(`🚌 Iniciando transmisión en vivo para el vehículo ${busData.plate}...`);

  let index = 0;
  let forward = true;

  // Emitir nueva coordenada GPS cada 2 segundos
  setInterval(() => {
    const currentPoint = routeCoordinates[index];
    
    const payload = {
      bus_id: busData.bus_id,
      route_id: busData.route_id,
      latitude: currentPoint.lat,
      longitude: currentPoint.lng,
      speed: Math.floor(Math.random() * (45 - 20 + 1)) + 20, // Velocidad simulada entre 20 y 45 km/h
      heading: 180.0
    };

    socket.emit('bus:location:update', payload);
    console.log(`📍 [GPS Emitido]: Lat ${payload.latitude.toFixed(4)}, Lng ${payload.longitude.toFixed(4)} | Vel: ${payload.speed} km/h`);

    // Recorrer de ida y vuelta la ruta continuamente
    if (forward) {
      index++;
      if (index >= routeCoordinates.length - 1) forward = false;
    } else {
      index--;
      if (index <= 0) forward = true;
    }
  }, 2000);
});

socket.on('disconnect', () => {
  console.log('🔌 [Simulador GPS]: Desconectado del servidor.');
});

socket.on('connect_error', (err) => {
  console.error('❌ [Error de conexión]:', err.message);
});