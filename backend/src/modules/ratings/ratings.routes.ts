import { Router } from 'express';
import { RatingsController } from './ratings.controller.js';
import { authenticate } from '../../shared/middlewares/authenticate.js';

const router = Router();
const ratingsController = new RatingsController();

// POST protegido: Requiere Token JWT
router.post('/', authenticate, ratingsController.create);

// GET público: Consultar promedio de un bus
router.get('/bus/:bus_id', ratingsController.getByBus);

export default router;