import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:torah_share/utils/colors.dart';

class LoadingHolder extends StatelessWidget {
  final Color baseColor, highlightColor;
  final Widget child;

  const LoadingHolder({
    Key key,
    @required this.child,
    this.baseColor,
    this.highlightColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      child: child,
      baseColor: baseColor ?? AppColors.baseColor,
      highlightColor: highlightColor ?? AppColors.highlightColor,
    );
  }
}
