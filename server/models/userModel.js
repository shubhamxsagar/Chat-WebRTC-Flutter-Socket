const mongoose = require('mongoose'); // Erase if already required

// Declare the Schema of the Mongo model
var userSchema = mongoose.Schema(
	{
		name: {
			type: String,
			required: true,
		},
		email: {
			type: String,
			required: true,
		},
		profilePic: {
			type: String,
			required: true,
		},
		followers: { type: Array, defaultValue: [] },
		following: { type: Array, defaultValue: [] },
		description: { type: String },
	},
	{
		timestamps: true,
	}
);

//Export the model
const User = mongoose.model('User', userSchema);
module.exports = User;
