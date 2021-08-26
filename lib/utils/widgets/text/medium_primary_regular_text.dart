import 'package:flutter/material.dart';
import 'package:torah_share/utils/util_exporter.dart';

class MediumPrimaryRegularText extends StatelessWidget {
  final String value;
  final TextAlign textAlign;

  const MediumPrimaryRegularText({
    Key key,
    @required this.value,
    this.textAlign = TextAlign.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: Styles.mediumPrimaryRegularTS(),
      textAlign: textAlign,
    );
  }
}
