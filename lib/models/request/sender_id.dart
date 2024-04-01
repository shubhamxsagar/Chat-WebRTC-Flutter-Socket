class SenderId{
  String senderId;
  SenderId({
    required this.senderId,
  });

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data["senderId"] = senderId;
    return data;
  }
}