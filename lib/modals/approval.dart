import 'dart:convert';

Approval approvalFromJson(String str) => Approval.fromJson(json.decode(str));

String approvalToJson(Approval data) => json.encode(data.toJson());

class Approval {
  Approval({
    this.id,
    this.answers,
    this.questions,
    this.videos,
    this.updatedOn,
    this.userId,
    this.pendingApproval,
  });

  String id;
  List<String> answers;
  List<String> questions;
  List<String> videos;
  double updatedOn;
  String userId;
  bool pendingApproval;

  factory Approval.fromJson(Map<String, dynamic> json) => Approval(
        id: json["id"],
        answers: List<String>.from(json["answers"].map((x) => x)),
        questions: List<String>.from(json["questions"].map((x) => x)),
        videos: List<String>.from(json["videos"].map((x) => x)),
        updatedOn: json["updated_on"].toDouble(),
        userId: json["user_id"],
        pendingApproval: json["pending_approval"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "answers": List<dynamic>.from(answers.map((x) => x)),
        "questions": List<dynamic>.from(questions.map((x) => x)),
        "videos": List<dynamic>.from(videos.map((x) => x)),
        "updated_on": updatedOn,
        "user_id": userId,
        "pending_approval": pendingApproval,
      };
}
