import 'package:flutter/material.dart';

import '../../../utils/util_exporter.dart';

class SmallBrightPrimaryText extends StatelessWidget {
  final String value;
  final TextAlign textAlign;

  const SmallBrightPrimaryText({
    Key key,
    @required this.value,
    this.textAlign = TextAlign.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      "$value ",
      style: Styles.smallBrightPrimaryRegularTS(),
      textAlign: textAlign,
    );
  }
}
