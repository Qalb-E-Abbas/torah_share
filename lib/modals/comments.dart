import 'dart:convert';

Comments commentsFromJson(String str) => Comments.fromJson(json.decode(str));

String commentsToJson(Comments data) => json.encode(data.toJson());

class Comments {
  Comments({
    this.id,
    this.message,
    this.videoId,
    this.commenterId,
    this.createdOn,
  });

  String id;
  String message;
  String videoId;
  String commenterId;
  double createdOn;

  factory Comments.fromJson(Map<String, dynamic> json) => Comments(
        id: json["id"],
        message: json["message"],
        videoId: json["video_id"],
        commenterId: json["commenter_id"],
        createdOn: json["created_on"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "message": message,
        "video_id": videoId,
        "commenter_id": commenterId,
        "created_on": createdOn,
      };
}
