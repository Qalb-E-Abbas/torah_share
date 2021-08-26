import 'dart:convert';

Follower followerFromJson(String str) => Follower.fromJson(json.decode(str));

String followerToJson(Follower data) => json.encode(data.toJson());

class Follower {
  Follower({
    this.id,
    this.followingId,
    this.followerId,
    this.createdOn,
  });

  String id;
  String followingId;
  String followerId;
  double createdOn;

  factory Follower.fromJson(Map<String, dynamic> json) => Follower(
        id: json["id"],
        followingId: json["following_id"],
        followerId: json["follower_id"],
        createdOn: json["created_on"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "following_id": followingId,
        "follower_id": followerId,
        "created_on": createdOn,
      };
}
