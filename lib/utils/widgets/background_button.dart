import 'package:flutter/material.dart';

import '../../utils/util_exporter.dart';
import '../widgets/widgets_exporter.dart';

class BackgroundButton extends StatelessWidget {
  final String value, localImage;
  final bool haveIcon;
  final Function onPressed;

  const BackgroundButton({
    Key key,
    @required this.value,
    this.localImage = "assets/icons/googleG.png",
    this.haveIcon = true,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: Wrap(
          alignment: WrapAlignment.center,
          children: [
            haveIcon
                ? ButtonIcon(localImage: localImage)
                : const SizedBox.shrink(),
            haveIcon ? const SizedBox(width: 10.0) : const SizedBox.shrink(),
            MediumPrimaryExtraBoldText(value: value),
          ],
        ),
      ),
    );
  }
}
