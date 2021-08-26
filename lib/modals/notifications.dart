import 'dart:convert';

Notifications notificationsFromJson(String str) =>
    Notifications.fromJson(json.decode(str));

String notificationsToJson(Notifications data) => json.encode(data.toJson());

class Notifications {
  Notifications({
    this.notificationId,
    this.inboxId,
    this.message,
    this.contactName,
    this.notificationFrom,
    this.notificationFor,
    this.isRead,
    this.selfNotification,
    this.createdOn,
  });

  String notificationId;
  String inboxId;
  String message;
  String contactName;
  String notificationFrom;
  String notificationFor;
  bool isRead;
  bool selfNotification;
  double createdOn;

  factory Notifications.fromJson(Map<String, dynamic> json) => Notifications(
        notificationId: json["notification_id"],
        inboxId: json["inbox_id"] ?? null,
        message: json["message"],
        contactName: json["contact_name"] ?? null,
        notificationFrom: json["notification_from"] ?? null,
        notificationFor: json["notification_for"],
        isRead: json["is_read"],
        selfNotification: json["self_notification"] ?? null,
        createdOn: json["created_on"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "notification_id": notificationId,
        "inbox_id": inboxId ?? null,
        "message": message,
        "contact_name": contactName ?? null,
        "notification_from": notificationFrom ?? null,
        "notification_for": notificationFor,
        "is_read": isRead,
        "self_notification": selfNotification ?? null,
        "created_on": createdOn,
      };
}
