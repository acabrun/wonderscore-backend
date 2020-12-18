const express = require('express');
const router = express.Router();

// Controllers
const mainController = require('../controllers/mainController');

// Routes
router.use('/', (req, res) => {
    res.send('everything is good !')
});


// 404
router.use(mainController.notFound);

module.exports = router;