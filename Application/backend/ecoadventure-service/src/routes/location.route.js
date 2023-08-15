const express = require('express');
const router = express.Router();
const controller = require('../controllers/location.controller');

router.get('/cities', controller.getCities);

module.exports = router;