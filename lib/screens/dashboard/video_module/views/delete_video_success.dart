import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:torah_share/screens/routes/routes_exporter.dart';
import 'package:torah_share/translations/locale_keys.g.dart';
import 'package:torah_share/utils/util_exporter.dart';
import 'package:torah_share/utils/widgets/widgets_exporter.dart';

class DeleteVideoSuccess extends StatelessWidget {
  final String videoID, videoThumbnail;

  const DeleteVideoSuccess({
    Key key,
    @required this.videoID,
    @required this.videoThumbnail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: CustomAppBar(
                textChild: LargeWhiteBoldText(value: tr(LocaleKeys.videos)),
                willPop: false,
                hasIconAndTextWhiteTheme: true,
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        flex: 6,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(40.0),
                              topLeft: Radius.circular(40.0),
                            ),
                          ),
                          padding: EdgeInsets.all(13.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(40.0),
                              topLeft: Radius.circular(40.0),
                            ),
                            child: FadeInImage(
                              placeholder: AssetImage(
                                  "${Common.assetsImages}default_user.png"),
                              image: NetworkImage(videoThumbnail),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: SizedBox(),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Expanded(
                        child: DraggableScrolledContainer(
                          child: VideoStateDescription(
                            primaryIconLocalImage:
                                "${Common.assetsIcons}success.png",
                            primaryText: tr(LocaleKeys.delete_success),
                            secondaryText:
                                tr(LocaleKeys.video_have_successfully_deleted),
                            buttonText: tr(LocaleKeys.done),
                            onButtonPressed: () {
                              Get.toNamed(AppRoutes.uploadVideoRoute);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
