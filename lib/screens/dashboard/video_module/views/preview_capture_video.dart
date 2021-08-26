import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:torah_share/screens/views_exporter.dart';
import 'package:torah_share/translations/locale_keys.g.dart';
import 'package:torah_share/utils/util_exporter.dart';
import 'package:torah_share/utils/widgets/widgets_exporter.dart';

class PreviewCaptureVideo extends StatefulWidget {
  final String videoURL;

  const PreviewCaptureVideo({
    Key key,
    @required this.videoURL,
  }) : super(key: key);

  @override
  _PreviewCaptureVideoState createState() => _PreviewCaptureVideoState();
}

class _PreviewCaptureVideoState extends State<PreviewCaptureVideo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: CustomAppBar(
              textChild:
                  LargeWhiteBoldText(value: tr(LocaleKeys.preview_video)),
              willPop: true,
              customIcon: "${Common.assetsIconsOutlined + "delete_white.png"}",
              onMenuClicked: () => Get.back(),
              hasIconAndTextWhiteTheme: true,
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              padding: const EdgeInsets.all(10.0),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30.0),
                      child: CustomVideoPlayer(videoURL: widget.videoURL),
                    ),
                  ),
                  Positioned(
                    bottom: 20.0,
                    right: 0.0,
                    left: 0.0,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 30.0),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15.0,
                        vertical: 12.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.20),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: PrimaryButton(
                        value: tr(LocaleKeys.publish),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                UploadVideo(videoURL: widget.videoURL),
                          ),
                        ),
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
}
