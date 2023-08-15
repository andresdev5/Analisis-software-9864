const express = require('express');
const router = express.Router();
const controller = require('../controllers/destination.controller');

router.get('/all', controller.getDestinations);
router.get('/search', controller.searchDestination);
router.get('/popular', controller.getPopularDestinations);
router.get('/reviews', controller.getReviews);
router.get('/:id', controller.getDestination);
router.get('/:id/reviews', controller.getDestinationReviews);

module.exports = router;