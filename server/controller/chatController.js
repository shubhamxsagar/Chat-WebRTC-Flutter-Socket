const Chat = require('../models/ChatModel');
const User = require('../models/userModel');
const AppErr = require('../Global/AppErr');
const asyncHandler = require('express-async-handler');

// const CreateChat = async (req, res, next) => {
// 	try {
// 		let { message, ReceiverId } = req.body;

// 		let receiverUser = await User.findById(ReceiverId);
// 		if (!receiverUser) {
// 			return next(new AppErr('Recevier not found'), 404);
// 		}

// 		req.body.message = message;
// 		req.body.ReceiverId = receiverUser._id;
// 		req.body.SenderId = req.user;

// 		let chat = await Chat.create(req.body);

// 		res.status(200).json({
// 			message: 'success',
// 			data: chat,
// 		});
// 	} catch (error) {
// 		return next(new AppErr(error.message, 500));
// 	}
// };

// const getChat = async (req, res, next) => {
// 	try {
// 		let messages = await Chat.find({
// 			// SenderId: req.user,
// 			// ReceiverId: req.params.id
// 			$or: [
//                 { SenderId: req.user, ReceiverId: req.params.id },
//                 { SenderId: req.params.id, ReceiverId: req.user }
//             ],
// 		})
// 		.sort({ createdAt: -1 })
// 		.populate({
// 			path: 'SenderId ReceiverId',
// 			select: 'name profilePic',
// 			model: 'User'
// 		});
// 		if (!messages || messages.length === 0) {
// 			return next(new AppErr('No chat found', 404));
// 		}

// 		res.status(200).json(messages);
// 	} catch (error) {
// 		return next(new AppErr(error.message, 500));
// 	}
// };

// // const getChat = async (req, res, next) => {
// // 	try {
// // 		let message = await Chat.find({
// // 			SenderId: req.user,
// // 			ReceiverId: req.params.id,
// // 		});
// // 		if (!message) {
// // 			return next(new AppErr('Not chat Found', 404));
// // 		}

// // 		res.status(200).json({
// // 			message: 'success',
// // 			data: message,
// // 		});
// // 	} catch (error) {
// // 		return next(new AppErr(error.message, 500));
// // 	}
// // };

// const getChatsBySenderId = async (request, response, next) => {
// 	try {
// 	  const senderId = request.params.senderId;
	  
// 	  // Find all chat messages sent by the sender
// 	  const messages = await Chat.find({ SenderId: senderId }).sort({ createdAt: -1 }).populate({
// 		path: 'ReceiverId',
// 		select: 'name email profilePic',
// 		model: User,
	  
// 	  });
  
// 	  // Initialize an object to store the latest message for each receiver
// 	  const latestMessagesByReceiver = {};
  
// 	  // Iterate through the messages to find the latest message for each receiver
// 	  messages.forEach((message) => {
// 		const receiverId = message.ReceiverId;
// 		if (!latestMessagesByReceiver[receiverId]) {
// 		  // If the receiver ID is not yet in the object, add the message
// 		  latestMessagesByReceiver[receiverId] = message;
// 		}
// 	  });
  
// 	  // Extract the receiver IDs from the latest messages
// 	  const uniqueReceiverIds = Object.keys(latestMessagesByReceiver);
  
// 	  // Extract the latest messages for the unique receiver IDs
// 	  const uniqueLatestMessages = uniqueReceiverIds.map((receiverId) => latestMessagesByReceiver[receiverId]);
  
// 	  response.status(200).json(uniqueLatestMessages);
// 	} catch (error) {
// 	  response.status(500).json(error);
// 	}
//   };
  
// module.exports = { CreateChat, getChat, getChatsBySenderId };
