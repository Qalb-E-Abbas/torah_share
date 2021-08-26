import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:torah_share/screens/views_exporter.dart';
import 'package:torah_share/translations/locale_keys.g.dart';
import 'package:torah_share/utils/common.dart';

import '../widgets/widgets_exporter.dart';

class UserStatBar extends StatelessWidget {
  final String userID;
  final bool isCurrentUserStats;

  const UserStatBar({
    Key key,
    @required this.userID,
    this.isCurrentUserStats = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PrimaryCard(
      verticalPadding: 15.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection(Common.followersCollection)
                      .where('following_id', isEqualTo: userID)
                      .snapshots(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasData) {
                      return InkWell(
                        onTap: () => snapshot.data.docs.length == 0
                            ? null
                            : isCurrentUserStats
                                ? Get.to(
                                    () => Followers(
                                      parentUserID: userID,
                                    ),
                                  )
                                : null,
                        child: LargePrimaryBoldText(
                            value: snapshot.data.docs.length.toString()),
                      );
                    }
                    return LoadingHolder(
                      child: Container(
                        height: 25.0,
                        width: 16.0,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
                SmallLessPrimaryText(value: tr(LocaleKeys.followers)),
              ],
            ),
            Column(
              children: [
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection(Common.followersCollection)
                      .where("follower_id", isEqualTo: userID)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return InkWell(
                        onTap: () => snapshot.data.docs.length == 0
                            ? null
                            : isCurrentUserStats
                                ? Get.to(
                                    () => Followings(
                                      parentUserID: userID,
                                    ),
                                  )
                                : null,
                        child: LargePrimaryBoldText(
                            value: snapshot.data.docs.length.toString()),
                      );
                    }
                    return LoadingHolder(
                      child: Container(
                        height: 25.0,
                        width: 16.0,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
                SmallLessPrimaryText(value: tr(LocaleKeys.following)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
