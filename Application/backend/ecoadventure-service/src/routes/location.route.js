const express = require('express');
const router = express.Router();
const controller = require('../controllers/location.controller');

router.get('/countries', controller.getCountries);

module.exports = router;