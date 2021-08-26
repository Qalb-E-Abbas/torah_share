import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:torah_share/modals/modals_exporter.dart';
import 'package:torah_share/screens/routes/routes_exporter.dart';
import 'package:torah_share/translations/locale_keys.g.dart';
import 'package:torah_share/utils/util_exporter.dart';
import 'package:torah_share/utils/widgets/widgets_exporter.dart';

class CurrentUserProfile extends StatefulWidget {

  @override
  _CurrentUserProfileState createState() => _CurrentUserProfileState();
}

class _CurrentUserProfileState extends State<CurrentUserProfile> {
  bool _isUILoading = true, _approvalRequestSent = false;
  UserModal _currentUser;
  String address, _videoURL;

  @override
  void initState() {
    _getUserLocation();
    _getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isUILoading
        ? LoadingCurrentProfileUI()
        : Container(
            padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
            child: ListView(
              shrinkWrap: true,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ExtraLargeExtraBoldPrimaryText(
                        value: tr(LocaleKeys.profile)),
                    ButtonIcon(
                      localImage: "${Common.assetsIcons}setting.png",
                      onPressed: () => Get.toNamed(AppRoutes.settingsRoute),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Row(
                  children: [
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection(Common.followersCollection)
                          .where('following_id', isEqualTo: _currentUser.userID)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        if (!snapshot.hasData) return const SizedBox();
                        return MainProfileSquareImage(
                          imageURL: _currentUser.profileImageUrl,
                          followersCount: snapshot.data.docs.length,
                          onPressed: () => _processUpload(),
                        );
                      },
                    ),
                    const SizedBox(width: 10.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            LargePrimaryBoldText(
                              value: _currentUser.username,
                              textAlign: TextAlign.start,
                            ),

                            const SizedBox(width: 5,),

                            _currentUser.isProfileVerified
                                ? ButtonIcon(
                                localImage:
                                "${Common.assetsIcons}verified.png")
                                : const SizedBox.shrink(),
                          ],
                        ),

                        const SizedBox(height: 5.0),

                        MediumBrightPrimaryText(
                          value: "@${_currentUser.username.toLowerCase()}",
                        ),


                        _currentUser.aboutMe.isNotEmpty
                            ? const SizedBox(height: 5.0)
                            : const SizedBox.shrink(),

                        // Text(
                        //   "${_currentUser.aboutMe}",
                        //   style: Styles.smallLightTS(),
                        //   textAlign: TextAlign.start,
                        // ),

                        SizedBox(height: 6,),


                        LeadingIconTrailingText(
                          text: address ?? "Sydney, Australia",
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 15.0),
                UserStatBar(userID: _currentUser.userID),
                const SizedBox(height: 20.0),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection(Common.videosCollection)
                      .where("uploader_id", isEqualTo: _currentUser.userID)
                      .orderBy("created_on")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return VideoProfileListLoading();
                    }
                    if (snapshot.data.docs.length == 0) {
                      return Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 75.0),
                            LottieBuilder.asset(
                              Common.assetsAnimations + "no_result.json",
                              repeat: false,
                              height: 100.0,
                            ),
                            const SizedBox(height: 15.0),
                            Text(
                              tr(LocaleKeys.you_havent_uploaded_video_yet),
                              style: TextStyle(
                                fontSize: 19.0,
                                color: AppColors.blackColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 2.0),
                            InkWell(
                              onTap: () => ApiRequests.videoUploadOptions(
                                _currentUser.isProfileVerified,
                                _approvalRequestSent,
                                _videoURL,
                              ),
                              child: Text(
                                tr(LocaleKeys.upload_now),
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return Align(
                      alignment: Alignment.topCenter,
                      child: ListView.builder(
                        shrinkWrap: true,
                        reverse: true,
                        itemCount: snapshot.data.docs.length,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          DocumentSnapshot videoDocument =
                              snapshot.data.docs[index];
                          Video video = Video.fromJson(videoDocument.data());
                          return VideoPostCard(video: video);
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          );
  }

  void _getCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    ApiRequests.getUser(user.uid).then((value) async {
      _currentUser = value;
      final approval =
          await ApiRequests.isApprovalRequestSent(_currentUser.userID);

      _approvalRequestSent = approval.pendingApproval;
      if (approval.pendingApproval) {
        _videoURL = approval.videos.first;
      }
      _isUILoading = false;
      if (mounted) setState(() {});
    }).onError((error, stackTrace) {
      if (mounted)
        setState(() {
          _isUILoading = false;
        });

      Common.showOnePrimaryButtonDialog(
        context: context,
        dialogMessage: error.toString(),
        primaryButtonOnPressed: () => Get.offAllNamed(AppRoutes.loginRoute),
      );
    });
  }

  void _getUserLocation() async {
    Common.askLocationPermission(context).then((value) {
      if (value) {
        Geolocator.getCurrentPosition().then((currentUserLocation) async {
          final addr = await GeocodingPlatform.instance
              .placemarkFromCoordinates(
                  currentUserLocation.latitude, currentUserLocation.longitude)
              .onError((error, stackTrace) {
            _getUserLocation();
            return;
          });
          if (addr != null) if (mounted) if (mounted)
            setState(() {
              address = "${addr.first.locality}, ${addr.first.country}";
            });
          return;
        });
      } else {
        if (mounted)
          setState(() {
            _isUILoading = false;
          });
        return;
      }
    });
  }

  void _processUpload() async {
    setState(() {
      _isUILoading = true;
    });
    ApiRequests.uploadProfileImage(_currentUser.userID).then((value) {
      _getCurrentUser();
    }).onError((error, stackTrace) {
      setState(() {
        _isUILoading = false;
      });

      Common.showOnePrimaryButtonDialog(
        context: context,
        dialogMessage: error.toString(),
      );
    });
  }
}

class LoadingCurrentProfileUI extends StatelessWidget {
  const LoadingCurrentProfileUI({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
      child: ListView(
        shrinkWrap: true,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ExtraLargeExtraBoldPrimaryText(value: tr(LocaleKeys.profile)),
              ButtonIcon(
                localImage: "${Common.assetsIcons}setting.png",
                onPressed: () => Get.toNamed(AppRoutes.settingsRoute),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Row(
            children: [
              Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      LoadingHolder(
                        child: Container(
                          color: AppColors.backgroundColor,
                        ),
                      ),
                    ],
                  ),
                ),
                width: 100.0,
                height: 100.0,
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: LoadingHolder(
                            child: Container(
                              color: Colors.white,
                              height: 18.0,
                            ),
                          ),
                        ),
                        const SizedBox(width: 5.0),
                        ButtonIcon(
                            localImage: "${Common.assetsIcons}verified.png"),
                      ],
                    ),
                    const SizedBox(height: 6.0),
                    LoadingHolder(
                      child: Container(
                        color: Colors.white,
                        height: 20.0,
                        width: 150.0,
                      ),
                    ),
                    const SizedBox(height: 2),
                    LoadingHolder(
                      child: Container(
                        color: Colors.white,
                        height: 20.0,
                        width: 80.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15.0),
          PrimaryCard(
            verticalPadding: 15.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      LoadingHolder(
                        child: Container(
                          height: 25.0,
                          width: 16.0,
                          color: Colors.white,
                        ),
                      ),
                      SmallLessPrimaryText(value: tr(LocaleKeys.followers)),
                    ],
                  ),
                  Column(
                    children: [
                      LoadingHolder(
                        child: Container(
                          height: 25.0,
                          width: 16.0,
                          color: Colors.white,
                        ),
                      ),
                      SmallLessPrimaryText(value: tr(LocaleKeys.following)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15.0),
          VideoProfileListLoading(),
        ],
      ),
    );
  }
}
