const jwt = require('jsonwebtoken');
const asyncHandler = require('express-async-handler');
const User = require('../models/postModel');

const newPost = asyncHandler(async (req, res) => {
	const newPost = new Post(req.body);
	try {
		const savePost = await newPost.save();
		res.status(200).json(savePost);
	} catch (e) {
		res.status(500).json({ error: e.message });
	}
});

const deletePost = asyncHandler(async (req, res) => {
	try {
		const post = await Post.findById(req.params.id);
		if (post.userId === req.body.userId) {
			await post.deleteOne();
			res.status(200).json('the post has been deleted');
		} else {
			res.status(403).json('you can delete only your post');
		}
	} catch (e) {
		res.status(500).json({ error: e.message });
	}
});

const likeOrDislike = asyncHandler(async (req, res) => {
	try {
		const post = await Post.findById(req.params.id);
		if (!post.likes.includes(req.body.userId)) {
			await post.updateOne({ $push: { likes: req.body.userId } });
			res.status(200).json('the post has been liked');
		} else {
			await post.updateOne({ $pull: { likes: req.body.userId } });
			res.status(200).json('the post has been disliked');
		}
	} catch (e) {
		res.status(500).json({ error: e.message });
	}
});

const getAllPosts = asyncHandler(async (req, res) => {
	try {
		const currentUser = await User.findById(req.params.id);
		const userPosts = await Post.find({ userId: currentUser._id });
		const followersPost = await Promise.all(
			currentUser.following.map((friendId) => {
				return Post.find({ userId: friendId });
			})
		);
		res.status(200).json(userPosts.concat(...followersPost));
	} catch (e) {
		res.status(500).json({ error: e.message });
	}
});

const getUserPost = asyncHandler(async (req, res) => {
	try {
		const userPost = await Post.find({ userId: req.params.id }).sort({
			createdAt: -1,
		});
		res.status(200).json(userPost);
	} catch (e) {
		res.status(500).json({ error: e.message });
	}
});

const getExplorePost = asyncHandler(async (req, res) => {
	try {
		const userPost = await Post.find({
			likes: { $exists: true },
		}).sort({ likes: -1 });
		res.status(200).json(userPost);
	} catch (e) {
		res.status(500).json({ error: e.message });
	}
});

export { newPost, deletePost, likeOrDislike, getAllPosts, getUserPost, getExplorePost };

