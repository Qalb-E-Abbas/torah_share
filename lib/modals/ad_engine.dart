// To parse this JSON data, do
//
//     final adEngine = adEngineFromJson(jsonString);

import 'dart:convert';

AdEngineModal adEngineModalFromJson(String str) =>
    AdEngineModal.fromJson(json.decode(str));

String adEngineModalToJson(AdEngineModal data) => json.encode(data.toJson());

class AdEngineModal {
  AdEngineModal({
    this.id,
    this.adUrl,
    this.createdOn,
    this.lastActivityOn,
  });

  String id;
  String adUrl;
  double createdOn;
  double lastActivityOn;

  factory AdEngineModal.fromJson(Map<String, dynamic> json) => AdEngineModal(
        id: json["id"],
        adUrl: json["ad_url"],
        createdOn: json["created_on"].toDouble() ?? null,
        lastActivityOn: json["last_activity_on"].toDouble() ?? null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "ad_url": adUrl,
        "created_on": createdOn ?? null,
        "last_activity_on": lastActivityOn ?? null,
      };
}
