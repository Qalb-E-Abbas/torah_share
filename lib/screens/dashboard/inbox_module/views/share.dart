import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:timeago/timeago.dart' as timeAgo;
import 'package:torah_share/modals/modals_exporter.dart';
import 'package:torah_share/screens/views_exporter.dart';
import 'package:torah_share/translations/locale_keys.g.dart';
import 'package:torah_share/utils/util_exporter.dart';
import 'package:torah_share/utils/widgets/widgets_exporter.dart';

class Share extends StatefulWidget {
  @override
  _ShareState createState() => _ShareState();
}

class _ShareState extends State<Share> {
  bool _isLoading = true;
  UserModal _currentUser;

  @override
  void initState() {
    _getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [

          SizedBox(height: 10,),

          Row(
            children: [

              IconButton(onPressed: (){}, icon: Icon(FontAwesomeIcons.arrowLeft)),


               SizedBox(width: MediaQuery.of(context).size.width * 0.27 ,),

              ExtraLargeExtraBoldPrimaryText(value: tr(LocaleKeys.shares)),

            ],
          ),

          const SizedBox(height: 10,),

          _isLoading
              ? SharesNotificationListLoading()
              : Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collectionGroup(Common.participantsCollection)
                        .where("user_id", isEqualTo: _currentUser.userID)
                        .orderBy("created_on")
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (!snapshot.hasData) return Container();
                      if (snapshot.data.docs.length == 0) {
                        return Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              LottieBuilder.asset(
                                Common.assetsAnimations + "no_result.json",
                                repeat: false,
                                height: 80.0,
                              ),
                              const SizedBox(height: 20.0),
                              Text(
                                tr(LocaleKeys.no_shares),
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                tr(LocaleKeys
                                    .keep_exploring_TorahShare_shares_will_arrive_here),
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: AppColors.blackColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.docs.length,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          DocumentSnapshot sharesDocument =
                              snapshot.data.docs[index];
                          Participants participants =
                              new Participants.fromJson(sharesDocument.data());
                          return FutureBuilder(
                            future:
                                ApiRequests.getUser(participants.otherUserId),
                            builder: (BuildContext context,
                                AsyncSnapshot<dynamic> snapshot) {
                              if (!snapshot.hasData)
                                return SharesNotificationLoader();
                              UserModal otherUser = new UserModal.fromJson(
                                  snapshot.data.toJson());
                              return InboxCard(
                                inboxID: participants.inboxId,
                                otherUser: otherUser,
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }

  void _getCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    _currentUser = await ApiRequests.getUser(user.uid);
    _isLoading = false;
    setState(() {});
  }
}

class SelfNotificationCard extends StatefulWidget {
  final Notifications notifications;
  const SelfNotificationCard({
    Key key,
    @required this.notifications,
  }) : super(key: key);

  @override
  _SelfNotificationCardState createState() => _SelfNotificationCardState();
}

class _SelfNotificationCardState extends State<SelfNotificationCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: !widget.notifications.isRead
          ? () => _processContactNotification()
          : null,
      child: Container(
        decoration: BoxDecoration(
          color: widget.notifications.isRead
              ? AppColors.backgroundColor
              : AppColors.whiteColor,
        ),
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 29,
              backgroundColor: AppColors.primary,
              child: Text(
                widget.notifications.contactName[0],
                style: TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: 22.0,
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              flex: 4,
              child: RichText(
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                text: TextSpan(
                  style: Styles.smallBrightPrimaryRegularTS(),
                  text: widget.notifications.message,
                  children: [
                    TextSpan(
                      text: " \"${widget.notifications.contactName}\"",
                      style: Styles.mediumPrimaryBoldTS(),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: SmallBrightPrimaryText(
                value: timeAgo.format(
                  DateTime.fromMillisecondsSinceEpoch(
                    widget.notifications.createdOn.toInt(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _processContactNotification() async {
    // make share read = true
    if (!widget.notifications.isRead)
      await ApiRequests.makeShareNotificationIsRead(
          widget.notifications.notificationId);
  }
}

class NotificationCard extends StatefulWidget {
  final bool isNotificationRead;
  final String title, subTitle, time, senderID, notificationID, inboxID;

  const NotificationCard({
    Key key,
    @required this.notificationID,
    @required this.isNotificationRead,
    @required this.title,
    @required this.subTitle,
    @required this.time,
    @required this.senderID,
    @required this.inboxID,
  }) : super(key: key);
  @override
  _NotificationCardState createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  UserModal _senderUserModal, _currentUserModal;
  bool openingChat = false;

  @override
  void initState() {
    _getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: openingChat ? null : () => _processShareToInbox(),
      child: Container(
        decoration: BoxDecoration(
          color: widget.isNotificationRead
              ? AppColors.backgroundColor
              : AppColors.whiteColor,
        ),
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
        child: Row(
          children: [
            Stack(
              children: [
                _senderUserModal == null
                    ? LoadingHolder(
                        child: Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : SmallCircleAvatar(
                        radius: 30.0,
                        userImage: _senderUserModal.profileImageUrl,
                      ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: _currentUserModal == null
                      ? const SizedBox.shrink()
                      : StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection(Common.followersCollection)
                              .where('following_id',
                                  isEqualTo: _currentUserModal.userID)
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
                              height: 22.0,
                              width: 22.0,
                              child: LevelBadge(
                                followersCount: snapshot.data.docs.length,
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
            const SizedBox(width: 8.0),
            Expanded(
              flex: 4,
              child: RichText(
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                text: TextSpan(
                  style: Styles.mediumPrimaryBoldTS(),
                  text: widget.title,
                  children: [
                    TextSpan(
                      text: " " + widget.subTitle,
                      style: Styles.smallBrightPrimaryRegularTS(),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: SmallBrightPrimaryText(
                value: widget.time,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getUser() async {
    final user = FirebaseAuth.instance.currentUser;

    _senderUserModal = await ApiRequests.getUser(widget.senderID);
    _currentUserModal = await ApiRequests.getUser(user.uid);
    if (mounted) setState(() {});
  }

  void _processShareToInbox() async {
    if (_currentUserModal == null) return;

    setState(() {
      openingChat = true;
    });
    // make share read = true
    if (!widget.isNotificationRead)
      await ApiRequests.makeShareNotificationIsRead(widget.notificationID);

    String inboxID;
    if (widget.inboxID == null || widget.inboxID.isEmpty) {
      // get chat id of 2 users
      inboxID = await ApiRequests.getInboxID(
          _currentUserModal.userID, _senderUserModal.userID);
    } else
      inboxID = widget.inboxID;

    setState(() {
      openingChat = false;
    });
    // take user to chat screen of these 2 users
    navigator.push(
      MaterialPageRoute(
        builder: (context) => Inbox(
          otherUserID: widget.senderID,
          inboxID: inboxID,
        ),
      ),
    );
  }
}

class InboxCard extends StatefulWidget {
  final String inboxID;
  final UserModal otherUser;

  const InboxCard({
    Key key,
    @required this.inboxID,
    @required this.otherUser,
  }) : super(key: key);
  @override
  _InboxCardState createState() => _InboxCardState();
}

class _InboxCardState extends State<InboxCard> {
  UserModal _currentUser;
  InboxModal _inbox;
  bool openingChat = false;

  @override
  void initState() {
    _getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: openingChat ? null : () => _processShareToInbox(),
      child: (_currentUser == null || _inbox == null)
          ? SharesNotificationLoader()
          : Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
              child: Row(
                children: [
                  Stack(
                    children: [
                      SmallCircleAvatar(
                        radius: 30.0,
                        userImage: widget.otherUser.profileImageUrl,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: _currentUser == null
                            ? const SizedBox.shrink()
                            : StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection(Common.followersCollection)
                                    .where('following_id',
                                        isEqualTo: _currentUser.userID)
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
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                        padding: const EdgeInsets.all(4.0),
                                      ),
                                    );
                                  return SizedBox(
                                    height: 22.0,
                                    width: 22.0,
                                    child: LevelBadge(
                                      followersCount: snapshot.data.docs.length,
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${widget.otherUser.username}",
                          style: Styles.mediumPrimaryBoldTS(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        const SizedBox(height: 2.5),
                        Row(
                          children: [
                            _inbox.isLastVideo
                                ? Icon(
                                    Icons.video_settings_sharp,
                                    size: 17.0,
                                    color: AppColors.brightPrimaryColor,
                                  )
                                : const SizedBox.shrink(),
                            _inbox.isLastVideo
                                ? const SizedBox(width: 5.0)
                                : const SizedBox.shrink(),
                            Expanded(
                              child: Text(
                                "${_inbox.lastMessage}",
                                style: Styles.smallBrightPrimaryRegularTS(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: SmallBrightPrimaryText(
                      value: timeAgo.format(
                        DateTime.fromMillisecondsSinceEpoch(
                          _inbox.lastActivityAt.toInt(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> _getUser() async {
    final user = FirebaseAuth.instance.currentUser;

    _currentUser = await ApiRequests.getUser(user.uid);
    _inbox = await ApiRequests.getInbox(widget.inboxID);
    if (mounted) setState(() {});
  }

  void _processShareToInbox() async {
    if (_currentUser == null) return;

    // take user to chat screen of these 2 users
    navigator.push(
      MaterialPageRoute(
        builder: (context) => Inbox(
          otherUserID: widget.otherUser.userID,
          inboxID: widget.inboxID,
        ),
      ),
    );
  }
}
