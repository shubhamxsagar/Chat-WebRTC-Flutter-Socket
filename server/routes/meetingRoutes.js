const meetingController = require('../controller/meetingController');
const express = require('express');
const router = express.Router();

router.post("/starts", meetingController.startMeeting);
router.get("/join", meetingController.checkMeetingExists);
router.get("/get", meetingController.getAllMeetingUsers);
module.exports = router;