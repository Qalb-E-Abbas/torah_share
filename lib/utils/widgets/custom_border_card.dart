import 'package:flutter/material.dart';
import 'package:torah_share/utils/util_exporter.dart';

class CustomBorderCard extends StatelessWidget {
  final Widget child;
  final Color color;
  final Radius topLeft, topRight, bottomLeft, bottomRight;
  final bool haveDivider;
  final EdgeInsetsGeometry cardPadding;
  final EdgeInsetsGeometry dividerPadding;
  final Function onPressed;

  const CustomBorderCard({
    Key key,
    @required this.child,
    this.onPressed,
    this.color = AppColors.whiteColor,
    this.topLeft = const Radius.circular(10.0),
    this.topRight = const Radius.circular(10.0),
    this.bottomRight = const Radius.circular(10.0),
    this.bottomLeft = const Radius.circular(10.0),
    this.haveDivider = false,
    this.cardPadding = const EdgeInsets.all(0.0),
    this.dividerPadding = const EdgeInsets.all(0.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.only(
            topLeft: topLeft,
            topRight: topRight,
            bottomRight: bottomRight,
            bottomLeft: bottomLeft,
          ),
        ),
        child: Wrap(
          children: [
            Padding(
              padding: cardPadding,
              child: child,
            ),
            haveDivider
                ? Padding(
                    padding: dividerPadding,
                    child: Divider(),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
