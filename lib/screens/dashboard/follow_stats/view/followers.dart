import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:torah_share/modals/modals_exporter.dart';
import 'package:torah_share/translations/locale_keys.g.dart';
import 'package:torah_share/utils/util_exporter.dart';
import 'package:torah_share/utils/widgets/widgets_exporter.dart';

class Followers extends StatefulWidget {
  final String parentUserID;

  const Followers({
    Key key,
    @required this.parentUserID,
  }) : super(key: key);

  @override
  _FollowersState createState() => _FollowersState();
}

class _FollowersState extends State<Followers> {
  UserModal _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    _getUsers();
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
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 20.0),
                    child: CustomAppBar(
                      textChild:
                          LargeWhiteBoldText(value: tr(LocaleKeys.followers)),
                      willPop: true,
                      hasIconAndTextWhiteTheme: true,
                      includeOptionButton: false,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                      ),
                      child: _isLoading
                          ? FollowerFollowingUsersListLoading()
                          : StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection(Common.followersCollection)
                                  .where("following_id",
                                      isEqualTo: widget.parentUserID)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData)
                                  return FollowerFollowingUsersLoader();
                                return ListView.builder(
                                  itemCount: snapshot.data.docs.length,
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    DocumentSnapshot followers =
                                        snapshot.data.docs[index];
                                    Follower follower =
                                        Follower.fromJson(followers.data());
                                    return UserCard(
                                      userID: follower.followerId,
                                    );
                                  },
                                );
                              },
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _getUsers() async {
    final user = FirebaseAuth.instance.currentUser;
    _currentUser = await ApiRequests.getUser(user.uid);
    _isLoading = false;
    setState(() {});
  }
}
