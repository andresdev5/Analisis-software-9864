require('dotenv').config({
    path: '.env',
});

const express = require('express');
const cors = require('cors');
const { expressjwt: jwt } = require('express-jwt');

const app = express();

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use('/auth', require('./routes/auth.route'));

app.listen(3000, () => {
    console.log('Server running on port 3000');
});