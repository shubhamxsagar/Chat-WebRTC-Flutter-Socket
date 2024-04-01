const meetingHelper = require('../utils/meeting-helper');
const { MeetingPayloadEnum } = require('../utils/meetingPayloadEnum');

function parseMessage(message) {
	try {
		const payload = JSON.parser(message);
		return payload;
	} catch (error) {
		return { type: MeetingPayloadEnum.UNKNOWN };
	}
}

function listenMessage(meetingId, socket, meetingServer) {
	socket.on('message', (message) =>
		handelMessage(meetingId, socket, message, meetingServer)
	);
}

function handelMessage(meetingId, socket, message, meetingServer) {
	var payload = '';
	if (typeof message === 'string') {
		payload = parseMessage(message);
	} else {
		payload = message;
	}

	switch (payload.type) {
		case MeetingPayloadEnum.JOIN_MEETING:
			meetingHelper.joinMeeting(meetingId, socket, payload, meetingServer);
			break;
		case MeetingPayloadEnum.CONNECTION_REQUEST:
			meetingHelper.forwardConnectionRequest(
				meetingId,
				socket,
				meetingServer,
				payload
			);
			break;
		case MeetingPayloadEnum.OFFER_SDP:
			meetingHelper.forwardOfferSDP(meetingId, socket, meetingServer, payload);
			break;
		case MeetingPayloadEnum.ICECANDIDATE:
			meetingHelper.forwardIceCandidate(meetingId, socket, meetingServer, payload);
			break;
		case MeetingPayloadEnum.ANSWER_SDP:
			meetingHelper.forwardAnswerSDP(meetingId, socket, meetingServer, payload);
			break;
		case MeetingPayloadEnum.LEAVE_MEETING:
			meetingHelper.userLeft(meetingId, socket, meetingServer, payload);
			break;
		case MeetingPayloadEnum.END_MEETING:
			meetingHelper.endMeeting(meetingId, socket, meetingServer, payload);
			break;
		case MeetingPayloadEnum.VIDEO_TOGGLE:
		case MeetingPayloadEnum.VIDEO_TOGGLE:
			meetingHelper.forwardEvent(meetingId, socket, meetingServer, payload);
			break;
		case MeetingPayloadEnum.UNKNOWN:
			break;
		default:
			break;
	}
}

// function initMeetingServer(server) {
// 	// const meetingServer = require("socket.io")(server);
// 	io.on('connection', (socket) => {
// 		const meetingId = socket.handshake.query.id;
// 		listenMessage(meetingId, socket, meetingServer);
// 	});
// }

module.exports = {
	listenMessage,
};
