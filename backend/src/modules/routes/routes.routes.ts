import { Router } from 'express';
import { RoutesController } from './routes.controller.js';

const router = Router();
const routesController = new RoutesController();

router.get('/', routesController.getAllRoutes);
router.get('/:id', routesController.getRouteById);

export default router;