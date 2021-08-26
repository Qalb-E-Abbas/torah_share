import 'dart:convert';

Shares sharesFromJson(String str) => Shares.fromJson(json.decode(str));

String sharesToJson(Shares data) => json.encode(data.toJson());

class Shares {
  String id;
  String videoID;
  String message;
  String senderId;
  String inboxId;
  String videoUrl;
  String thumbnailUrl;
  double createdOn;
  bool isVideo;

  Shares({
    this.id,
    this.videoID,
    this.message,
    this.senderId,
    this.inboxId,
    this.videoUrl,
    this.thumbnailUrl,
    this.createdOn,
    this.isVideo,
  });

  factory Shares.fromJson(Map<String, dynamic> json) => Shares(
        id: json["id"],
        videoID: json["video_id"] ?? null,
        inboxId: json["inbox_id"] ?? null,
        message: json["message"] ?? null,
        senderId: json["sender_id"],
        videoUrl: json["video_url"] ?? null,
        thumbnailUrl: json["thumbnail_url"] ?? null,
        createdOn: json["created_on"].toDouble(),
        isVideo: json["is_video"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "video_id": videoID ?? null,
        "inbox_id": inboxId ?? null,
        "message": message ?? null,
        "sender_id": senderId,
        "video_url": videoUrl ?? null,
        "thumbnail_url": thumbnailUrl ?? null,
        "created_on": createdOn,
        "is_video": isVideo,
      };
}
