import 'dart:convert';

SubComment subCommentFromJson(String str) =>
    SubComment.fromJson(json.decode(str));

String subCommentToJson(SubComment data) => json.encode(data.toJson());

class SubComment {
  SubComment({
    this.id,
    this.message,
    this.commenterId,
    this.videoId,
    this.mainCommentId,
    this.createdOn,
  });

  String id;
  String message;
  String commenterId;
  String videoId;
  String mainCommentId;
  double createdOn;

  factory SubComment.fromJson(Map<String, dynamic> json) => SubComment(
        id: json["id"],
        message: json["message"],
        commenterId: json["commenter_id"],
        videoId: json["video_id"],
        mainCommentId: json["main_comment_id"],
        createdOn: json["created_on"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "message": message,
        "commenter_id": commenterId,
        "video_id": videoId,
        "main_comment_id": mainCommentId,
        "created_on": createdOn,
      };
}
