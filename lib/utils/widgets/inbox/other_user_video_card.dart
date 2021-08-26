import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:torah_share/modals/modals_exporter.dart';
import 'package:torah_share/utils/util_exporter.dart';
import 'package:torah_share/utils/widgets/widgets_exporter.dart';

class OtherUserVideoCard extends StatefulWidget {
  final String userImageURL;
  final Video video;
  final UserModal currentUser, otherUser;
  final Function onPressed;

  const OtherUserVideoCard({
    Key key,
    @required this.video,
    @required this.userImageURL,
    @required this.currentUser,
    @required this.otherUser,
    this.onPressed,
  }) : super(key: key);

  @override
  _OtherUserVideoCardState createState() => _OtherUserVideoCardState();
}

class _OtherUserVideoCardState extends State<OtherUserVideoCard> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? ChatLoadingVideoCard(isMe: false)
        : Row(
            children: [
              Align(
                alignment: Alignment.bottomLeft,
                child: SmallCircleAvatar(
                  radius: 20.0,
                  userImage: widget.userImageURL,
                ),
              ),
              const SizedBox(width: 5.0),
              Expanded(
                flex: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SmallLessPrimaryText(
                      value: widget.video.caption,
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 10.0),
                    ThumbnailHolder(
                      url: widget.video.thumbnailURL,
                      videoURL: widget.video.videoUrl,
                      onPressed: () =>
                          _processVideoLoading(widget.video.videoUrl),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.topRight,
                  child: FutureBuilder(
                    future: ApiRequests.isUserFollowing(
                        widget.otherUser.userID, widget.currentUser.userID),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const SizedBox.shrink();
                      bool isFollowing = snapshot.data;
                      return PopupMenuButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        icon: Icon(
                          FontAwesomeIcons.ellipsisV,
                          size: 18.0,
                        ),
                        itemBuilder: (BuildContext context) {
                          // add check if user is following other user then show un follow
                          return (isFollowing
                                  ? otherUserAndFollowingVideoPopupMenuItemList
                                  : otherUserVideoPopupMenuItemList)
                              .map((VideoPopupMenuItem videoPopupMenuItem) {
                            return PopupMenuItem(
                              padding: const EdgeInsets.all(0),
                              child: InkWell(
                                onTap: () => Common.processPopupMenuRoute(
                                  videoPopupMenuItem: videoPopupMenuItem,
                                  video: widget.video,
                                  reporterName: widget.currentUser.username,
                                  reporterID: widget.currentUser.userID,
                                  currentUser: widget.currentUser,
                                  otherUser: widget.otherUser,
                                ),
                                child: Container(
                                  color: AppColors.backgroundColor,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10.0,
                                  ),
                                  child: Center(
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 10.0),
                                        Image.asset(
                                          videoPopupMenuItem.icon,
                                          width: 20.0,
                                        ),
                                        const SizedBox(width: 5.0),
                                        Expanded(
                                            child:
                                                Text(videoPopupMenuItem.text)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList();
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          );
  }

  void _processVideoLoading(String videoURL) async {
    setState(() {
      _isLoading = true;
    });
    await Common.openAdAndFullViewVideo(videoURL);
    setState(() {
      _isLoading = false;
    });
  }
}
