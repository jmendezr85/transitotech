import { Router, Request, Response, NextFunction } from 'express';
import { pool } from '../../config/database.js';

const router = Router();

// GET /api/v1/routes
router.get('/', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const result = await pool.query(
      'SELECT id, code, name, description, is_active FROM public.routes WHERE is_active = true ORDER BY code ASC'
    );
    
    return res.status(200).json({
      success: true,
      data: result.rows,
    });
  } catch (error) {
    console.error('💥 Error al consultar la tabla public.routes:', error);
    next(error);
  }
});

export const routesRouter = router;