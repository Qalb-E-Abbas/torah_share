import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:torah_share/utils/util_exporter.dart';

class BackIcon extends StatelessWidget {
  final Function onPressed;
  final Color iconColor;

  const BackIcon({
    Key key,
    this.onPressed,
    this.iconColor = AppColors.primary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Icon(
        Platform.isAndroid ? Icons.arrow_back_outlined : CupertinoIcons.back,
        color: iconColor,
      ),
    );
  }
}
