import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_haha_guys/core/common/logger.dart';
import 'package:the_haha_guys/core/constants/hosts.dart';
import 'package:the_haha_guys/models/request/send_message_model.dart';
import 'package:the_haha_guys/models/response/message_list_model.dart';

// final messageAndReceiverProvider = FutureProvider.autoDispose
//     .family<http.Response, List<String>>((ref, data) async {
//   final sendMessage =
//       await SendMessageHelper.sendMessage(data[0], data[1], data[2]);
//   return sendMessage;
// });

final messageReciever = ChangeNotifierProvider<SendMessageHelper>((ref) => SendMessageHelper());

class SendMessageHelper extends ChangeNotifier {
  static var client = http.Client();

  Future<List<dynamic>> sendMessage(SendMessage model) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('x-auth-token');
    var response;

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      // 'Accept': 'application/json',
      'x-auth-token': token!,
    };
    var url = Uri.parse('$host/messages/send');
    // SendMessage sendMessage =
    //     SendMessage(message: message, senderId: senderId, recieverId: recieverId);
    try {
      response = await client.post(url,
          headers: requestHeaders, body: jsonEncode(model.toJson()));
      if (response.statusCode == 200) {
        MessageDetail messageDetail =
            MessageDetail.fromJson(jsonDecode(response.body));
        Map<String, dynamic> messageDetailMap = jsonDecode(response.body);
        logger.d('Messages: $messageDetailMap');
        logger.e('Message sent successfully');
        return [true, messageDetailMap, messageDetail];
        
      } else {
        logger.e('Failed to send message: ${response.reasonPhrase}');
      }
    } catch (e) {
      logger.e('Failed to send message: $e');
    }

    return response;
  }
}
