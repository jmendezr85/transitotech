import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import { AuthRepository } from './auth.repository.js';

export class AuthService {
  private authRepository: AuthRepository;

  constructor() {
    this.authRepository = new AuthRepository();
  }

  async register(data: { email: string; password: string; full_name: string }) {
    const existingUser = await this.authRepository.findByEmail(data.email);
    if (existingUser) {
      throw { statusCode: 400, message: 'El correo electrónico ya está registrado.' };
    }

    const salt = await bcrypt.genSalt(10);
    const password_hash = await bcrypt.hash(data.password, salt);

    const newUser = await this.authRepository.createUser({
      email: data.email,
      password_hash,
      full_name: data.full_name,
      role: 'passenger', // Rol por defecto
    });

    return newUser;
  }

  async login(data: { email: string; password: string }) {
    const user = await this.authRepository.findByEmail(data.email);
    if (!user) {
      throw { statusCode: 401, message: 'Credenciales inválidas.' };
    }

    const isMatch = await bcrypt.compare(data.password, user.password_hash);
    if (!isMatch) {
      throw { statusCode: 401, message: 'Credenciales inválidas.' };
    }

    const secret = process.env.JWT_SECRET || 'transitotech_secret_key_dev';
    const token = jwt.sign(
      { id: user.id, email: user.email, role: user.role },
      secret,
      { expiresIn: '24h' }
    );

    return {
      token,
      user: {
        id: user.id,
        email: user.email,
        full_name: user.full_name,
        role: user.role,
      },
    };
  }
}