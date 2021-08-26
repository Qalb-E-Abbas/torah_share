import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:torah_share/translations/locale_keys.g.dart';
import 'package:torah_share/utils/util_exporter.dart';
import 'package:torah_share/utils/widgets/widgets_exporter.dart';

class DeleteVideo extends StatefulWidget {
  final String videoID, videoThumbnail, videoURL;

  const DeleteVideo({
    Key key,
    @required this.videoID,
    @required this.videoThumbnail,
    @required this.videoURL,
  }) : super(key: key);

  @override
  _DeleteVideoState createState() => _DeleteVideoState();
}

class _DeleteVideoState extends State<DeleteVideo> {
  bool _isLoading = false, _isDeleted = false;

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
                      textChild: LargeWhiteBoldText(
                          value: tr(LocaleKeys.delete_video)),
                      willPop: true,
                      hasIconAndTextWhiteTheme: true,
                      includeOptionButton: false,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(35.0),
                          topLeft: Radius.circular(35.0),
                        ),
                      ),
                      padding: EdgeInsets.all(12.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(35.0),
                          topLeft: Radius.circular(35.0),
                        ),
                        child: Image.network(
                          widget.videoThumbnail,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            bottomSheet: CustomBottomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _isDeleted
                      ? VideoStateDescription(
                          primaryIconLocalImage:
                              "${Common.assetsIcons}success.png",
                          primaryText: tr(LocaleKeys.delete_success),
                          secondaryText:
                              tr(LocaleKeys.video_have_successfully_deleted),
                          buttonText: tr(LocaleKeys.done),
                          onButtonPressed: () => navigator.pop(),
                        )
                      : VideoStateDescription(
                          primaryIconLocalImage:
                              "${Common.assetsIconsOutlined}alert.png",
                          primaryText: tr(LocaleKeys.delete_video_question),
                          secondaryText: tr(LocaleKeys
                              .are_you_sure_you_want_to_delete_this_video_question),
                          buttonText: tr(LocaleKeys.delete),
                          onButtonPressed: () => _processDeleteVideo(
                              widget.videoID,
                              widget.videoURL,
                              widget.videoThumbnail),
                        ),
                ],
              ),
            ),
          ),
          _isLoading
              ? Positioned.fill(
                  child: Container(
                    color: AppColors.blackColor.withOpacity(0.25),
                  ),
                )
              : const SizedBox.shrink(),
          _isLoading
              ? Positioned.fill(
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  void _processDeleteVideo(
      String videoID, String videoURL, String thumbnailURL) async {
    setState(() {
      _isLoading = true;
    });

    // delete video from fireStore and storage completely and from all shares as well.
    await ApiRequests.deleteVideoInComments(videoID);
    await ApiRequests.deleteVideoInShares(videoID);
    await ApiRequests.deleteVideoInVideos(videoID);
    await ApiRequests.deleteVideoResourcesFromStorage(videoURL, thumbnailURL);

    setState(() {
      _isDeleted = true;
      _isLoading = false;
    });
  }
}
