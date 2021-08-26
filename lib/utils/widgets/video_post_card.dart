import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeAgo;
import 'package:torah_share/modals/modals_exporter.dart';
import 'package:torah_share/modals/video.dart';
import 'package:torah_share/screens/views_exporter.dart';
import 'package:torah_share/translations/locale_keys.g.dart';
import 'package:torah_share/utils/util_exporter.dart';
import 'package:torah_share/utils/widgets/widgets_exporter.dart';

class VideoPostCard extends StatefulWidget {
  final Video video;

  const VideoPostCard({
    Key key,
    @required this.video,
  }) : super(key: key);
  @override
  _VideoPostCardState createState() => _VideoPostCardState();
}

class _VideoPostCardState extends State<VideoPostCard> {
  bool _isLoading = true;
  UserModal _uploader;

  @override
  void initState() {
    _getUploader();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? PostCard(
            verticalPadding: 20.0,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 10.0, bottom: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      LoadingHolder(
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          width: 45.0,
                          height: 45.0,
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: LoadingHolder(
                          child: Container(
                            height: 16.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12.0),
                    ],
                  ),
                ),
                Divider(
                  color: AppColors.backgroundColor,
                  thickness: 2.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 10.0),
                      LoadingHolder(
                        child: Container(
                          height: 16.0,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: Container(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Stack(
                              children: [
                                LoadingHolder(
                                  child: Container(
                                    height: 160.0,
                                    color: Colors.white,
                                  ),
                                ),
                                Positioned.fill(
                                  child: Image.asset(
                                    "${Common.assetsIcons}pause_button.png",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: AppColors.backgroundColor,
                  thickness: 2.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 10.0, bottom: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: LoadingHolder(
                          child: Container(
                            height: 16.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20.0),
                      Expanded(
                        child: LoadingHolder(
                          child: Container(
                            height: 16.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20.0),
                      Expanded(
                        child: LoadingHolder(
                          child: Container(
                            height: 16.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20.0),
                    ],
                  ),
                ),
              ],
            ),
          )





        : PostCard(
            verticalPadding: 20.0,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 10.0, bottom: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SmallCircleAvatar(
                        userImage: _uploader.profileImageUrl,
                      ),
                      const SizedBox(width: 15.0),


                      Expanded(
                        child: LargePrimaryBoldText(
                          value: _uploader.username,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      const SizedBox(width: 15.0),


                      /// Delete
                      PopupMenuButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),

                        icon: Icon(
                          FontAwesomeIcons.ellipsisV,
                          size: 18.0,
                        ),


                        itemBuilder: (BuildContext context) {
                          return currentUserProfileVideoPopupMenuItemList
                              .map((VideoPopupMenuItem videoPopupMenuItem) {
                            return PopupMenuItem(
                              padding: const EdgeInsets.all(0),
                              child: InkWell(
                                onTap: () => Common.processPopupMenuRoute(
                                  videoPopupMenuItem: videoPopupMenuItem,
                                  videoID: widget.video.videoId,
                                  videoURL: widget.video.videoUrl,
                                  videoThumbnail: widget.video.thumbnailURL,
                                ),
                                child: Container(
                                  color: AppColors.backgroundColor,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        videoPopupMenuItem.icon,
                                        width: 25.0,
                                      ),
                                      const SizedBox(width: 10.0),
                                      Text(videoPopupMenuItem.text)
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList();
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 13,),

                // Divider(
                //   color: AppColors.backgroundColor,
                //   thickness: 2.0,
                // ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:2.0),
                        child: SmallLessPrimaryText(
                          value: widget.video.caption,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: ThumbnailHolder(
                          url: widget.video.thumbnailURL,
                          videoURL: widget.video.videoUrl,
                          onPressed: () =>
                              _processVideoLoading(widget.video.videoUrl),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: AppColors.backgroundColor,
                  thickness: 2.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 10.0, bottom: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            ButtonIcon(
                                localImage:
                                    "${Common.assetsIconsOutlined}share.png"),
                            const SizedBox(width: 5.0),
                            StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collectionGroup(Common.sharesCollection)
                                    .where("video_id",
                                        isEqualTo: widget.video.videoId)
                                    .orderBy("created_on")
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData)
                                    return const SizedBox();
                                  return ExtraSmallLessPrimaryText(
                                    value:
                                        "${snapshot.data.docs.length} ${tr(LocaleKeys.shares)} ",
                                    textAlign: TextAlign.start,
                                  );
                                }),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            ButtonIcon(
                                onPressed: () => navigator.push(
                                      MaterialPageRoute(
                                        builder: (context) => Comment(
                                          video: widget.video,
                                        ),
                                      ),
                                    ),
                                localImage:
                                    "${Common.assetsIconsOutlined}comment.png"),
                            const SizedBox(width: 5.0),
                            StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection(Common.commentsCollection)
                                  .where("video_id",
                                      isEqualTo: widget.video.videoId)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) return const SizedBox();
                                return ExtraSmallLessPrimaryText(
                                  value:
                                      "${snapshot.data.docs.length}  ${tr(LocaleKeys.comments)}",
                                  textAlign: TextAlign.start,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ExtraSmallLessPrimaryText(
                          value:
                              "${timeAgo.format(DateTime.fromMillisecondsSinceEpoch(widget.video.createdOn.toInt()))}",
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  void _getUploader() async {
    _uploader = await ApiRequests.getUser(widget.video.uploaderId);
    _isLoading = false;
    if (mounted) setState(() {});
  }

  void _processVideoLoading(String videoURL) async {
    if (mounted)
      setState(() {
        _isLoading = true;
      });
    await Common.openAdAndFullViewVideo(videoURL);
    if (mounted)
      setState(() {
        _isLoading = false;
      });
  }
}
