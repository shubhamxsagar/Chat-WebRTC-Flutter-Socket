const meetingServices = require('../services/meetingService');

exports.startMeeting = (req, res, next) => {
	const { hostId, hostName } = req.body;
	var model = {
		hostId: hostId,
		hostName: hostName,
		startTime: Date.now(),
	};

	meetingServices.startMeeting(model, (error, result) => {
		if (error) {
			return next(error);
		}
		return res.status(200).send({
			message: 'Meeting started successfully',
			data: result.id,
		});
	});
};

exports.checkMeetingExists = (req, res, next) => {
    const { meetingId } = req.query;
    meetingServices.checkMeetingExists(meetingId, (error, results)=>{
        if(error){
            return next(error);
        }
        return res.status(200).send({
            message: "Succes",
            data: results
        })
    })
}

exports.getAllMeetingUsers = (res, req, next) => {
    const { meetingId } = req.query;
    meetingServices.getAllMeetingUsers(meetingId,(error, results)=>{
        if(error){
            return next(error);
        }
        return res.status(200).send({
            message: "Succes",
            data: results
        })
    })
}
