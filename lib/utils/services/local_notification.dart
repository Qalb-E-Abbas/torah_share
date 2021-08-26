import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:torah_share/utils/util_exporter.dart';

class NotificationService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final BehaviorSubject<ReceivedNotification>
      didReceivedLocalNotificationSubject =
      BehaviorSubject<ReceivedNotification>();
  var initializeSettings;
  Map<String, dynamic> notificationPayload;

  NotificationService._() {
    // initialize for android and ios
    init();
  }

  init() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    if (Platform.isIOS) _requestIOSPermission();

    initializePlatformSpecific();
  }

  void _requestIOSPermission() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        .requestPermissions(
          alert: false,
          badge: true,
          sound: true,
        );
  }

  void initializePlatformSpecific() {
    var androidInitializationSettings = AndroidInitializationSettings(
      "notification_icons",
    );
    var iosInitializationSettings = IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: (
          id,
          title,
          body,
          payload,
        ) {
          ReceivedNotification receivedNotification = ReceivedNotification(
            notificationID: id,
            notificationTitle: title,
            notificationBody: body,
            notificationPayload: payload,
          );

          didReceivedLocalNotificationSubject.add(receivedNotification);
        });
    initializeSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );
  }

  setListenerForLowerVersions(Function onNotificationOnLowerVersions) {
    didReceivedLocalNotificationSubject.listen((receivedNotification) {
      onNotificationOnLowerVersions(receivedNotification);
    });
  }

  setOnNotificationClick(
      Function(Map<String, dynamic>) onNotificationClick) async {
    await flutterLocalNotificationsPlugin.initialize(initializeSettings,
        onSelectNotification: (String payload) async {
      onNotificationClick(notificationPayload);
    });
  }

  Future<void> showNotification(
      String title, String body, RemoteMessage message) async {
    var androidChannelSpecific = AndroidNotificationDetails(
      Common.channelID,
      Common.channelName,
      Common.channelDescription,
      priority: Priority.max,
      importance: Importance.max,
      enableLights: true,
      ledColor: AppColors.primary,
      ledOnMs: 2,
      ledOffMs: 6,
      playSound: true,
      icon: "notification_icons",
    );

    var iosChannelSpecific = IOSNotificationDetails();
    var platformChannelSettings = NotificationDetails(
      android: androidChannelSpecific,
      iOS: iosChannelSpecific,
    );
    notificationPayload = message.data;
    FlutterLocalNotificationsPlugin flutterLocalNotificationPlugin =
        new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationPlugin.show(
      0,
      title,
      body,
      platformChannelSettings,
      payload: message.data.toString(),
    );
  }
}

NotificationService notificationService = NotificationService._();

class ReceivedNotification {
  final int notificationID;
  final String notificationTitle;
  final String notificationBody;
  final String notificationPayload;

  ReceivedNotification({
    @required this.notificationID,
    @required this.notificationTitle,
    @required this.notificationBody,
    @required this.notificationPayload,
  });
}
