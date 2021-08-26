import 'package:flutter/material.dart';
import 'package:torah_share/utils/util_exporter.dart';

class SquareVideoHolder extends StatelessWidget {
  final double radius, padding;
  final String asset;
  final Color color;
  final Function onPressed;
  final Widget child;

  const SquareVideoHolder({
    Key key,
    this.radius = 10.0,
    this.padding = 15.0,
    this.asset = "${Common.assetsIconsOutlined}upload.png",
    this.color,
    this.onPressed,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: color ?? Colors.black.withOpacity(0.09),
        ),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(radius),
            ),
            padding: EdgeInsets.all(padding),
            child: child ??
                Image.asset(
                  asset,
                  width: 40.0,
                ),
          ),
        ),
      ),
    );
  }
}
