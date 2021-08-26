import 'dart:convert';

InboxModal inboxModalFromJson(String str) =>
    InboxModal.fromJson(json.decode(str));

String inboxModalToJson(InboxModal data) => json.encode(data.toJson());

class InboxModal {
  InboxModal({
    this.id,
    this.createdBy,
    this.participants,
    this.lastMessage,
    this.isLastVideo,
    this.createdOn,
    this.lastActivityAt,
  });

  String id;
  String createdBy;
  String lastMessage;
  List<String> participants;
  bool isLastVideo;
  double createdOn;
  double lastActivityAt;

  factory InboxModal.fromJson(Map<String, dynamic> json) => InboxModal(
        id: json["id"],
        createdBy: json["created_by"],
        lastMessage: json["last_message"] ?? null,
        participants: List<String>.from(json["participants"].map((x) => x)),
        isLastVideo: json["is_last_video"],
        createdOn: json["created_on"].toDouble(),
        lastActivityAt: json["last_activity_at"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_by": createdBy,
        "last_message": lastMessage ?? null,
        "participants": List<dynamic>.from(participants.map((x) => x)),
        "is_last_video": isLastVideo,
        "created_on": createdOn,
        "last_activity_at": lastActivityAt,
      };
}
