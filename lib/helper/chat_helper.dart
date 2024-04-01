import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_haha_guys/core/common/logger.dart';
import 'package:the_haha_guys/core/constants/hosts.dart';
import 'package:the_haha_guys/models/response/chat_box_models.dart';

// final chatBoxProvider = ChangeNotifierProvider<ChatHelper>((ref) => ChatHelper());

class ChatHelper {
  static var client = http.Client();

  static Future<List<ChatBox>> getChatBox() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('x-auth-token');
    final String? uid = prefs.getString('uid');

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      // 'Accept': 'application/json',
      'x-auth-token': token!,
    };
    var url = Uri.parse('$host/messages/chatBox/$uid');
    // Uri.http(host, '/chats/chatBox/65b22ac8f0eb735afa9876e2');
    var response = await client.get(
      url,
      headers: requestHeaders,
    );
    logger.d(response.body);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      List<ChatBox> chatBoxes = chatBoxFromJson(jsonString);
      return chatBoxes;
      // var jsonString = chatBoxFromJson(response.body);
      // return jsonString;
    } else {
      throw Exception('Failed to load');
    }
  }
}
