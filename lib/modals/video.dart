import 'dart:convert';

Video videoFromJson(String str) => Video.fromJson(json.decode(str));

String videoToJson(Video data) => json.encode(data.toJson());

class Video {
  Video({
    this.videoId,
    this.uploaderId,
    this.createdOn,
    this.caption,
    this.tags,
    this.searchQueries,
    this.videoUrl,
    this.thumbnailURL,
  });

  String videoId;
  String uploaderId;
  String caption;
  double createdOn;
  List<String> tags;
  List<String> searchQueries;
  String videoUrl;
  String thumbnailURL;

  factory Video.fromJson(Map<String, dynamic> json) => Video(
        videoId: json["video_id"],
        uploaderId: json["uploader_id"],
        createdOn: json["created_on"].toDouble(),
        caption: json["caption"],
        tags: List<String>.from(json["tags"].map((x) => x)),
        searchQueries: List<String>.from(json["search_queries"].map((x) => x)),
        videoUrl: json["video_url"],
        thumbnailURL: json["thumbnail_url"],
      );

  Map<String, dynamic> toJson() => {
        "video_id": videoId,
        "uploader_id": uploaderId,
        "created_on": createdOn,
        "caption": caption,
        "tags": List<String>.from(tags.map((x) => x)),
        "search_queries": List<String>.from(tags.map((x) => x)),
        "video_url": videoUrl,
        "thumbnail_url": thumbnailURL,
      };
}
