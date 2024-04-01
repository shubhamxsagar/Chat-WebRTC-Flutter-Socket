import 'package:the_haha_guys/models/user_model.dart';

class ChatState {
  //Authentication state values
  final String? errMsg;
  final bool? isAuthenticated;
  final bool? regLoading;
  final bool? logLoading;
  final UserModel? user;
  final List<UserModel>? allUsers;

  //Chat state values
  final String? activeUser;
  final String? activeRoom;

  //Chat Messages
  final List<Map<String, dynamic>>? messages;

  ChatState({
    this.errMsg,
    this.isAuthenticated,
    this.regLoading,
    this.logLoading,
    this.user,
    this.allUsers,
    this.activeUser,
    this.activeRoom,
    this.messages,
  });

  ChatState copyWith({
    String? errMsg,
    bool? isAuthenticated,
    bool? regLoading,
    bool? logLoading,
    UserModel? user,
    List<UserModel>? allUsers,
    String? activeUser,
    String? activeRoom,
    List<Map<String, dynamic>>? messages,
  }) {
    return ChatState(
      errMsg: errMsg ?? this.errMsg,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      regLoading: regLoading ?? this.regLoading,
      logLoading: logLoading ?? this.logLoading,
      user: user ?? this.user,
      allUsers: allUsers ?? this.allUsers,
      activeUser: activeUser ?? this.activeUser,
      activeRoom: activeRoom ?? this.activeRoom,
      messages: messages ?? this.messages,
    );
  }
}
