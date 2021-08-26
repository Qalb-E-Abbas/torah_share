import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ButtonIcon extends StatelessWidget {
  final String localImage;
  final double width, height;
  final Function onPressed;

  const ButtonIcon({
    Key key,
    this.localImage = "assets/icons/application_icon.png",
    this.onPressed,
    this.width = 25.0,
    this.height = 25.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed ?? () => Get.back(),
      child: Image.asset(
        localImage,
        height: height,
        width: width,
      ),
    );
  }
}
