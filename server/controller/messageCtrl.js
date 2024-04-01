const jwt = require('jsonwebtoken');
const asyncHandler = require('express-async-handler');
const User = require('../models/userModel');
const Chat = require('../models/ChatModel');
const Message = require('../models/messageModel');
const ConversationModel = require('../models/conversatonModel');
const { getRecieverSocketId } = require('..');

const sendMessage = asyncHandler(async (req, res) => {
	try {
		const { message, senderId, recieverId } = req.body;
		// const { id: recieverId } = req.params;
		// const senderId = req.user._id;
		console.log(message, recieverId, senderId);
		let conversation = await ConversationModel.findOne({
			participants: { $all: [senderId, recieverId] },
		});

		if (!conversation) {
			conversation = await ConversationModel.create({
				participants: [senderId, recieverId],
			});
		}

		const newMessage = new Message({
			senderId,
			recieverId,
			message,
		});
		if (newMessage) {
			conversation.messages.push(newMessage._id);
		}

		// await conversation.save();
		// await newMessage.save();

		await Promise.all([conversation.save(), newMessage.save()]);

		// const recieverSocketId = getRecieverSocketId(recieverId);
		// if(recieverSocketId) {
		// 	io.to(recieverSocketId).emit()
		// }

		res.status(200).json(newMessage);
	} catch (error) {
		console.log(error);
		res.status(500).json(error);
	}
});

const getAllMessages = asyncHandler(async (req, res) => {
	try {
		const { id: userToChatId } = req.params;
		const senderId = req.user;

		console.log('user user', req.user, senderId);

		const conversation = await ConversationModel.findOne({
			participants: { $all: [senderId, userToChatId] },
		}).populate('messages');

		if(!conversation) return res.status(200).json([]);
		const messages = conversation.messages.reverse();

		res.status(200).json(messages);

	} catch (error) {
		console.log(error);
	}
});


const getAllConversations = asyncHandler(async (req, res) => {
    try {
        const { id: senderId } = req.params;

        const conversations = await ConversationModel.find({
            participants: senderId
        }).populate({
            path: 'participants',
            select: 'profilePic name'
        }).populate({
            path: 'messages',
            options: { sort: { createdAt: -1 }, limit: 1 } // Sort by createdAt in descending order to get the latest message, and limit to 1 message
        }).sort({ updatedAt: -1 }); 

        const filteredConversations = conversations.map(conversation => {
            const participants = conversation.participants.filter(participant => participant._id.toString() !== senderId);
            const latestMessage = conversation.messages.length > 0 ? conversation.messages[0].message : '';
            return {
                _id: conversation._id,
                participants: participants.length === 1 ? participants[0] : {}, // Return participant object if it exists, else return empty object
                latestMessage: latestMessage,
                createdAt: conversation.createdAt,
                updatedAt: conversation.updatedAt
            };
        });

        res.status(200).json(filteredConversations);
    } catch (error) {
        console.log(error);
        res.status(500).json(error);
    }
});





// const sendMessage = async (request, response) => {
// 	const newMessage = new Message(request.body);
// 	try {
// 		await newMessage.save();
// 		await Chat.findByIdAndUpdate(request.body.conversationId, {
// 			message: request.body.text,
// 		});
// 		console.log(request.body);
// 		response.status(200).json('Message has been sent successfully');
// 	} catch (error) {
// 		response.status(500).json(error);
// 	}
// };

// const getAllMessages = async (request, response) => {
// 	try {
// 		const messages = await Message.find({ conversationId: request.params.id })
// 			.populate({
// 				path: 'senderId',
// 				select: 'username',
// 			})
// 			.populate({
// 				path: 'receiverId',
// 				select: 'username',
// 			});
// 		const chat = await Chat.findOne({ _id: request.params.id });
// 		console.log(messages);

// 		const userId = request.params.id;
// 		if (chat.members.includes(userId)) {
// 			// sender = userId;
// 			console.log('alok', chat); /// yaha pe data nhi aa rha hai
// 		}
// 		console.log('sender', request.params.id);
// 		response.status(200).json({
// 			sender: userId,
// 			data: messages,
// 		});
// 	} catch (error) {
// 		response.status(500).json(error);
// 	}
// };

// const sendMessage = asyncHandler(async (req, res) => {
// 	const { content, chatId, receiver } = req.body;
// 	if (!content || !chatId) {
// 		console.log('Invalid data');
// 		return res.status(400);
// 	}
// 	var newMessage = {
// 		sender: req.user.id,
// 		content: content,
// 		receiver: receiver,
// 		chat: chatId,
// 	};

// 	try {
// 		var message = await Message.create(newMessage);
// 		message = await message.populate('sender', 'name email profilePic');
// 		message = await message.populate('chat');
// 		message = await User.populate(message, {
// 			path: 'chat.users',
// 			select: 'name email profilePic',
// 		});
// 		await Chat.findByIdAndUpdate(req.body.chatId, { latestMessage: message });
// 		res.status(200).json(message);
// 	} catch (e) {
// 		res.status(400).json({ error: e.message });
// 	}
// });

// const getAllMessages = asyncHandler(async (req, res) => {
// 	try {
// 		const pageSize = 12;
// 		const page = req.query.page || 1;
// 		const skipMessage = (page - 1) * pageSize;
// 		var message = await Message.find({ chat: req.params.id })
// 			.populate('sender', 'name email profilePic')
// 			.populate('chat')
// 			.sort({ createdAt: -1 })
// 			.skip(skipMessage)
// 			.limit(pageSize);

// 		message = await User.populate(message, {
// 			path: 'chat.users',
// 			select: 'name email profilePic',
// 		});

// 		res.status(200).json(message);
// 	} catch (e) {
// 		res.status(400).json({ error: e.message });
// 	}
// });

module.exports = { sendMessage, getAllMessages, getAllConversations };
