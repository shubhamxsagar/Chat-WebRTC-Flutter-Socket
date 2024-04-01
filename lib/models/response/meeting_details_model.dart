class MeeetingDetail {
  String? id;
  String? hostId;
  String? hostName;

  MeeetingDetail({this.id, this.hostId, this.hostName});

  factory MeeetingDetail.fromJson(dynamic json) {
    return MeeetingDetail(
      id: json['id'],
      hostId: json['hostId'],
      hostName: json['hostName'],
    );
  }
}
