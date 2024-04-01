import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_haha_guys/core/common/logger.dart';
import 'package:the_haha_guys/core/constants/hosts.dart';
import 'package:the_haha_guys/models/response/message_list_model.dart';

// final messageDetailProvider =
//     FutureProvider.family<List<MessageDetail>, String>((ref, id) async {
//   final messageDetailData = await MessageDetailHelper.getMessageDetail(id);
//   return messageDetailData;
// });

final messageDetailRecieve =
    ChangeNotifierProvider<MessageDetailHelper>((ref) => MessageDetailHelper());

class MessageDetailHelper extends ChangeNotifier{
  static var client = http.Client();

  bool _typing = false;
  List<MessageDetail> _messageDetailData = [];
  List<String> _online = [];

  bool get typing => _typing;
  List<String> get online => _online;

  set typingStatus(bool newState) {
    _typing = newState;
    notifyListeners();
  }

  set onlineUsers(List<String> newList) {
    _online = newList;
    notifyListeners();
  }

  List<MessageDetail> get messageDetailData => _messageDetailData;

  Future<List<MessageDetail>> getMessageDetail(String id, int offset) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('x-auth-token');

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      // 'Accept': 'application/json',
      'x-auth-token': token!,
    };
    var url = Uri.parse('$host/messages/$id');
    // Uri.http(host, '/chats/chatBox/65b22ac8f0eb735afa9876e2');
    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      var jsonString = response.body;
      List<MessageDetail> chatBoxes = messageDetailFromJson(jsonString);
      logger.d(chatBoxes);
      return chatBoxes;
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<void> fetchMessageDetail(String id, int offset) async {
    _messageDetailData = await getMessageDetail(id, offset);
    notifyListeners(); // Notify listeners here
  }
}
