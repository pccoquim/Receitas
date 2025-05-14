import User from '../models/User';

exports.getAllUsers = async (req, res) => {
    try {
    const users = await User.findAll();
    res.json(users);
    } catch (err) {
    res.status(500).json({ error: err.message });
    }
};