const mongoose = require('mongoose');
const autopopulate = require('mongoose-autopopulate');

const postSchema = new mongoose.Schema(
	{
		userId: {
			type: String,
			required: true,
		},
		description: {
			type: String,
			required: true,
			max: 280,
		},
		likes: {
			type: Array,
			defaultValue: [],
		},
	},
	{ timestamps: true }
);

const Post = mongoose.model('Post', postSchema);
module.exports = Post;