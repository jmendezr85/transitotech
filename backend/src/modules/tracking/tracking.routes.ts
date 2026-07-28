import { Router } from 'express';
import { TrackingController } from './tracking.controller.js';

const router = Router();
const trackingController = new TrackingController();

router.get('/buses/active', trackingController.getActiveBuses);

export default router;