import User from '../models/User.js';
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import sendEmail from '../utils/sendEmail.js'; // Assumindo que usas ESModules (import/export)

const SECRET_KEY = process.env.SECRET_KEY || 'segredo_super_secreto';

// REGISTO DE UTILIZADOR
export const register = async (req, res) => {
  try {
    const { username, firstname, lastname, email, password } = req.body;

    // Verificar se já existe utilizador
    const existingUser = await User.findOne({ where: { username } });
    if (existingUser) return res.status(400).json({ message: 'Username já existe.' });

    // Encriptar palavra-passe
    const hashedPassword = await bcrypt.hash(password, 10);

    // Criar utilizador (ainda sem token)
    const newUser = await User.create({
      username,
      firstname,
      lastname,
      email,
      password: hashedPassword,
      is_admin: false,
      active: false
    });

    // Gerar token
    const token = jwt.sign({ id: newUser.id }, SECRET_KEY, { expiresIn: '1d' });

    // Atualizar utilizador com token
    newUser.token = token;
    await newUser.save();

    // Link e conteúdo do email
    const activationLink = `http://localhost:3000/activate?token=${token}`;
    const emailContent = `
      <h3>Bem-vindo(a), ${firstname}!</h3>
      <p>Por favor, ativa a tua conta clicando no link abaixo:</p>
      <a href="${activationLink}">Ativar Conta</a>
    `;

    // Enviar email
    await sendEmail(newUser.email, 'Confirmação de Conta', emailContent);

    res.status(201).json({ message: 'Conta criada. Verifica o teu email para ativação.' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: error.message });
  }
};

// LOGIN
export const login = async (req, res) => {
  try {
    const { username, password } = req.body;

    const user = await User.findOne({ where: { username } });
    if (!user) return res.status(404).json({ message: 'Utilizador não encontrado.' });

    if (!user.active)
      return res.status(403).json({ message: 'Conta ainda não foi ativada.' });

    const match = await bcrypt.compare(password, user.password);
    if (!match) return res.status(401).json({ message: 'Palavra-passe incorreta.' });

    const token = jwt.sign(
      { id: user.id, username: user.username, is_admin: user.is_admin },
      SECRET_KEY,
      { expiresIn: '1h' }
    );

    res.json({ token });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// ATIVAÇÃO DE CONTA
export const activateAccount = async (req, res) => {
  const { token } = req.query;
  try {
    const decoded = jwt.verify(token, SECRET_KEY);
    const user = await User.findByPk(decoded.id);

    if (!user) return res.status(404).json({ message: 'Utilizador não encontrado.' });
    
    if (user.active) return res.status(400).json({ message: 'Conta já está ativada.' });

    user.active = true;
    user.token = null;
    await user.save();

    res.status(200).json({ message: 'Conta ativada com sucesso!' });
  } catch (error) {
    console.error(error);
    res.status(400).json({ message: 'Token inválido ou expirado.' });
  }
};
