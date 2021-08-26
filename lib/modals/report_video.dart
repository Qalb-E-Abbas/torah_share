import 'dart:convert';

ReportVideo reportVideoFromJson(String str) =>
    ReportVideo.fromJson(json.decode(str));

String reportVideoToJson(ReportVideo data) => json.encode(data.toJson());

class ReportVideo {
  ReportVideo({
    this.id,
    this.message,
    this.reportedBy,
    this.videoUploaderId,
    this.videoId,
    this.createdOn,
    this.lastActivityOn,
    this.isReportResolved,
  });

  String id;
  String message;
  String reportedBy;
  String videoUploaderId;
  String videoId;
  double createdOn;
  double lastActivityOn;
  bool isReportResolved;

  factory ReportVideo.fromJson(Map<String, dynamic> json) => ReportVideo(
        id: json["id"],
        message: json["message"],
        reportedBy: json["reported_by"],
        videoUploaderId: json["video_uploader_id"],
        videoId: json["video_id"],
        createdOn: json["created_on"].toDouble(),
        lastActivityOn: json["last_activity_on"].toDouble(),
        isReportResolved: json["is_report_resolved"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "message": message,
        "reported_by": reportedBy,
        "video_uploader_id": videoUploaderId,
        "video_id": videoId,
        "created_on": createdOn,
        "last_activity_on": lastActivityOn,
        "is_report_resolved": isReportResolved,
      };
}
