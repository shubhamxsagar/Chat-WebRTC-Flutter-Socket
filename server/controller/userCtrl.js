const jwt = require('jsonwebtoken');
const asyncHandler = require('express-async-handler');
const User = require('../models/userModel');

const loginUser = asyncHandler(async (req, res) => {
	try {
		const { name, email, profilePic } = req.body;
		//email already exists?
		let user = await User.findOne({ email });
		if (!user) {
			user = new User({
				email,
				profilePic,
				name,
			});
			user = await user.save();
		}
		const token = jwt.sign({ id: user._id }, 'passwordKey');
		res.json({ user, token });
	} catch (e) {
		res.status(500).json({ error: e.message });
	}
});

const getUserData = asyncHandler(async (req, res) => {
	try {
		const user = await User.findById(req.user);
		res.json({ user, token: req.token });

	} catch (e) {
		res.status(500).json({ error: e.message });
	}
});

const getAllUsers = asyncHandler(async (req, res) => {
	try {
		const user = await User.findMany(req.user);
		res.json({ user, token: req.token });
	} catch (e) {
		res.status(500).json({ error: e.message });
	}
});

const follow = asyncHandler(async (req, res, next) => {
	try {
		//user
		const user = await User.findById(req.params.id);
		//current user
		const currentUser = await User.findById(req.body.id);

		if (!user.followers.includes(req.body.id)) {
			await user.updateOne({
				$push: { followers: req.body.id },
			});

			await currentUser.updateOne({ $push: { following: req.params.id } });
		} else {
			res.status(403).json('you already follow this user');
		}
		res.status(200).json('following the user');
	} catch (err) {
		next(err);
	}
});

const unFollow = asyncHandler(async (req, res, next) => {
	try {
		//user
		const user = await User.findById(req.body.id2);
		//current user
		const currentUser = await User.findById(req.body.id);

		if (currentUser.following.includes(req.body.id2)) {
			await user.updateOne({
				$pull: { followers: req.body.id },
			});

			await currentUser.updateOne({ $pull: { following: req.body.id2 } });
		} else {
			res.status(403).json('you are not following this user');
		}
		res.status(200).json('unfollowing the user');
	} catch (err) {
		next(err);
	}
});

module.exports = { loginUser, getUserData, follow, unFollow };
