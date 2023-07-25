const express = require('express');
const router = express.Router();
const userController = require('../controllers/user.controller');

router.get('/', userController.getUser);
router.get('/profile', userController.getProfile);
router.put('/profile/:id', userController.updateProfile);

module.exports = router;