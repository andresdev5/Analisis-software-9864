const { Database } = require('../core/database.js');
const jsonwebtoken = require('jsonwebtoken');
const bcrypt = require('bcrypt');

async function login(req, res) {
    const { username, password } = req.body;

    if (!username || !password) {
        return res.status(400).json({
            message: 'Username and password are required',
        });
    }

    const hashedPassword = bcrypt.hashSync(password, bcrypt.genSaltSync(10));
    const data = await Database.instance.connection.any(
        'SELECT id, username, email, role_id, password FROM public.user WHERE username = $1', 
        [username, hashedPassword]
    );

    if (data.length === 0) {
        return res.status(400).json({
            message: 'Username not found',
        });
    }

    const user = data[0];

    if (!bcrypt.compareSync(password, user.password)) {
        return res.status(400).json({
            message: 'Password is incorrect',
        });
    }

    const token = jsonwebtoken.sign({
        data: user,
        hash: bcrypt.hashSync(password, bcrypt.genSaltSync(10)),
    }, process.env.JWT_SECRET, { expiresIn: '31d' });

    return res.status(200).json({
        message: 'Login successful',
        token: token
    });
}

async function register(req, res) {
    const { username, email, password } = req.body;

    if (!username || !email || !password) {
        return res.status(400).json({
            message: 'Username, email and password are required',
        });
    }

    const hashedPassword = bcrypt.hashSync(password, bcrypt.genSaltSync(10));

    const data = await Database.instance.connection.one(
        'SELECT MAX(id) as id FROM public.user'
    );

    const id = data.id + 1;

    Database.instance.connection.none(
        'INSERT INTO public.user(id, username, email, password, role_id) VALUES($1, $2, $3, $4, 2)',
        [id, username, email, hashedPassword]
    );

    return res.status(200).json({
        message: 'Register successful',
    });
}

module.exports = {
    login,
    register
};