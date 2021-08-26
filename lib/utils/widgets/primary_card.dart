import 'package:flutter/material.dart';

import '../../utils/util_exporter.dart';

class PrimaryCard extends StatelessWidget {
  final Widget child;
  final List<BoxShadow> boxShadow;
  final double horizontalPadding, verticalPadding;

  const PrimaryCard({
    Key key,
    @required this.child,
    this.boxShadow,
    this.horizontalPadding = 15.0,
    this.verticalPadding = 30.0,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: boxShadow,
      ),
      padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding, vertical: verticalPadding),
      child: child,
    );
  }
}
