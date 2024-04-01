const express = require('express');
const authMiddleware = require('../middlewares/authMiddleware');
const { sendMessage, getAllMessages, getAllConversations } = require('../controller/messageCtrl');

const router = express.Router();
router.post('/send', authMiddleware, sendMessage);
router.get('/:id', authMiddleware, getAllMessages);
router.get('/chatBox/:id', authMiddleware, getAllConversations);
module.exports = router
