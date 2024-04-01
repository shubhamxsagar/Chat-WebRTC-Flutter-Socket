class SendMessage {
  String message;
  String senderId;
  String recieverId;
  SendMessage({
    required this.message,
    required this.senderId,
    required this.recieverId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["message"] = message;
    data["senderId"] = senderId;
    data["recieverId"] = recieverId;
    return data;
  }
}
