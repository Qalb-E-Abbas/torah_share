// To parse this JSON data, do
//
//     final cloudNotification = cloudNotificationFromJson(jsonString);

import 'dart:convert';

CloudNotification cloudNotificationFromJson(String str) =>
    CloudNotification.fromJson(json.decode(str));

String cloudNotificationToJson(CloudNotification data) =>
    json.encode(data.toJson());

class CloudNotification {
  CloudNotification({
    this.id,
    this.message,
    this.senderId,
    this.receiverId,
    this.receiverDeviceToken,
    this.inboxId,
    this.type,
    this.createdOn,
  });

  String id;
  String message;
  String senderId;
  String receiverId;
  String receiverDeviceToken;
  String inboxId;
  String type;
  double createdOn;

  factory CloudNotification.fromJson(Map<String, dynamic> json) =>
      CloudNotification(
        id: json["id"],
        message: json["message"],
        senderId: json["sender_id"],
        receiverId: json["receiver_id"] ?? null,
        receiverDeviceToken: json["receiver_device_token"] ?? null,
        inboxId: json["inbox_id"] ?? null,
        type: json["type"],
        createdOn: json["created_on"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "message": message,
        "sender_id": senderId,
        "receiver_id": receiverId ?? null,
        "receiver_device_token": receiverDeviceToken ?? null,
        "inbox_id": inboxId ?? null,
        "type": type,
        "created_on": createdOn
      };
}
