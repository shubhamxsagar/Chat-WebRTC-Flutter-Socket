const bodyParser = require('body-parser');
const express = require('express');
const dbConnect = require('./config/dbConnect');
const app = express();
const dotenv = require('dotenv').config();
const PORT = process.env.PORT || 4000;
const authRoute = require('./routes/authRoutes');
const cors = require('cors');
// const chatRoute = require('./routes/chatRoutes');
const messageRoute = require('./routes/messageRoutes');
// const meetingRoute = require('./routes/meetingRoutes');
const { listenMessage } = require('./services/meeting-server');
// const { notFound, errorHandler } = require("./middlewares/errorHandler")
const cookieParser = require('cookie-parser');
const morgan = require('morgan');
dbConnect();

app.use(cors());
app.use(morgan('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.json());

const userSocketMap = {};
const clients = {};

app.use('/user', authRoute);
// app.use('/chats', chatRoute);
app.use('/messages', messageRoute);
// app.use('/meeting', meetingRoute);

const server = app.listen(PORT, () => {
	console.log(`Server is running at PORT ${PORT}`);
});
const io = require('socket.io')(server, {
	cors: {
		origin: 'http://192.168.29.53:5000',
	},
});

// initMeetingServer(server);

// module.exports.getRecieverSocketId = (recieverId)=>{
// 	return userSocketMap[recieverId];
// }

// var userSocketMap = {};

// io.use((socket, next) => {

// 	if (socket.handshake.query) {
// 		let callerId = socket.handshake.query.callerId;
// 		socket.user = callerId;
// 		next();
// 	}
// });

io.on('connection', (socket) => {
	// console.log('connected to socket.io', socket.id);

	// const meetingId = socket.handshake.query.id;
	// listenMessage(meetingId, socket, io);

	// console.log(socket.user, 'Connected');
	// socket.join(socket.user);

	const userId = socket.handshake.query.users;
	
	// socket.join(userId);
	if (userId != 'undefined') userSocketMap[userId] = socket.id;
	console.log('userId', userSocketMap);
	io.emit('getOnlineUsers', Object.keys(userSocketMap));

	// console.log(socket.user, 'Connected');

	socket.on('joinRoom', (roomId) => {
		socket.join([roomId, userId]);
		console.log(`User joined room ${roomId}`);
	});

	socket.on('sendMessage', (data) => {
		console.log('send message data', data);
		io.to(data.roomId).emit('receiveMessage', data.message);
	});

	socket.on('startTyping', (data) => {
		console.log('start typing', data);
		io.to(data.roomId).emit('startTyping', data);
	});

	socket.on('stopTyping', (data) => {
		console.log('stop typing', data);
		io.to(data.roomId).emit('stopTyping', data);
	});


	socket.on('makeCall', (data) => {
		console.log('makeCall', data);
		let calleeId = data.calleeId;
		let sdpOffer = data.sdpOffer;
		socket.to(calleeId).emit('newCall', {
			callerId: userId,
			sdpOffer: sdpOffer,
		});
	});

	socket.on('answerCall', (data) => {
		console.log('answerCall', data);
		let callerId = data.callerId;
		let sdpAnswer = data.sdpAnswer;

		socket.to(callerId).emit('callAnswered', {
			calleeId: userId,
			sdpAnswer: sdpAnswer,
		});
	});

	socket.on('IceCandidate', (data) => {
		console.log('IceCandidate', data);
		let calleeId = data.calleeId;
		let iceCandidate = data.iceCandidate;

		socket.to(calleeId).emit('IceCandidate', {
			sender: userId,
			iceCandidate: iceCandidate,
		});
	});


	// socket.on('setup', (room)=>{
	// 	socket.join(room);
	// 	console.log('setup', room);
	// 	socket.to(room).emit('online-users', room);
	// })
	// socket.on('disconnect', () => {
		// console.log('disconnected', socket.id);
		// io.emit('d', Object.keys(userSocketMap));
	// });

	// socket.on('setup', (userId) => {
	// 	socket.join(userId);
	// 	socket.to(userId).emit('online-users', userId);
	// 	console.log('userId: ', userId);
	// 	clients[userId] = socket;
	// 	console.log(clients);
	// });
	// socket.on('typing', (room) => {
	// 	console.log('typing');
	// 	console.log(room);
	// 	socket.to(room).emit('changes', room);
	// });
	// socket.on('stop typing', (room) => {
	// 	console.log('stop typing');
	// 	console.log(room);
	// 	socket.to(room).emit('stop typing', room);
	// });
	// socket.on('join chat', (room) => {
	// 	socket.join(room);
	// 	console.log('User Joined:' + room);
	// });
	// socket.on('new message', (newMessageRecieved) => {
	// 	const room = newMessageRecieved.receiverId;
	// 	console.log('receiverId',room);
	// 	console.log(room);
	// 	socket.to('65b22ac8f0eb735afa9876e2').emit('hello', 'Hello');
	// 	socket.to(room).emit('message recieved', newMessageRecieved);
	// 	console.log('new message', newMessageRecieved);
	// 	socket.to(room).emit('message sent', 'New Message');
	// });
	// socket.off('setup', () => {
	// 	console.log('user offline');
	// 	socket.leave(userId);
	// });

	/////////////////////////////////////////////////////////////////////////////////////////////

	// socket.on('sendMsg', (msg) => {
	// 	socket.join(msg.ReceiverId);
	// 	console.log('msg', msg,{ ...msg, ReceiverId: msg.ReceiverId});
	// 	socket.emit("sendMsgServer", { ...msg });

	// });

	// socket.on('message', (data) => {
	// 	console.log(data);
	// 	let senderId = data.senderId;
	// 	if (clients[senderId]) {
	// 		clients[senderId].emit('message', data);
	// 	}
	// 	io.to(data.receiverId).emit('new-message', data);
	// });
});
