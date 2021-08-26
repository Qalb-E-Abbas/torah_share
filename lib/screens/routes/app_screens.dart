import 'package:get/get.dart';
import 'package:torah_share/screens/routes/routes_exporter.dart';

import '../../screens/views_exporter.dart';

class AppScreens {
  static const INITIAL = AppRoutes.initialRoute;
  static final routes = [
    GetPage(
      name: AppRoutes.initialRoute,
      page: () => Splash(),
    ),
    GetPage(
      name: AppRoutes.loginRoute,
      page: () => Login(),
    ),
    GetPage(
      name: AppRoutes.signupRoute,
      page: () => Signup(),
    ),
    GetPage(
      name: AppRoutes.homeRoute,
      page: () => Home(),
    ),
    GetPage(
      name: AppRoutes.termsAndConditionsRoute,
      page: () => TermsAndConditions(),
    ),
    GetPage(
      name: AppRoutes.privacyPolicyRoute,
      page: () => PrivacyPolicy(),
    ),
    GetPage(
      name: AppRoutes.disclaimerRoute,
      page: () => Disclaimer(),
    ),
    GetPage(
      name: AppRoutes.settingsRoute,
      page: () => Settings(),
    ),
    GetPage(
      name: AppRoutes.questionsRoute,
      page: () => Questions(),
    ),
    GetPage(
      name: AppRoutes.videoSamplesForApprovalRoute,
      page: () => VideoSamplesForApproval(),
    ),
    GetPage(
      name: AppRoutes.videoNotApprovedRoute,
      page: () => VideoNotApproved(),
    ),
    GetPage(
      name: AppRoutes.deleteVideoRoute,
      page: () => DeleteVideo(
        videoThumbnail:
            "https://images.unsplash.com/photo-1578133671540-edad0b3d689e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1351&q=80",
      ),
    ),
    GetPage(
      name: AppRoutes.deleteVideoSuccessRoute,
      page: () => DeleteVideoSuccess(
        videoThumbnail:
            "https://images.unsplash.com/photo-1578133671540-edad0b3d689e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1351&q=80",
      ),
    ),
    GetPage(
      name: AppRoutes.captureVideoRoute,
      page: () => CaptureVideo(),
    ),
    GetPage(
      name: AppRoutes.previewCaptureVideoRoute,
      page: () => PreviewCaptureVideo(),
    ),
    GetPage(
      name: AppRoutes.uploadVideoRoute,
      page: () => UploadVideo(),
    ),
    GetPage(
      name: AppRoutes.shareVideoRoute,
      page: () => ShareVideo(),
    ),
    GetPage(
      name: AppRoutes.shareContactsVideoRoute,
      page: () => ContactsShare(),
    ),
    GetPage(
      name: AppRoutes.currentUserProfileRoute,
      page: () => CurrentUserProfile(),
    ),
    GetPage(
      name: AppRoutes.otherUserProfileRoute,
      page: () => OtherUserProfile(),
    ),
    GetPage(
      name: AppRoutes.shareInbox,
      page: () => Inbox(),
    ),
    GetPage(
      name: AppRoutes.comment,
      page: () => Comment(),
    ),
    GetPage(
      name: AppRoutes.fullScreenVideo,
      page: () => FullScreenVideo(),
    ),
    GetPage(
      name: AppRoutes.adEngine,
      page: () => AdEngine(),
    ),
    GetPage(
      name: AppRoutes.followers,
      page: () => Followers(),
    ),
    GetPage(
      name: AppRoutes.followings,
      page: () => Followings(),
    ),
    GetPage(
      name: AppRoutes.editProfile,
      page: () => EditProfile(),
    ),
  ];
}
