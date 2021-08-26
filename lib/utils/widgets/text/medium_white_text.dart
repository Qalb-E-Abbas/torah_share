import 'package:flutter/material.dart';

import '../../../utils/util_exporter.dart';

class MediumWhiteText extends StatelessWidget {
  final String value;

  const MediumWhiteText({
    Key key,
    @required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: Styles.mediumWhiteRegularTS(),
      textAlign: TextAlign.center,
    );
  }
}
