import 'package:flutter/material.dart';

import '../../../utils/util_exporter.dart';

class ExtraLargeExtraBoldPrimaryText extends StatelessWidget {
  final String value;

  const ExtraLargeExtraBoldPrimaryText({
    Key key,
    @required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: Styles.extraLargePrimaryExtraBoldTS(),
      textAlign: TextAlign.center,
    );
  }
}
