import 'package:flutter/material.dart';
import 'package:torah_share/utils/util_exporter.dart';

class LeadingIconTrailingText extends StatelessWidget {
  final String text, icon;

  const LeadingIconTrailingText({
    Key key,
    @required this.text,
    this.icon = "${Common.assetsIcons}small_location_pin.png",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset(
          icon,
          width: 18.0,
        ),
        const SizedBox(width: 2.5),
        Text(
          text,
          style: Styles.smallLightTS(),
        ),
      ],
    );
  }
}
