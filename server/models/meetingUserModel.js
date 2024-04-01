const mongoose = require('mongoose');

const meetingUser = new mongoose.Schema({
    socketId: {
        type: String,
    },
    meetingId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Meeting', // Assuming Meeting is the name of another schema
    },
    userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'MeetingUser',
    },
    joined: {
        type: Boolean,
        default: true,
    },
    name: {
        type: String,
        required: true,
    },
    isAlive: {
        type: Boolean,
        required: true,
    },
}, {
    timestamps: true,
});

module.exports = mongoose.model('MeetingUser', meetingUser);



// const mongoose = require('mongoose');
// const { Schema } = mongoose;

// const meetingUser = mongoose.Schema(
// 	'MeetingUser',
// 	mongoose.Schema(
// 		{
// 			socketId: {
// 				type: String,
// 			},
// 			meetingId: {
// 				type: mongoose.Schema.Types.ObjectId,
// 				required: 'Meeting',
// 			},
// 			UserId: {
// 				type: mongoose.Schema.Types.ObjectId,
// 				ref: 'User',
// 				required: true,
// 			},
// 			joined: {
// 				type: Boolean,
// 				default: true,
// 			},
// 			name: {
// 				type: String,
// 				required: true,
// 			},
// 			isAlive: {
// 				type: Boolean,
// 				required: true,
// 			},
// 		},
// 		{
// 			timestamps: true,
// 		}
// 	)
// );

// module.exports = { meetingUser };
