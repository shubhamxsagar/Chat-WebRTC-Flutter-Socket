// To parse this JSON data, do
//
//     final messageDetail = messageDetailFromJson(jsonString);

import 'dart:convert';

List<MessageDetail> messageDetailFromJson(String str) => List<MessageDetail>.from(json.decode(str).map((x) => MessageDetail.fromJson(x)));

String messageDetailToJson(List<MessageDetail> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MessageDetail {
    String? id;
    String? senderId;
    String? recieverId;
    String? message;
    DateTime? createdAt;
    DateTime? updatedAt;
    int? v;

    MessageDetail({
        this.id,
        this.senderId,
        this.recieverId,
        this.message,
        this.createdAt,
        this.updatedAt,
        this.v,
    });

    factory MessageDetail.fromJson(Map<String, dynamic> json) => MessageDetail(
        id: json["_id"],
        senderId: json["senderId"],
        recieverId: json["recieverId"],
        message: json["message"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "senderId": senderId,
        "recieverId": recieverId,
        "message": message,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
    };
}














// // To parse this JSON data, do
// //
// //     final messageDetail = messageDetailFromJson(jsonString);

// import 'dart:convert';

// List<MessageDetail> messageDetailFromJson(String str) => List<MessageDetail>.from(json.decode(str).map((x) => MessageDetail.fromJson(x)));

// String messageDetailToJson(List<MessageDetail> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// class MessageDetail {
//     String? id;
//     ErId? senderId;
//     ErId? receiverId;
//     String? message;
//     DateTime? createdAt;
//     DateTime? updatedAt;
//     int? v;

//     MessageDetail({
//         this.id,
//         this.senderId,
//         this.receiverId,
//         this.message,
//         this.createdAt,
//         this.updatedAt,
//         this.v,
//     });

//     factory MessageDetail.fromJson(Map<String, dynamic> json) => MessageDetail(
//         id: json["_id"],
//         senderId: json["SenderId"] == null ? null : ErId.fromJson(json["SenderId"]),
//         receiverId: json["ReceiverId"] == null ? null : ErId.fromJson(json["ReceiverId"]),
//         message: json["message"],
//         createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
//         updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
//         v: json["__v"],
//     );

//     Map<String, dynamic> toJson() => {
//         "_id": id,
//         "SenderId": senderId?.toJson(),
//         "ReceiverId": receiverId?.toJson(),
//         "message": message,
//         "createdAt": createdAt?.toIso8601String(),
//         "updatedAt": updatedAt?.toIso8601String(),
//         "__v": v,
//     };
// }

// class ErId {
//     String? id;
//     String? name;
//     String? profilePic;

//     ErId({
//         this.id,
//         this.name,
//         this.profilePic,
//     });

//     factory ErId.fromJson(Map<String, dynamic> json) => ErId(
//         id: json["_id"],
//         name: json["name"],
//         profilePic: json["profilePic"],
//     );

//     Map<String, dynamic> toJson() => {
//         "_id": id,
//         "name": name,
//         "profilePic": profilePic,
//     };
// }
