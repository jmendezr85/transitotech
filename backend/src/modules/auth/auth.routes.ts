import { Router, Request, Response, NextFunction } from 'express';
import { AuthService } from './auth.service.js';

const router = Router();
const authService = new AuthService();

router.post('/register', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const user = await authService.register(req.body);
    return res.status(201).json({
      success: true,
      data: user,
    });
  } catch (error) {
    next(error);
  }
});

router.post('/login', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { email, password } = req.body;
    const result = await authService.login(email, password);
    return res.status(200).json({
      success: true,
      data: result,
    });
  } catch (error) {
    next(error);
  }
});

export const authRouter = router;