import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:torah_share/modals/ad_engine.dart';
import 'package:torah_share/modals/modals_exporter.dart';
import 'package:torah_share/screens/routes/app_routes.dart';
import 'package:torah_share/screens/views_exporter.dart';
import 'package:torah_share/translations/locale_keys.g.dart';
import 'package:torah_share/utils/util_exporter.dart';
import 'package:torah_share/utils/widgets/widgets_exporter.dart';
import 'package:video_compress/video_compress.dart';

class Common {
  static final String applicationName = "TorahShare";
  static const String assetsImages = "assets/images/";
  static const String assetsFonts = "assets/fonts/";
  static const String assetsAnimations = "assets/animations/";
  static const String assetsIcons = "assets/icons/";
  static const String assetsIconsFilled = "assets/icons/filled/";
  static const String assetsIconsOutlined = "assets/icons/outlined/";
  static const String assetsTranslations = "assets/translations/";

  // firebase constants
  static const String videosCollection = "Videos";
  static const String usersCollection = "Users";
  static const String sharesCollection = "Shares";
  static const String inboxCollection = "Inbox";
  static const String commentsCollection = "Comments";
  static const String subCommentsCollection = "SubComments";
  static const String approvalsCollection = "Approvals";
  static const String followersCollection = "Followers";
  static const String participantsCollection = "Participants";
  static const String sharedWithCollection = "SharedWith";
  static const String notificationsCollection = "Notifications";
  static const String cloudNotificationsCollection = "CloudNotifications";
  static const String adEngineCollection = "AdEngine";
  static const String reportVideoCollection = "ReportVideo";

  // Shared Preference Variables
  static const String sharedQuestionsList = "questions";
  static const String sharedAnswersList = "answers";

  // Cloud Notification constants
  static const String videoCloudSharedNotification =
      "VIDEO_SHARED_CLOUD_NOTIFICATION";
  static const String messageCloudSharedNotification =
      "MESSAGE_SHARED_CLOUD_NOTIFICATION";
  static const String contactCloudSharedNotification =
      "CONTACT_SHARED_CLOUD_NOTIFICATION";

  // Notification channels
  static const String channelID = "CLOUD_MESSAGES_CHANNEL";
  static const String channelName = "CLOUD_MESSAGES";
  static const String channelDescription = "CLOUD_MESSAGES_FOR_SHARES";

  // app constants
  static const String REPORT_VIDEO = "REPORT_VIDEO";
  static const String SHARE_VIDEO = "SHARE_VIDEO";
  static const String UNFOLLOW_USER_FROM_VIDEO = "UNFOLLOW_USER_FROM_VIDEO";

  static showOnePrimaryButtonDialog({
    @required BuildContext context,
    @required String dialogMessage,
    String primaryButtonText,
    Function primaryButtonOnPressed,
  }) {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text(Common.applicationName),
        content: new Text(dialogMessage),
        actions: <Widget>[
          DialogPrimaryButton(
            onPressed: primaryButtonOnPressed ?? () => Navigator.pop(context),
            buttonText: primaryButtonText ?? tr(LocaleKeys.login),
          ),
        ],
      ),
    );
  }

  static Future<bool> askLocationPermission(BuildContext context) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if ((permission == LocationPermission.denied) ||
        (permission == LocationPermission.deniedForever)) {
      LocationPermission requestPermission =
          await Geolocator.requestPermission();
      if (requestPermission == LocationPermission.denied)
        Common.showOnePrimaryButtonDialog(
          context: context,
          dialogMessage:
              "${tr(LocaleKeys.please_grant_location_permission_to_TorahShare)}",
          primaryButtonText: tr(LocaleKeys.grant_permission),
          primaryButtonOnPressed: () {
            Navigator.pop(context);
            askLocationPermission(context);
          },
        );
      return false;
    } else
      return true;
  }

  static showSnackBar(String title, String message) {
    return Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
    );
  }

  static int getCurrentTimeInMilliseconds() {
    final DateTime now = DateTime.now();
    return now.millisecondsSinceEpoch;
  }

  static Future<void> deleteQuestionsAnswersSharedPrefs() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove(Common.sharedQuestionsList);
    await sharedPreferences.remove(Common.sharedAnswersList);
    return;
  }

  static showProgressDialog(
      {@required BuildContext context, @required String progressTitle}) {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
            Text(
              progressTitle,
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(),
          ],
        ),
      ),
    );
  }

  static processPopupMenuRoute({
    @required VideoPopupMenuItem videoPopupMenuItem,
    String videoID,
    String videoThumbnail,
    String videoURL,
    String uploaderID,
    String reporterID,
    String reporterName,
    Video video,
    UserModal currentUser,
    UserModal otherUser,
  }) async {
    Get.back();
    if (videoPopupMenuItem.route == AppRoutes.comment) {
      Get.to(
        Comment(
          video: video,
        ),
      );
    } else if (videoPopupMenuItem.route == Common.REPORT_VIDEO) {
      // report the video and inform admin
      // show dialog once reported
      ApiRequests.sendVideoReport(
        reporterName,
        videoID,
        uploaderID,
        reporterID,
      )
          .then(
            (value) => Common.showSnackBar(
              tr(LocaleKeys.reported_successfully),
              tr(LocaleKeys
                  .thank_you_for_being_responsible_we_will_investigate_the_report_and_will_take_actions_accordingly),
            ),
          )
          .onError(
            (error, stackTrace) => Common.showSnackBar(
              tr(LocaleKeys.reporting_failed),
              "$error",
            ),
          );
    } else if (videoPopupMenuItem.route == Common.SHARE_VIDEO) {
      // open share dialog to let user share the video including whatsapp
      // video id is required
      Get.to(
        () => ShareVideo(video: video),
      );
    } else if (videoPopupMenuItem.route == Common.UNFOLLOW_USER_FROM_VIDEO) {
      // un-follow the user
      // follower id and following id is required
      await ApiRequests.unFollowUser(currentUser.userID, otherUser.userID);
      Common.showSnackBar("${tr(LocaleKeys.unfollowed)} ${otherUser.username}",
          "${tr(LocaleKeys.successfully_unfollowed_the_user)}");
    } else if (videoPopupMenuItem.route == AppRoutes.deleteVideoRoute) {
      Get.to(
        () => DeleteVideo(
          videoThumbnail: videoThumbnail,
          videoURL: videoURL,
          videoID: videoID,
        ),
      );
    }
    // Get.toNamed(videoPopupMenuItem.route);
  }

  static Future<File> getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    return File(pickedFile.path);
  }

  static Future<File> getThumbnail(String videoURL) async {
    return await VideoCompress.getFileThumbnail(videoURL);
  }

  static Future<void> openAdAndFullViewVideo(String url) async {
    String adUrl = "";
    AdEngineModal adEngineModal = await ApiRequests.getVideoAd();
    adUrl = adEngineModal.adUrl;
    if (adUrl != null && adUrl.isNotEmpty) {
      Get.to(
        () => AdEngine(
          adURL: adUrl,
          videoURL: url,
        ),
      );
      return;
    }
    // Get.to(FullScreenVideo(videoURL: url));
  }

  static List<String> getSearchQueries(String username) {
    List<String> output = [];
    for (int i = 0; i < username.length; i++) {
      if (i != username.length - 1) {
        output.add(username[i]);
      }
      List<String> temp = [username[i]];
      for (int j = i + 1; j < username.length; j++) {
        temp.add(username[j]);
        output.add(temp.join());
      }
    }
    return output;
  }

  static Future<void> processLogout() async {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    await ApiRequests.deleteDeviceToken(user.uid);
    if (user.providerData[0].providerId == "google.com") {
      final googleSignIn = GoogleSignIn();
      try {
        await googleSignIn.disconnect();
      } on PlatformException catch (e) {
        await auth.signOut();
      }
    } else
      await auth.signOut();
    Get.offAllNamed(AppRoutes.loginRoute);
  }
}
