import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:torah_share/modals/modals_exporter.dart';
import 'package:torah_share/translations/locale_keys.g.dart';

import '../../../../utils/util_exporter.dart';
import '../../../../utils/widgets/text/medium_primary_bold_text.dart';
import '../../../../utils/widgets/widgets_exporter.dart';

class Comment extends StatefulWidget {
  final Video video;
  const Comment({
    Key key,
    @required this.video,
  }) : super(key: key);

  @override
  _CommentState createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  TextEditingController _commentController = new TextEditingController();
  bool _isLoading = true, _isSubComment = false;
  String _mainCommentID = "", _mainCommenterName = "";
  UserModal _currentUser, _videoOwnerUser;

  @override
  void initState() {
    _getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          _isLoading
              ? Scaffold(
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        color: AppColors.blackColor.withOpacity(0.25),
                      ),
                      Center(
                        child: CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(
                              AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                )
              : Scaffold(
                  backgroundColor: AppColors.backgroundColor.withOpacity(0.5),
                  bottomSheet: CustomBottomCard(
                    maximumHeight: MediaQuery.of(context).size.height * 0.9,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ButtonIcon(
                          localImage:
                              "${Common.assetsIcons}indicator_slider.png",
                          width: 50.0,
                        ),
                        const SizedBox(height: 10.0),
                        LargePrimaryBoldText(
                          value: tr(LocaleKeys.comment),
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(height: 30.0),
                        Expanded(
                          child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection(Common.commentsCollection)
                                .where("video_id",
                                    isEqualTo: widget.video.videoId)
                                .orderBy("created_on")
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData)
                                return Center(
                                  child: CircularProgressIndicator(
                                    valueColor:
                                        new AlwaysStoppedAnimation<Color>(
                                            AppColors.primary),
                                  ),
                                );
                              if (snapshot.data.docs.length == 0) {
                                return Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      LottieBuilder.asset(
                                        Common.assetsAnimations +
                                            "no_result.json",
                                        repeat: false,
                                        height: 80.0,
                                      ),
                                      const SizedBox(height: 20.0),
                                      Text(
                                        tr(LocaleKeys.no_comments),
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 4.0),
                                      Text(
                                        tr(LocaleKeys.be_first_to_comment),
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
                                  DocumentSnapshot commentsDocument =
                                      snapshot.data.docs[index];
                                  Comments comments = new Comments.fromJson(
                                      commentsDocument.data());
                                  return FutureBuilder(
                                    future: ApiRequests.getUser(
                                        comments.commenterId),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<dynamic> snapshot) {
                                      if (!snapshot.hasData)
                                        return const SizedBox();
                                      UserModal commenter = UserModal.fromJson(
                                          snapshot.data.toJson());
                                      return Column(
                                        children: [
                                          Row(
                                            children: [
                                              SmallCircleAvatar(
                                                radius: 20.0,
                                                userImage:
                                                    commenter.profileImageUrl,
                                              ),
                                              const SizedBox(width: 15.0),
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .stretch,
                                                        children: [
                                                          MediumPrimaryBoldText(
                                                            value: commenter
                                                                .username,
                                                            textAlign:
                                                                TextAlign.start,
                                                          ),
                                                          Text(
                                                            comments.message,
                                                            style: TextStyle(
                                                              color: AppColors
                                                                  .brightPrimaryColor,
                                                              fontSize: 15.0,
                                                              fontFamily:
                                                                  'NunitoSans-Regular',
                                                            ),
                                                            textAlign:
                                                                TextAlign.start,
                                                          ),
                                                          const SizedBox(
                                                              height: 15.0),
                                                        ],
                                                      ),
                                                    ),
                                                    (_videoOwnerUser.userID ==
                                                            _currentUser.userID)
                                                        ? InkWell(
                                                            onTap: () =>
                                                                _processSubComment(
                                                              comments.id,
                                                              commenter
                                                                  .username,
                                                            ),
                                                            child: Icon(
                                                              FontAwesomeIcons
                                                                  .reply,
                                                              size: 18.0,
                                                            ),
                                                          )
                                                        : const SizedBox
                                                            .shrink(),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 5.0),
                                          StreamBuilder(
                                            stream: FirebaseFirestore.instance
                                                .collection(
                                                    Common.commentsCollection)
                                                .doc(comments.id)
                                                .collection(Common
                                                    .subCommentsCollection)
                                                .orderBy("created_on")
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (!snapshot.hasData)
                                                return const SizedBox.shrink();
                                              if (snapshot.data.docs.length ==
                                                  0)
                                                return const SizedBox.shrink();
                                              return ListView.builder(
                                                itemCount:
                                                    snapshot.data.docs.length,
                                                shrinkWrap: true,
                                                physics:
                                                    BouncingScrollPhysics(),
                                                itemBuilder: (context, index) {
                                                  DocumentSnapshot
                                                      subCommentsDocument =
                                                      snapshot.data.docs[index];
                                                  SubComment subComment =
                                                      SubComment.fromJson(
                                                          subCommentsDocument
                                                              .data());
                                                  return FutureBuilder(
                                                    future: ApiRequests.getUser(
                                                        subComment.commenterId),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (!snapshot.hasData)
                                                        return const SizedBox
                                                            .shrink();
                                                      UserModal subCommenter =
                                                          UserModal.fromJson(
                                                              snapshot.data
                                                                  .toJson());
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          left: 50.0,
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            SmallCircleAvatar(
                                                              radius: 20.0,
                                                              userImage:
                                                                  subCommenter
                                                                      .profileImageUrl,
                                                            ),
                                                            const SizedBox(
                                                                width: 15.0),
                                                            Expanded(
                                                              child: Row(
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .stretch,
                                                                      children: [
                                                                        MediumPrimaryBoldText(
                                                                          value:
                                                                              subCommenter.username,
                                                                          textAlign:
                                                                              TextAlign.start,
                                                                        ),
                                                                        Text(
                                                                          "${subComment.message}",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                AppColors.brightPrimaryColor,
                                                                            fontSize:
                                                                                15.0,
                                                                            fontFamily:
                                                                                'NunitoSans-Regular',
                                                                          ),
                                                                          textAlign:
                                                                              TextAlign.start,
                                                                        ),
                                                                        const SizedBox(
                                                                            height:
                                                                                15.0),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _isSubComment
                                  ? Card(
                                      color: AppColors.whiteColor,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0,
                                          vertical: 5.0,
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "$_mainCommenterName",
                                              style: TextStyle(
                                                color: AppColors.primary,
                                              ),
                                            ),
                                            const SizedBox(width: 10.0),
                                            InkWell(
                                              onTap: () =>
                                                  _unProcessSubComment(),
                                              child: Image.asset(
                                                Common.assetsIcons +
                                                    "close.png",
                                                width: 20.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                              PrimaryField(
                                keyboardType: TextInputType.text,
                                controller: _commentController,
                                hint: tr(LocaleKeys.type_comment_here),
                                backgroundColor: AppColors.whiteColor,
                                prefixIcon: Icon(
                                  FontAwesomeIcons.smile,
                                  color: AppColors.primary,
                                ),
                                suffixIcon: InkWell(
                                  onTap: () => _processComment(),
                                  child: Image.asset(
                                    Common.assetsIcons + "send_black.png",
                                    height: 5.0,
                                    width: 5.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5.0),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  void _processComment() async {
    // check if comment is not null and not empty
    if (_commentController == null || _commentController.text.trim().isEmpty)
      return;
    // take comment and add it to comments collection with video id and commenter details
    if (_isSubComment) {
      // make sub comment
      await ApiRequests.makeSubComment(
        _mainCommentID,
        _commentController.text.trim(),
        _currentUser.userID,
        widget.video.videoId,
      );
      _isSubComment = false;
      _mainCommentID = "";
      _mainCommenterName = "";
      setState(() {});
    } else {
      await ApiRequests.makeComment(
        widget.video.videoId,
        _commentController.text.trim(),
        _currentUser.userID,
        _currentUser.username,
        _currentUser.profileImageUrl,
      );
    }
    _commentController.clear();
  }

  void _getUser() async {
    final user = FirebaseAuth.instance.currentUser;
    _currentUser = await ApiRequests.getUser(user.uid);
    _videoOwnerUser = await ApiRequests.getUser(widget.video.uploaderId);
    _isLoading = false;
    setState(() {});
  }

  void _processSubComment(String commentID, String mainCommenterName) {
    setState(() {
      _isSubComment = true;
      _mainCommentID = commentID;
      _mainCommenterName = mainCommenterName;
    });
    FocusScope.of(context).nextFocus();
  }

  void _unProcessSubComment() {
    setState(() {
      _isSubComment = false;
      _mainCommentID = "";
      _mainCommenterName = "";
    });
    FocusScope.of(context).unfocus();
  }
}
