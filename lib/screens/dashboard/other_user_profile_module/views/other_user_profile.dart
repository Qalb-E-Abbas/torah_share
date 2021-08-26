import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:torah_share/modals/modals_exporter.dart';
import 'package:torah_share/translations/locale_keys.g.dart';
import 'package:torah_share/utils/util_exporter.dart';
import 'package:torah_share/utils/widgets/widgets_exporter.dart';

class OtherUserProfile extends StatefulWidget {
  final String userID;

  const OtherUserProfile({
    Key key,
    @required this.userID,
  }) : super(key: key);
  @override
  _OtherUserProfileState createState() => _OtherUserProfileState();
}

class _OtherUserProfileState extends State<OtherUserProfile> {
  bool _isLoading = true, _isVideoLoading = false;
  UserModal _searchedUser, _currentUser;

  @override
  void initState() {
    _getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? LoadingOtherUserProfileUI()
        : Container(
            padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
            child: ListView(
              shrinkWrap: true,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BackIcon(
                      iconColor: AppColors.primary,
                      onPressed: () => navigator.pop(),
                    ),
                    ExtraLargeExtraBoldPrimaryText(
                        value: tr(LocaleKeys.profile)),
                    const SizedBox.shrink(),
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection(Common.followersCollection)
                          .where('following_id', isEqualTo: widget.userID)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return const SizedBox();
                        return MainProfileSquareImage(
                          imageURL: _searchedUser.profileImageUrl,
                          followersCount: snapshot.data.docs.length,
                        );
                      },
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: LargePrimaryBoldText(
                                  value: _searchedUser.username,
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              const SizedBox(width: 5.0),
                              _searchedUser.isProfileVerified
                                  ? ButtonIcon(
                                      localImage:
                                          "${Common.assetsIcons}verified.png",
                                    )
                                  : const SizedBox.shrink(),
                            ],
                          ),
                          const SizedBox(height: 2.5),
                          MediumBrightPrimaryText(
                            value: "@${_searchedUser.username.toLowerCase()}",
                          ),
                          _searchedUser.aboutMe.isNotEmpty
                              ? const SizedBox(height: 2.5)
                              : const SizedBox.shrink(),
                          MediumBrightPrimaryText(
                            value: "${_searchedUser.aboutMe}",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15.0),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection(Common.followersCollection)
                      .where('follower_id', isEqualTo: _currentUser.userID)
                      .where('following_id', isEqualTo: _searchedUser.userID)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const SizedBox();
                    return snapshot.data.docs.length == 1
                        ? PrimaryButton(
                            value: tr(LocaleKeys.following),
                            onPressed: () => ApiRequests.unFollowUser(
                                _currentUser.userID, _searchedUser.userID),
                          )
                        : OutlinePrimaryButton(
                            value: tr(LocaleKeys.follow),
                            onPressed: () => ApiRequests.followUser(
                                _currentUser.userID, _searchedUser.userID),
                          );
                  },
                ),
                const SizedBox(height: 20.0),
                UserStatBar(
                  userID: _searchedUser.userID,
                  isCurrentUserStats: false,
                ),
                const SizedBox(height: 15.0),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: LargePrimaryBoldText(
                    value: tr(LocaleKeys.videos),
                  ),
                ),
                const SizedBox(height: 15.0),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection(Common.videosCollection)
                      .where("uploader_id", isEqualTo: widget.userID)
                      .orderBy("created_on")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(
                              AppColors.primary),
                        ),
                      );
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
                              tr(LocaleKeys.user_has_not_uploaded_an_video_yet),
                              style: TextStyle(
                                fontSize: 19.0,
                                color: AppColors.blackColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }
                    return GridView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.docs.length,
                      physics: BouncingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        DocumentSnapshot videoDocument =
                            snapshot.data.docs[index];
                        Video video = Video.fromJson(videoDocument.data());
                        return _isVideoLoading
                            ? LoadingHolder(
                                child: Container(
                                  color: Colors.white,
                                ),
                              )
                            : ThumbnailHolder(
                                url: video.thumbnailURL,
                                videoURL: video.videoUrl,
                                fillPositioned: true,
                                onPressed: () =>
                                    _processVideoLoading(video.videoUrl),
                              );
                      },
                    );
                  },
                ),
              ],
            ),
          );
  }

  void _processVideoLoading(String videoURL) async {
    setState(() {
      _isVideoLoading = true;
    });
    await Common.openAdAndFullViewVideo(videoURL);
    setState(() {
      _isVideoLoading = false;
    });
  }

  void _getUser() async {
    final user = FirebaseAuth.instance.currentUser;
    _searchedUser = await ApiRequests.getUser(widget.userID);
    _currentUser = await ApiRequests.getUser(user.uid);
    _isLoading = false;
    setState(() {});
  }
}

class LoadingOtherUserProfileUI extends StatelessWidget {
  const LoadingOtherUserProfileUI({Key key}) : super(key: key);

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
          const SizedBox(height: 20.0),
          LoadingHolder(
            child: Container(
              color: Colors.white,
              height: 60.0,
            ),
          ),
          const SizedBox(height: 20.0),
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
          VideoGridViewLoading(),
        ],
      ),
    );
  }
}
