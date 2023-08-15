const express = require('express');
const router = express.Router();
const controller = require('../controllers/travel.controller');

router.get('/', controller.getTravels);
router.get('/my-travels', controller.getUserTravels);
router.get('/t/:id', controller.getTravel);
router.get('/completed', controller.getCompletedTravels);
router.post('/', controller.createTravel);
router.post('/complete/:id', controller.completeTravel);
router.get('/active/:id', controller.getActiveUserTravel);
router.get('/user-is-travelling', controller.userIsTravelling);
router.post('/review/:id', controller.createReview);

module.exports = router;