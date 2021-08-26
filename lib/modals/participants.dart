import 'dart:convert';

Participants participantsFromJson(String str) =>
    Participants.fromJson(json.decode(str));

String participantsToJson(Participants data) => json.encode(data.toJson());

class Participants {
  Participants({
    this.id,
    this.userId,
    this.otherUserId,
    this.createdOn,
    this.inboxId,
  });

  String id;
  String userId;
  String otherUserId;
  String inboxId;
  double createdOn;

  factory Participants.fromJson(Map<String, dynamic> json) => Participants(
        id: json["id"],
        userId: json["user_id"],
        otherUserId: json["other_user_id"],
        createdOn: json["created_on"],
        inboxId: json["inbox_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "other_user_id": otherUserId,
        "created_on": createdOn,
        "inbox_id": inboxId,
      };
}
