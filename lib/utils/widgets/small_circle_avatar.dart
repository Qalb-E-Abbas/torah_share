import 'package:flutter/material.dart';
import 'package:torah_share/utils/util_exporter.dart';

class SmallCircleAvatar extends StatefulWidget {
  final String userImage;
  final double radius;

  const SmallCircleAvatar({
    Key key,
    this.userImage,
    this.radius = 25.0,
  }) : super(key: key);

  @override
  _SmallCircleAvatarState createState() => _SmallCircleAvatarState();
}

class _SmallCircleAvatarState extends State<SmallCircleAvatar> {
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: widget.radius,
      backgroundColor: AppColors.backgroundColor,
      backgroundImage: (widget.userImage == null || widget.userImage.isEmpty)
          ? AssetImage("${Common.assetsImages}default_user.png")
          : NetworkImage(widget.userImage),
    );
  }
}
