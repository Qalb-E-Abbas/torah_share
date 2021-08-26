import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as MaterialDirection;
import 'package:get/get.dart';
import 'package:torah_share/screens/views_exporter.dart';
import 'package:torah_share/translations/codegen_loader.g.dart';

import 'screens/routes/routes_exporter.dart';
import 'utils/util_exporter.dart';

// message / notification when app is in background
Future<void> backgroundTerminatedHandler(RemoteMessage message) async {
  if (message != null) {}
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  notificationService.init();
  // message / notification when app is in background (uses its own isolate)
  FirebaseMessaging.onBackgroundMessage(backgroundTerminatedHandler);
  runApp(
    EasyLocalization(
      supportedLocales: [
        Locale('en'),
        Locale('he'),
      ],
      path: Common.assetsTranslations,
      fallbackLocale: Locale('en'),
      assetLoader: CodegenLoader(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) async {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.changeLanguage(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  Locale _locale;

  @override
  void initState() {
    _listenNotifications();
    super.initState();
  }

  changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      textDirection: MaterialDirection.TextDirection.ltr,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: _locale,
      title: Common.applicationName,
      initialRoute: AppRoutes.initialRoute,
      getPages: AppScreens.routes,
      theme: ThemeData(
        bottomSheetTheme:
            BottomSheetThemeData(backgroundColor: Colors.transparent),
      ),
      debugShowCheckedModeBanner: false,
    );
  }

  void _listenNotifications() async {
    if (Platform.isIOS) {
      _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
    }

    // make notifications effective
    notificationService.setOnNotificationClick((notification) {
      processNotificationClick(notification);
    });

    // actually gives the message on which user tap and open from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        processNotificationClick(message.data);
      }
    });

    // only run when app is in foreground
    FirebaseMessaging.onMessage.listen((message) {
      if (message != null) {
        notificationService.showNotification(
          message.notification.title,
          message.notification.body,
          message,
        );
      }
    });

    // only work when app is in background and is open in device
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (message != null) {
        processNotificationClick(message.data);
      }
    });
  }

  void processNotificationClick(Map<String, dynamic> notification) {
    // check type if video/message share
    if ((notification['type'] == Common.videoCloudSharedNotification) ||
        (notification['type'] == Common.messageCloudSharedNotification)) {
      // then take to inbox if receiver and sender id with inbox is available
      if (notification['sender_id'] != null &&
          notification['inbox_id'] != null) {
        Get.offAllNamed(AppRoutes.homeRoute);
        navigator.push(
          MaterialPageRoute(
            builder: (context) => Inbox(
              otherUserID: notification['sender_id'],
              inboxID: notification['inbox_id'],
            ),
          ),
        );
      }
    } else if (notification['type'] == Common.contactCloudSharedNotification) {
      // send to inbox screen
      Get.to(
        Home(
          screens: [
            OtherUserProfile(),
            Share(),
            CurrentUserProfile(),
          ],
          index: 1,
        ),
      );
    }
  }
}
