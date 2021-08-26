import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:torah_share/modals/modals_exporter.dart';
import 'package:torah_share/utils/util_exporter.dart';
import 'package:torah_share/utils/widgets/widgets_exporter.dart';

class CurrentUserVideoCard extends StatefulWidget {
  final String userImageURL;
  final Video video;
  final Function onPressed;

  const CurrentUserVideoCard({
    Key key,
    @required this.video,
    @required this.userImageURL,
    this.onPressed,
  }) : super(key: key);

  @override
  _CurrentUserVideoCardState createState() => _CurrentUserVideoCardState();
}

class _CurrentUserVideoCardState extends State<CurrentUserVideoCard> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? ChatLoadingVideoCard(isMe: true)
        : Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.topRight,
                  child: PopupMenuButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    icon: Icon(
                      FontAwesomeIcons.ellipsisV,
                      size: 18.0,
                    ),
                    itemBuilder: (BuildContext context) {
                      return currentUserVideoPopupMenuItemList
                          .map((VideoPopupMenuItem videoPopupMenuItem) {
                        return PopupMenuItem(
                          padding: const EdgeInsets.all(0),
                          child: InkWell(
                            onTap: () => Common.processPopupMenuRoute(
                              videoPopupMenuItem: videoPopupMenuItem,
                              video: widget.video,
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
                                        child: Text(videoPopupMenuItem.text)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList();
                    },
                  ),
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
                      textAlign: TextAlign.end,
                    ),
                    const SizedBox(height: 10.0),
                    Expanded(
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
              const SizedBox(width: 5.0),
              Align(
                alignment: Alignment.bottomLeft,
                child: SmallCircleAvatar(
                  radius: 20.0,
                  userImage: widget.userImageURL,
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
