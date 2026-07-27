import { pool } from '../../config/database.js';

export interface User {
  id: string;
  email: string;
  password_hash: string;
  full_name: string;
  role: 'admin' | 'driver' | 'passenger';
  created_at?: Date;
}

export class AuthRepository {
  async findByEmail(email: string): Promise<User | null> {
    const query = 'SELECT * FROM users WHERE email = $1 LIMIT 1;';
    const result = await pool.query(query, [email]);
    return result.rows[0] || null;
  }

  async createUser(user: { email: string; password_hash: string; full_name: string; role: string }): Promise<User> {
    const query = `
      INSERT INTO users (email, password_hash, full_name, role)
      VALUES ($1, $2, $3, $4)
      RETURNING id, email, full_name, role, created_at;
    `;
    const values = [user.email, user.password_hash, user.full_name, user.role];
    const result = await pool.query(query, values);
    return result.rows[0];
  }
}