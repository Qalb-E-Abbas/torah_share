import 'package:flutter/material.dart';
import 'package:torah_share/utils/util_exporter.dart';

class PostCard extends StatelessWidget {
  final Widget child;
  final double verticalPadding;

  const PostCard({
    Key key,
    @required this.child,
    this.verticalPadding = 30.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        // boxShadow: [
        //   BoxShadow(
        //     color: AppColors.primary.withOpacity(0.2),
        //     spreadRadius: 0.5,
        //     blurRadius: 8,
        //   ),
        // ],
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      margin: const EdgeInsets.only(bottom: 10.0),
      child: child,
    );
  }
}
