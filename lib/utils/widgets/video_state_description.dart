import 'package:flutter/material.dart';
import 'package:torah_share/utils/util_exporter.dart';
import 'package:torah_share/utils/widgets/widgets_exporter.dart';

class VideoStateDescription extends StatelessWidget {
  final String primaryIconLocalImage, primaryText, secondaryText, buttonText;
  final Function onButtonPressed;

  const VideoStateDescription({
    Key key,
    @required this.primaryIconLocalImage,
    @required this.primaryText,
    @required this.secondaryText,
    @required this.buttonText,
    this.onButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ButtonIcon(
          localImage: "${Common.assetsIcons}indicator_slider.png",
          width: 50.0,
        ),
        const SizedBox(height: 15.0),
        ButtonIcon(
          localImage: primaryIconLocalImage,
          height: 80.0,
          width: 80.0,
        ),
        const SizedBox(height: 30.0),
        LargePrimaryBoldText(value: primaryText),
        const SizedBox(height: 10.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: SmallLessPrimaryText(value: secondaryText),
        ),
        const SizedBox(height: 60.0),
        PrimaryButton(
          value: buttonText,
          onPressed: onButtonPressed,
        ),
        const SizedBox(height: 20.0),
      ],
    );
  }
}
