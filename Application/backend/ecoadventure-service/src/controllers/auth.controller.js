const { Database } = require('../core/database.js');
const jsonwebtoken = require('jsonwebtoken');
const bcrypt = require('bcrypt');

async function login(req, res) {
    let { username, email, password } = req.body;

    if (!username && !email) {
        return res.status(400).json({
            message: 'Username or email are required',
        });
    }

    // lower case username or email
    if (username) {
        username = username.toLowerCase();
    }

    if (email) {
        email = email.toLowerCase();
    }

    if (!password) {
        return res.status(400).json({
            message: 'Password is required',
        });
    }

    const hashedPassword = bcrypt.hashSync(password, bcrypt.genSaltSync(10));
    const data = await Database.instance.connection.any(
        `SELECT u.id, u.username, u.email, u.role_id, u.password, r.name as role_name
         FROM public.user as u
         LEFT JOIN public.role r ON u.role_id = r.id
         WHERE LOWER(${username ? 'username' : 'email'}) = LOWER($1)`, 
        [username ? username : email, hashedPassword]
    );

    if (data.length === 0) {
        return res.status(400).json({
            message: 'User not found',
        });
    }

    const user = data[0];

    if (!bcrypt.compareSync(password, user.password)) {
        return res.status(400).json({
            message: 'Password is incorrect',
        });
    }

    const userData = {
        id: user.id,
        username: user.username,
        email: user.email,
        role: {
            id: user.role_id,
            name: user.role_name,
        }
    };

    const token = jsonwebtoken.sign({
        data: userData,
        hash: bcrypt.hashSync(password, bcrypt.genSaltSync(10)),
    }, process.env.JWT_SECRET, { expiresIn: '31d' });

    return res.status(200).json({
        message: 'Login successful',
        token: token,
        user: userData,
    });
}

async function register(req, res) {
    const { username, email, password } = req.body;

    if (!username || !email || !password) {
        return res.status(400).json({
            message: 'Username, email and password are required',
        });
    }

    // check if username or email already exists
    const exists = await Database.instance.connection.any(
        `SELECT * FROM public.user WHERE username = $1 OR email = $2`,
        [username, email]
    );

    if (exists.length > 0) {
        return res.status(400).json({
            message: 'Username or email already exists',
        });
    }

    const hashedPassword = bcrypt.hashSync(password, bcrypt.genSaltSync(10));

    const inserted = await Database.instance.connection.one(
        'INSERT INTO public.user(username, email, password, role_id) VALUES($1, $2, $3, 2) RETURNING id',
        [username, email, hashedPassword]
    );

    if (inserted) {
        await Database.instance.connection.none(
            'INSERT INTO public.user_profile(user_id) VALUES($1)',
            [inserted.id]
        );
    } else {
        return res.status(400).json({
            message: 'Error registering user',
        });
    }

    return res.status(200).json({
        message: 'Registered successfully',
    });
}

module.exports = {
    login,
    register
};