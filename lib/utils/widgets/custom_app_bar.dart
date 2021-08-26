import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:torah_share/utils/util_exporter.dart';
import 'package:torah_share/utils/widgets/widgets_exporter.dart';

class CustomAppBar extends StatelessWidget {
  final bool willPop, hasIconAndTextWhiteTheme, includeOptionButton;
  final String customIcon;
  final Function onBackPressed, onMenuClicked;
  final EdgeInsetsGeometry padding;
  final Widget textChild;

  const CustomAppBar({
    Key key,
    @required this.textChild,
    this.willPop = false,
    this.includeOptionButton = true,
    this.hasIconAndTextWhiteTheme = false,
    this.customIcon,
    this.onBackPressed,
    this.onMenuClicked,
    this.padding = const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: padding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            willPop
                ? BackIcon(
                    onPressed: onBackPressed ?? () => navigator.pop(),
                    iconColor: hasIconAndTextWhiteTheme
                        ? AppColors.whiteColor
                        : AppColors.primary,
                  )
                : const SizedBox.shrink(),
            Expanded(
              child: Align(
                alignment: willPop ? Alignment.center : Alignment.bottomLeft,
                child: textChild,
              ),
            ),
            includeOptionButton
                ? ButtonIcon(
                    localImage: customIcon != null
                        ? customIcon
                        : hasIconAndTextWhiteTheme
                            ? "${Common.assetsIcons}white_menu.png"
                            : "${Common.assetsIcons}menu.png",
                    onPressed: onMenuClicked,
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
