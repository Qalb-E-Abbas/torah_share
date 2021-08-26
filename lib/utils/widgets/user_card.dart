import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:torah_share/modals/modals_exporter.dart';
import 'package:torah_share/screens/views_exporter.dart';
import 'package:torah_share/translations/locale_keys.g.dart';
import 'package:torah_share/utils/util_exporter.dart';
import 'package:torah_share/utils/widgets/widgets_exporter.dart';

class UserCard extends StatefulWidget {
  final String userID;
  final Function onPressed;

  const UserCard({
    Key key,
    @required this.userID,
    this.onPressed,
  }) : super(key: key);

  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  bool _isLoading = true;
  UserModal _user, _currentUser;

  @override
  void initState() {
    _getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return FollowerFollowingUsersLoader();
    } else {
      return InkWell(
        onTap: widget.onPressed ??
            () => Get.to(
                  () => Home(
                    screens: [
                      OtherUserProfile(
                        userID: _user.userID,
                      ),
                      Share(),
                      CurrentUserProfile(),
                    ],
                    index: 0,
                  ),
                ),
        child: Container(
          padding: const EdgeInsets.all(6.0),
          margin: const EdgeInsets.only(bottom: 15.0),
          child: Row(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    SmallCircleAvatar(
                      userImage: _user.profileImageUrl,
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection(Common.followersCollection)
                            .where("following_id", isEqualTo: widget.userID)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            return LoadingHolder(
                              baseColor: Colors.grey[400],
                              child: Container(
                                height: 20.0,
                                width: 20.0,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                padding: const EdgeInsets.all(4.0),
                              ),
                            );
                          return SizedBox(
                            width: 20.0,
                            height: 20.0,
                            child: LevelBadge(
                              followersCount: snapshot.data.docs.length,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 5.0),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LargePrimaryBoldText(
                      value: _user.username,
                      textAlign: TextAlign.start,
                    ),
                    SmallBrightPrimaryText(
                      value: "@${_user.username.toLowerCase()}",
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 2.5),
              Expanded(
                flex: 2,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection(Common.followersCollection)
                      .where('follower_id', isEqualTo: _currentUser.userID)
                      .where('following_id', isEqualTo: _user.userID)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const SizedBox();
                    return snapshot.data.docs.length == 1
                        ? PrimaryButton(
                            value: tr(LocaleKeys.un_follow),
                            padding: const EdgeInsets.symmetric(
                              vertical: 6.0,
                            ),
                            onPressed: () => ApiRequests.unFollowUser(
                              _currentUser.userID,
                              _user.userID,
                            ),
                          )
                        : OutlinePrimaryButton(
                            value: tr(LocaleKeys.follow),
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                            ),
                            onPressed: () => ApiRequests.followUser(
                              _currentUser.userID,
                              _user.userID,
                            ),
                          );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Future<void> _getUser() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    _currentUser = await ApiRequests.getUser(currentUser.uid);
    _user = await ApiRequests.getUser(widget.userID);
    _isLoading = false;
    setState(() {});
  }
}
