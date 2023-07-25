require('dotenv').config({
    path: '.env',
});

const express = require('express');
const cors = require('cors');
const { expressjwt: jwt } = require('express-jwt');
const jsonwebtoken = require('jsonwebtoken');

const app = express();

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

const unauthorizedPaths = [
    '/auth/login', 
    '/auth/register', 
    '/location/countries'
];

// token middleware
app.use(jwt({
    secret: process.env.JWT_SECRET,
    algorithms: ['HS256'],
    getToken: (req) => {
        if (req.headers.authorization && req.headers.authorization.split(' ')[0] === 'Bearer') {
            return req.headers.authorization.split(' ')[1];
        }

        return null;
    }
}).unless({ 
    path: unauthorizedPaths
}));

// set decode user to req.user except login and register
app.use((req, res, next) => {
    if (unauthorizedPaths.includes(req.path)) {
        return next();
    }

    const token = req.headers.authorization.split(' ')[1];
    const decoded = jsonwebtoken.decode(token);

    if (!decoded) {
        return res.status(401).json({
            message: 'Invalid token',
        });
    }

    const user = decoded.data;

    if (!user) {
        return res.status(401).json({
            message: 'User not found',
        });
    }

    req.user = user;
    next();
});

app.use('/auth', require('./routes/auth.route'));
app.use('/user', require('./routes/user.route'));
app.use('/location', require('./routes/location.route'));

app.listen(3000, () => {
    console.log('Server running on port 3000');
});