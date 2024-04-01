// To parse this JSON data, do
//
//     final chatInitiate = chatInitiateFromJson(jsonString);

import 'dart:convert';

ChatInitiate chatInitiateFromJson(String str) =>
    ChatInitiate.fromJson(json.decode(str));

String chatInitiateToJson(ChatInitiate data) => json.encode(data.toJson());

class ChatInitiate {
  String? senderId;
  String? receiverId;

  ChatInitiate({
    this.senderId,
    this.receiverId,
  });

  factory ChatInitiate.fromJson(Map<String, dynamic> json) => ChatInitiate(
        senderId: json["senderId"],
        receiverId: json["receiverId"],
      );

  Map<String, dynamic> toJson() => {
        "senderId": senderId,
        "receiverId": receiverId,
      };
}
