import 'package:flutter/material.dart';

import '../../../utils/util_exporter.dart';

class MediumPrimaryExtraBoldText extends StatelessWidget {
  final String value;

  const MediumPrimaryExtraBoldText({
    Key key,
    @required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: Styles.mediumPrimaryExtraBoldTS(),
      textAlign: TextAlign.center,
    );
  }
}
