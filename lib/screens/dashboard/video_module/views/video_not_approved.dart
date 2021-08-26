import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:torah_share/screens/routes/routes_exporter.dart';
import 'package:torah_share/translations/locale_keys.g.dart';
import 'package:torah_share/utils/util_exporter.dart';
import 'package:torah_share/utils/widgets/widgets_exporter.dart';

class VideoNotApproved extends StatelessWidget {
  final String videoURL;

  const VideoNotApproved({
    Key key,
    @required this.videoURL,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context).settings.arguments as VideoNotApproved;
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: CustomAppBar(
              textChild: LargePrimaryBoldText(value: tr(LocaleKeys.upload)),
              willPop: true,
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  flex: 6,
                  child: CustomVideoPlayer(videoURL: arguments.videoURL),
                ),
                Expanded(
                  flex: 4,
                  child: SizedBox(),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomSheet: CustomBottomCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            VideoStateDescription(
              primaryIconLocalImage: "${Common.assetsIconsOutlined}alert.png",
              primaryText: tr(LocaleKeys.not_approved_yet),
              secondaryText:
                  tr(LocaleKeys.oh_sorry_your_request_is_not_approved_yet),
              buttonText: tr(LocaleKeys.okay),
              onButtonPressed: () => Get.toNamed(AppRoutes.homeRoute),
            ),
          ],
        ),
      ),
    );
  }
}
