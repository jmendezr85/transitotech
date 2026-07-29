import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import { AuthRepository, CreateUserData } from './auth.repository.js';

export class AuthService {
  private authRepository: AuthRepository;

  constructor() {
    this.authRepository = new AuthRepository();
  }

  async register(data: CreateUserData) {
    const existingUser = await this.authRepository.findByEmail(data.email);
    if (existingUser) {
      throw { statusCode: 400, message: 'El correo electrónico ya está registrado.' };
    }

    const saltRounds = 10;
    const password_hash = await bcrypt.hash(data.password, saltRounds);

    const user = await this.authRepository.createUser({
      full_name: data.full_name,
      email: data.email,
      password: password_hash,
      role: data.role || 'passenger',
    });

    const { password_hash: _, ...userWithoutPassword } = user;
    return userWithoutPassword;
  }

  async login(email: string, password: string) {
    const user = await this.authRepository.findByEmail(email);
    if (!user) {
      throw { statusCode: 401, message: 'Credenciales inválidas.' };
    }

    if (!user.password_hash) {
      throw { statusCode: 500, message: 'El usuario no posee hash de contraseña configurado.' };
    }

    // Comparación directa contra el hash de la BD
    const isPasswordValid = await bcrypt.compare(password, user.password_hash);
    if (!isPasswordValid) {
      throw { statusCode: 401, message: 'Credenciales inválidas.' };
    }

    const secret = process.env.JWT_SECRET || 'transitotech_jwt_secret_key_2026_local';
    
    const token = jwt.sign(
      { id: user.id, email: user.email, role: user.role },
      secret,
      { expiresIn: '24h' }
    );

    const { password_hash: _, ...userWithoutPassword } = user;
    return {
      token,
      user: userWithoutPassword,
    };
  }
}