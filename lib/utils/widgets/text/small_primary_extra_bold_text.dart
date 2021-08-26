import 'package:flutter/material.dart';

import '../../../utils/util_exporter.dart';

class SmallPrimaryExtraBoldText extends StatelessWidget {
  final String value;

  const SmallPrimaryExtraBoldText({
    Key key,
    @required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: Styles.smallPrimaryExtraBoldTS(),
      textAlign: TextAlign.center,
    );
  }
}
