const mongoose = require('mongoose');

const meeting = new mongoose.Schema(
	{
		hostId: {
			type: String,
			required: true,
		},
		hostName: {
			type: String,
			required: false,
		},
		startTime: {
			type: Date,
			required: true,
		},
		meetingUsers: [
			{
				type: mongoose.Schema.Types.ObjectId,
				ref: 'MeetingUser',
			},
		],
	},
	{
		toJSON: {
			transform: function (doc, ret) {
				ret.id = ret._id.toString();
				delete ret._id;
				delete ret.__v;
			},
		},
		timestamps: true,
	}
);

module.exports = mongoose.model('Meeting', meeting);

// const mongoose = require('mongoose');
// const { Schema } = mongoose;

// const meeting = mongoose.Schema(
// 	'Meeting',
// 	mongoose.Schema(
// 		{
// 			hostId: {
// 				type: Schema.Types.ObjectId,
// 				ref: 'User',
// 				required: true,
// 			},
// 			hostName: {
// 				type: String,
// 				required: true,
// 			},
// 			startTime: {
// 				type: Date,
// 				required: true,
// 			},
// 			meetingUsers: [
// 				{
// 					type: Schema.Types.ObjectId,
// 					ref: 'MeetingUser',
// 				},
// 			],
// 		},
// 		{
// 			toJSON: {
// 				transform: function (doc, ret) {
// 					(ret.id = ret._id.toString()), delete ret._id;
// 					delete ret.__v;
// 				},
// 			},
// 		},
// 		{
// 			timestamps: true,
// 		}
// 	)
// );

// module.exports = { meeting };
