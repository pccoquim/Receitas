import express from 'express';
import cors from 'cors';
const app = express();
import sequelize from './config/database.js';
import authRoutes from './routes/authRoutes.js';

// Middleware
app.use(cors());
app.use(express.json());

app.get('/', (req, res) => {
  res.send('API de Receitas no ar');
});

// Iniciar servidor
const PORT = 5000;
app.listen(PORT, async () => {
    try {
    await sequelize.authenticate();
    console.log('Conexão ao MySQL estabelecida com sucesso!');
    console.log(`Servidor iniciado na porta ${PORT}`);
    } catch (error) {
        console.error('Erro na conexão ao MySQL:', error);
    }
});

app.use('/api/auth', authRoutes);
