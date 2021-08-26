import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:torah_share/modals/modals_exporter.dart';
import 'package:torah_share/screens/routes/routes_exporter.dart';
import 'package:torah_share/screens/views_exporter.dart';
import 'package:torah_share/translations/locale_keys.g.dart';
import 'package:torah_share/utils/util_exporter.dart';
import 'package:torah_share/utils/widgets/widgets_exporter.dart';

class ShareVideo extends StatefulWidget {
  final Video video;

  const ShareVideo({
    Key key,
    @required this.video,
  }) : super(key: key);

  @override
  _ShareVideoState createState() => _ShareVideoState();
}

class _ShareVideoState extends State<ShareVideo> {
  bool _contactsCheckbox = false, _followersCheckbox = true, isLoading = false;
  UserModal _currentUser;

  @override
  void initState() {
    _getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: AppColors.primary,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 20.0),
                  child: CustomAppBar(
                    textChild: LargeWhiteBoldText(value: tr(LocaleKeys.share)),
                    willPop: true,
                    hasIconAndTextWhiteTheme: true,
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(40.0),
                              topLeft: Radius.circular(40.0),
                            ),
                          ),
                          padding: EdgeInsets.all(13.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(40.0),
                              topLeft: Radius.circular(40.0),

                            ),
                            child: CustomVideoPlayer(
                              videoURL: widget.video.videoUrl,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: SizedBox(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            bottomSheet: CustomBottomCard(
                  // maximumHeight: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ButtonIcon(
                    localImage: "${Common.assetsIcons}indicator_slider.png",
                    width: 50.0,
                  ),
                  const SizedBox(height: 8.0),
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        LargePrimaryBoldText(
                          value: tr(LocaleKeys.share_with),
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(height: 5.0),
                        CheckboxListTile(
                          value: _followersCheckbox,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10.0),
                          checkColor: AppColors.whiteColor,
                          activeColor: Colors.green,
                          title: Text(tr(LocaleKeys.followers)),
                          onChanged: (value) {
                            setState(() {
                              _followersCheckbox = value;
                            });
                          },
                        ),
                        // const SizedBox(height: 15.0),
                        CheckboxListTile(
                          value: _contactsCheckbox,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10.0),
                          checkColor: AppColors.whiteColor,
                          activeColor: Colors.green,
                          title: Text(tr(LocaleKeys.contacts)),
                          onChanged: (value) {
                            setState(() {
                              _contactsCheckbox = value;
                            });
                          },
                        ),
                        const SizedBox(height: 40.0),
                        PrimaryButton(
                          value: tr(LocaleKeys.done),
                          onPressed: () => _processShareVideo(),
                        ),
                        const SizedBox(height: 5.0),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          isLoading
              ? Positioned.fill(
                  child: Container(
                    color: AppColors.blackColor.withOpacity(0.25),
                  ),
                )
              : const SizedBox.shrink(),
          isLoading
              ? Positioned.fill(
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  void _processShareVideo() async {
    // check to whom video needs to be shared
    if (!_followersCheckbox && !_contactsCheckbox) {
      Common.showSnackBar(tr(LocaleKeys.share_selection),
          tr(LocaleKeys.please_select_at_least_one_option_to_share_the_video));
      return;
    }
    if (_currentUser == null) {
      Common.showSnackBar(tr(LocaleKeys.please_wait),
          tr(LocaleKeys.please_retry_in_five_seconds));
      _getCurrentUser();
      return;
    }
    setState(() {
      FocusScope.of(context).unfocus();
      isLoading = true;
    });

    // catch errors and manage routes
    if (_followersCheckbox) {
      // if followers
      await ApiRequests.shareVideoWithFollowers(
        widget.video.videoId,
        _currentUser.userID,
        widget.video.videoUrl,
        widget.video.thumbnailURL,
        widget.video.caption,
      ).then((value) {}).onError((error, stackTrace) {
        setState(() {
          isLoading = false;
          Common.showOnePrimaryButtonDialog(
            context: context,
            dialogMessage: error.toString(),
            primaryButtonText: tr(LocaleKeys.okay),
            primaryButtonOnPressed: () =>
                Get.offAndToNamed(AppRoutes.homeRoute),
          );
        });
      });
    }
    if (_contactsCheckbox) {
      setState(() {
        isLoading = false;
      });

      Get.offAndToNamed(AppRoutes.homeRoute);
      Get.to(() => ContactsShare(videoTitle: widget.video.caption));
      return;
    }

    setState(() {
      isLoading = false;
    });

    //move intent accordingly
    Get.offAndToNamed(AppRoutes.homeRoute);
  }

  void _getCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    _currentUser = await ApiRequests.getUser(user.uid);
    setState(() {});
  }
}
