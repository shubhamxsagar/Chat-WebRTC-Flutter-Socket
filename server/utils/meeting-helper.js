const meetingServices = require('../services/meetingService');
const { MeetingPayLoadEnum } = require('../utils/meeting-helper');

async function joinMeeting(meetingId, socket, meetingServer, payload) {
	const { userId, name } = payload.data;
	meetingServices.isMeetingPresent(meetingId, async (error, results) => {
		if (error && !results) {
			sendMessage(socket, {
				type: MeetingPayLoadEnum.NOT_FOUND,
			});
		}
		if (results) {
			addUser(socket, { meetingId, userId, name }).then(
				(result) => {
					if (result) {
						SendMessage(socket, {
							type: MeetingPayLoadEnum.JOINER_MEETING,
							data: { userId },
						});

						broadcastUsers(meetingId, socket, meetingServer, {
							type: MeetingPayLoadEnum.USER_JOINED,
							data: {
								userId,
								name,
								...payload.data,
							},
						});
					}
				},
				(error) => {
					console.log(error);
				}
			);
		}
	});
}

function forwardConnectionRequest(meetingId, socket, meetingServer, payload) {
	const { userId, otherUserId, name } = payload.data;

	var model = {
		meetingId: meetingId,
		userId: otherUserId,
	};

	meetingServices.getMeetingUser(model, (error, results) => {
		if (results) {
			var sendPayload = JSON.stringify({
				type: MeetingPayLoadEnum.CONNECTION_REQUEST,
				data: {
					userId,
					name,
					...payload.data,
				},
			});
			meetingServer.to(results.socketId).emit('message', sendPayload);
		}
	});
}

function forwardIceCandidate(meetingId, socket, meetingServer, payload) {
	const { userId, otherUserId, candidate } = payload.data;

	var model = {
		meetingId: meetingId,
		userId: otherUserId,
	};

	meetingServices.getMeetingUser(model, (error, results) => {
		if (results) {
			var sendPayload = JSON.stringify({
				type: MeetingPayLoadEnum.ICECANDIDATE,
				data: {
					userId,
					candidate,
				},
			});
			meetingServer.to(results.socketId).emit('message', sendPayload);
		}
	});
}

function forwardOfferSDP(meetingId, socket, meetingServer, payload) {
	const { userId, otherUserId, sdp } = payload.data;

	var model = {
		meetingId: meetingId,
		userId: otherUserId,
	};

	meetingServices.getMeetingUser(model, (error, results) => {
		if (results) {
			var sendPayload = JSON.stringify({
				type: MeetingPayLoadEnum.ICECANDIDATE,
				data: {
					userId,
					sdp,
				},
			});
			meetingServer.to(results.socketId).emit('message', sendPayload);
		}
	});
}

function forwardAnswerSDP(meetingId, socket, meetingServer, payload) {
	const { userId, otherUserId, sdp } = payload.data;

	var model = {
		meetingId: meetingId,
		userId: otherUserId,
	};

	meetingServices.getMeetingUser(model, (error, results) => {
		if (results) {
			var sendPayload = JSON.stringify({
				type: MeetingPayLoadEnum.ANSWER_SDP,
				data: {
					userId,
					sdp,
				},
			});
			meetingServer.to(results.socketId).emit('message', sendPayload);
		}
	});
}

function userLeft(meetingId, socket, meetingServer, payload) {
	const { userId } = payload.data;

	broadcastUsers(meetingId, socket, meetingServer, {
		type: MeetingPayLoadEnum.USER_LEFT,
		data: {
			userId: userId,
		},
	});
}

function endMeeting(meetingId, socket, meetingServer, payload) {
	const { userId } = payload.data;

	broadcastUsers(meetingId, socket, meetingServer, {
		type: MeetingPayLoadEnum.MEETING_ENDED,
		data: {
			userId: userId,
		},
	});
	meetingServices.getAllNeetingUsers(meetingId, (error, results) => {
		for (let i = 0; i < results.length; i++) {
			const meetingUser = results[i];
			meetingServer.sockets.connected[meetingUser.socketId].disconnect();
		}
	});
}

function forwardEvent(meetingId, socket, meetingServer, payload) {
	const { userId } = payload.data;

	broadcastUsers(meetingId, socket, meetingServer, {
		type: payload.type,
		data: {
			userId: userId,
			...payload.data,
		},
	});
	meetingServices.getAllNeetingUsers(meetingId, (error, results) => {
		for (let i = 0; i < results.length; i++) {
			const meetingUser = results[i];
			meetingServer.sockets.connected[meetingUser.socketId].disconnect();
		}
	});
}

function addUser(socket, { meetingId, userId, name }) {
	let promise = new Promise(function (resolve, reject) {
		meetingServices.getMeetingUser({ meetingId, userId }, (error, results) => {
			if (!results) {
				var model = {
					socketId: socket.id,
					meetingId: meetingId,
					userId: userId,
					joined: true,
					name: name,
					isAlive: true,
				};
				meetingServices.joinMeeting(model, (error, results) => {
					if (results) {
						resolve(results);
					}
					if (error) {
						reject(error);
					}
				});
			} else {
				meetingServices.updateMeetingUser(
					{
						userId: userId,
						socketId: socket.id,
					},
					(error, results) => {
						if (results) {
							resolve(true);
						}
						if (error) {
							reject(error);
						}
					}
				);
			}
		});
	});
	return promise;
}

function broadcastUsers(meetingId, socket, meetingServer, payload) {
	socket.broadcast.emit('message', JSON.stringify(payload));
}

module.exports = {
    joinMeeting,
    forwardConnectionRequest,
    forwardIceCandidate,
    forwardOfferSDP,
    forwardAnswerSDP,
    userLeft,
    endMeeting,
    forwardEvent,
};