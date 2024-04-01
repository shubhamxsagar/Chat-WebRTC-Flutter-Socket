const mongoose = require('mongoose');


const messageSchema = new mongoose.Schema({
	senderId:{
		type: mongoose.Schema.Types.ObjectId,
		ref: 'User',
		required: true,
	},
	recieverId:{
		type: mongoose.Schema.Types.ObjectId,
		ref: 'User',
		required: true,
	},
	message:{
		type: String,
		required: true,
	},
},{
	timestamps: true,
});



// // const messageSchema = new mongoose.Schema(
// 	// {
// 	// 	conversationId: {
// 	// 		type: String,
// 	// 	},
// 	// 	senderId: {
// 	// 		type: String,
// 	// 	},
// 	// 	receiverId: {
// 	// 		type: String,
// 	// 	},
// 	// 	text: {
// 	// 		type: String,
// 	// 	},
// 	// 	type: {
// 	// 		type: String,
// 	// 	},
// 	// },
// 	// {
// 	// 	timestamps: true,
// 	// }
// // );

// // const messageSchema = new mongoose.Schema(
// // 	{
// // 		sender: {
// //             type: mongoose.Schema.Types.ObjectId,
// // 			ref: 'User',
// // 		},
// // 		content: { type: String, required: true },
// // 		receiver: { type: String, required: true },
// // 		chat: {
// // 			type: mongoose.Schema.Types.ObjectId,
// // 			ref: 'Chat',
// // 			required: true,
// // 		},
// // 		readBy: [{ type: String }],
// // 	},
// // 	{ timestamps: true }
// // );

const MessageModel = mongoose.model('Message', messageSchema);

module.exports = MessageModel;
