import express from 'express';
const router = express.Router();
import authMiddleware from '../middleware/middleware.js'; // adiciona .js se usas ESModules
import pool from '../config/database.js'; // adiciona .js

// Rota protegida para listar utilizadores
router.get('/', authMiddleware, async (req, res) => {
  try {
    const [users] = await pool.query('SELECT id, username, firstname, lastname FROM user');
    res.json(users);
  } catch (error) {
    console.error('Erro ao localizar utilizadores:', error); // ajuda para debugging
    res.status(500).json({ message: 'Erro ao localizar utilizadores' });
  }
});

export default router;
