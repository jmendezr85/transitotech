import { pool } from '../../config/database.js';

export interface CreateUserData {
  full_name: string;
  email: string;
  password: string;
  role?: string;
}

export class AuthRepository {
  async createUser(data: CreateUserData) {
    const query = `
      INSERT INTO users (full_name, email, password_hash, role)
      VALUES ($1, $2, $3, $4)
      RETURNING id, full_name, email, role, created_at;
    `;
    const values = [data.full_name, data.email, data.password, data.role || 'passenger'];
    const result = await pool.query(query, values);
    return result.rows[0];
  }

  async findByEmail(email: string) {
    const query = 'SELECT * FROM users WHERE email = $1;';
    const result = await pool.query(query, [email]);
    return result.rows[0];
  }
}