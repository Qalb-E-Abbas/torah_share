import 'package:flutter/material.dart';

import '../../../utils/util_exporter.dart';

class MediumPrimaryBoldText extends StatelessWidget {
  final String value;
  final TextAlign textAlign;

  const MediumPrimaryBoldText({
    Key key,
    @required this.value,
    this.textAlign = TextAlign.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: Styles.mediumPrimaryBoldTS(),
      textAlign: textAlign,
    );
  }
}
