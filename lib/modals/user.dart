import 'dart:convert';

UserModal userModalFromJson(String str) => UserModal.fromJson(json.decode(str));

String userModalToJson(UserModal data) => json.encode(data.toJson());

class UserModal {
  UserModal({
    this.userID,
    this.username,
    this.profileImageUrl,
    this.aboutMe,
    this.email,
    this.deviceToken,
    this.isProfileVerified,
    this.takeInboxShares,
    this.takeInboxMessages,
    this.searchQueries,
  });

  String userID;
  String username;
  String profileImageUrl;
  String email;
  String aboutMe;
  String deviceToken;
  bool isProfileVerified;
  bool takeInboxShares;
  bool takeInboxMessages;
  List<String> searchQueries;

  factory UserModal.fromJson(Map<String, dynamic> json) => UserModal(
        userID: json["userID"],
        username: json["username"],
        profileImageUrl: json["profileImageURL"],
        aboutMe: json["about_me"],
        deviceToken: json["device_token"] ?? null,
        email: json["email"],
        isProfileVerified: json["isProfileVerified"],
        takeInboxShares: json["takeInboxShares"],
        takeInboxMessages: json["takeInboxMessages"],
        searchQueries: List<String>.from(json["search_queries"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "userID": userID,
        "username": username,
        "profileImageURL": profileImageUrl,
        "about_me": aboutMe,
        "device_token": deviceToken ?? null,
        "email": email,
        "isProfileVerified": isProfileVerified,
        "takeInboxShares": takeInboxShares,
        "takeInboxMessages": takeInboxMessages,
        "search_queries": List<dynamic>.from(searchQueries.map((x) => x)),
      };
}
