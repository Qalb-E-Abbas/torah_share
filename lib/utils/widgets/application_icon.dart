import 'package:flutter/material.dart';

class ApplicationIcon extends StatelessWidget {
  final String localImage;

  const ApplicationIcon({
    Key key,
    this.localImage = "assets/icons/application_icon.png",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      localImage,
      height: 70.0,
      width: 70.0,
    );
  }
}
