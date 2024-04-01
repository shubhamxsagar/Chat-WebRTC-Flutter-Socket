import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:the_haha_guys/controller/user_controller.dart';
import 'package:the_haha_guys/models/user_model.dart';

final userViewModelProvider = ChangeNotifierProvider<UserViewModel>(
  (ref) => UserViewModel(ref.read(userContollerProvider)),
);

class UserViewModel extends ChangeNotifier {
  final UserController _userController;
  UserViewModel(this._userController);

  bool _loading = false;
  UserModel? _userModel;
  // Add an error model if needed

  bool get loading => _loading;
  UserModel? get userModel => _userModel;
  // Add a getter for error if needed

  setLoading(bool loading) async {
    _loading = loading;
  }

  setUserModel(UserModel? userModel) async {
    _userModel = userModel;
  }

  // Add a method for setting error if needed

  Future<void> fetchUser(String token) async {
    try {
      setLoading(true);

      final UserModel? user = await _userController.getUser(token);
      setUserModel(user);
      // Set error to null if needed
    } catch (e) {
      // Set error using a method if needed
    } finally {
      setLoading(false);
    }
  }
}
