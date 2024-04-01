// To parse this JSON data, do
//
//     final chatBox = chatBoxFromJson(jsonString);

import 'dart:convert';

List<ChatBox> chatBoxFromJson(String str) => List<ChatBox>.from(json.decode(str).map((x) => ChatBox.fromJson(x)));

String chatBoxToJson(List<ChatBox> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ChatBox {
    String? id;
    Participants? participants;
    String? latestMessage;

    ChatBox({
        this.id,
        this.participants,
        this.latestMessage,
    });

    factory ChatBox.fromJson(Map<String, dynamic> json) => ChatBox(
        id: json["_id"],
        participants: json["participants"] == null ? null : Participants.fromJson(json["participants"]),
        latestMessage: json["latestMessage"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "participants": participants?.toJson(),
        "latestMessage": latestMessage,
    };
}

class Participants {
    String? id;
    String? name;
    String? profilePic;

    Participants({
        this.id,
        this.name,
        this.profilePic,
    });

    factory Participants.fromJson(Map<String, dynamic> json) => Participants(
        id: json["_id"],
        name: json["name"],
        profilePic: json["profilePic"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "profilePic": profilePic,
    };
}









// // To parse this JSON data, do
// //
// //     final chatBox = chatBoxFromJson(jsonString);

// import 'dart:convert';

// List<ChatBox> chatBoxFromJson(String str) =>
//     List<ChatBox>.from(json.decode(str).map((x) => ChatBox.fromJson(x)));

// String chatBoxToJson(List<ChatBox> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// class ChatBox {
//   String? id;
//   String? senderId;
//   ReceiverId? receiverId;
//   String? message;
//   DateTime? createdAt;
//   DateTime? updatedAt;
//   int? v;

//   ChatBox({
//     this.id,
//     this.senderId,
//     this.receiverId,
//     this.message,
//     this.createdAt,
//     this.updatedAt,
//     this.v,
//   });

//   factory ChatBox.fromJson(Map<String, dynamic> json) => ChatBox(
//         id: json["_id"],
//         senderId: json["SenderId"],
//         receiverId: json["ReceiverId"] == null
//             ? null
//             : ReceiverId.fromJson(json["ReceiverId"]),
//         message: json["message"],
//         createdAt: json["createdAt"] == null
//             ? null
//             : DateTime.parse(json["createdAt"]),
//         updatedAt: json["updatedAt"] == null
//             ? null
//             : DateTime.parse(json["updatedAt"]),
//         v: json["__v"],
//       );

//   Map<String, dynamic> toJson() => {
//         "_id": id,
//         "SenderId": senderId,
//         "ReceiverId": receiverId?.toJson(),
//         "message": message,
//         "createdAt": createdAt?.toIso8601String(),
//         "updatedAt": updatedAt?.toIso8601String(),
//         "__v": v,
//       };
// }

// class ReceiverId {
//   String? id;
//   String? name;
//   String? email;
//   String? profilePic;

//   ReceiverId({
//     this.id,
//     this.name,
//     this.email,
//     this.profilePic,
//   });

//   factory ReceiverId.fromJson(Map<String, dynamic> json) => ReceiverId(
//         id: json["_id"],
//         name: json["name"],
//         email: json["email"],
//         profilePic: json["profilePic"],
//       );

//   Map<String, dynamic> toJson() => {
//         "_id": id,
//         "name": name,
//         "email": email,
//         "profilePic": profilePic,
//       };
// }
