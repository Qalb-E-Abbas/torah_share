import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:torah_share/modals/modals_exporter.dart';
import 'package:torah_share/translations/locale_keys.g.dart';
import 'package:torah_share/utils/util_exporter.dart';
import 'package:torah_share/utils/widgets/widgets_exporter.dart';

class Inbox extends StatefulWidget {
  final String otherUserID, inboxID;

  const Inbox({
    Key key,
    @required this.otherUserID,
    @required this.inboxID,
  }) : super(key: key);

  @override
  _InboxState createState() => _InboxState();
}

class _InboxState extends State<Inbox> {
  TextEditingController _messageController = new TextEditingController();
  bool _isLoading = true, _isLoadedFirstTime = true;
  UserModal _currentUser, _otherUser;
  ScrollController _listController = ScrollController();

  @override
  void initState() {
    _getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        child: Stack(
          children: [
            SafeArea(
              child: Container(
                padding: const EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 2.5),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BackIcon(
                          iconColor: AppColors.primary,
                          onPressed: () => navigator.pop(),
                        ),
                        ExtraLargeExtraBoldPrimaryText(
                            value: tr(LocaleKeys.shares)),
                        const SizedBox(),
                      ],
                    ),
                    const SizedBox(height: 12.0),
                    PrimaryCard(
                      verticalPadding: 12.0,
                      child: Row(
                        children: [
                          Stack(
                            children: [
                              _otherUser == null
                                  ? LoadingHolder(
                                      child: Container(
                                        width: 40.0,
                                        height: 40.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  : SmallCircleAvatar(
                                      radius: 20.0,
                                      userImage: _otherUser.profileImageUrl,
                                    ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: _otherUser == null
                                    ? const SizedBox.shrink()
                                    : StreamBuilder(
                                        stream: FirebaseFirestore.instance
                                            .collection(
                                                Common.followersCollection)
                                            .where('following_id',
                                                isEqualTo: _otherUser.userID)
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData)
                                            return const SizedBox.shrink();
                                          return Container(
                                            height: 16,
                                            width: 16,
                                            child: LevelBadge(
                                              followersCount:
                                                  snapshot.data.docs.length,
                                            ),
                                          );
                                        },
                                      ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 10.0),
                          _otherUser == null
                              ? LoadingHolder(
                                  child: Container(
                                    color: Colors.white,
                                    width: 200.0,
                                    height: 16.0,
                                  ),
                                )
                              : MediumPrimaryBoldText(
                                  value: _otherUser.username,
                                  textAlign: TextAlign.start,
                                ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Expanded(
                      child: _currentUser == null
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: 4,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return ChatLoadingVideoCard(
                                  isMe: index % 2 == 0,
                                );
                              },
                            )
                          : StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection(Common.inboxCollection)
                                  .doc(widget.inboxID)
                                  .collection(Common.sharesCollection)
                                  .orderBy("created_on")
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<dynamic> snapshot) {
                                if (!snapshot.hasData) return SizedBox();
                                return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data.docs.length,
                                  itemBuilder: (context, index) {
                                    DocumentSnapshot sharesDocument =
                                        snapshot.data.docs[index];
                                    Shares shares = new Shares.fromJson(
                                        sharesDocument.data());
                                    return shares.isVideo
                                        ? FutureBuilder(
                                            future: ApiRequests.getVideo(
                                                shares.videoID),
                                            builder: (context, snapshot) {
                                              if (!snapshot.hasData)
                                                return const SizedBox();
                                              Video video = Video.fromJson(
                                                  snapshot.data.toJson());
                                              return ChatVideoCard(
                                                isMe: shares.senderId ==
                                                    _currentUser.userID,
                                                video: video,
                                                userImageURL: shares.senderId ==
                                                        _currentUser.userID
                                                    ? _currentUser
                                                        .profileImageUrl
                                                    : _otherUser
                                                        .profileImageUrl,
                                                otherUser: _otherUser,
                                                currentUser: _currentUser,
                                              );
                                            },
                                          )
                                        : ChatCard(
                                            isMe: shares.senderId ==
                                                _currentUser.userID,
                                            message: shares.message,
                                            userImageURL: shares.senderId ==
                                                    _currentUser.userID
                                                ? _currentUser.profileImageUrl
                                                : _otherUser.profileImageUrl,
                                          );
                                  },
                                );
                              },
                            ),
                    ),
                    _otherUser != null
                        ? _otherUser.takeInboxMessages
                            ? PrimaryCard(
                                verticalPadding: 5.0,
                                horizontalPadding: 5.0,
                                child: Row(
                                  children: [
                                    const SizedBox(width: 10.0),
                                    Expanded(
                                      child: TextFormField(
                                        controller: _messageController,
                                        decoration: InputDecoration.collapsed(
                                          hintText: tr(LocaleKeys.type_message),
                                        ),
                                      ),
                                    ),
                                    CustomBorderCard(
                                      onPressed: () => _processSendMessage(),
                                      cardPadding: const EdgeInsets.symmetric(
                                          vertical: 15.0, horizontal: 15.0),
                                      color: AppColors.primary,
                                      child: Image.asset(
                                        Common.assetsIcons + "send.png",
                                        width: 25.0,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Column(
                                children: [
                                  Text(
                                    tr(LocaleKeys.cannot_reply_conversation),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 10.0),
                                ],
                              )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getUsers() async {
    final user = FirebaseAuth.instance.currentUser;
    _currentUser = await ApiRequests.getUser(user.uid);
    _otherUser = await ApiRequests.getUser(widget.otherUserID);
    _isLoading = false;
    setState(() {});
  }

  void _processSendMessage() async {
    // check if message is written or not
    if (_messageController == null || _messageController.text.isEmpty) return;
    // take chat id
    // update inbox collection last activity at and last message with last video:false
    await ApiRequests.updateInbox(
        widget.inboxID, _messageController.text.trim(), false);
    // make share with message is video false
    String _shareID = await ApiRequests.messageShare(
        _messageController.text.trim(), _currentUser.userID, widget.inboxID);
    // add shared with of both users
    List<String> _participants = [];
    _participants.add(_currentUser.userID);
    _participants.add(_otherUser.userID);
    _messageController.clear();
  }
}
