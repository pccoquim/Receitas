import express from 'express';
import { register, login, activateAccount } from '../controllers/authController.js';

const router = express.Router();

router.post('/register', register);
router.post('/login', login);
router.get('/activate', activateAccount); // Confirmação via token do email

export default router;
