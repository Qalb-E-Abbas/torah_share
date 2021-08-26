import 'package:flutter/material.dart';
import '../../../utils/widgets/widgets_exporter.dart';

class InquiryTextAndTextButton extends StatelessWidget {
  final String inquiryText, actionButtonText;
  final Function onPressed;

  const InquiryTextAndTextButton({
    Key key,
    @required this.inquiryText,
    @required this.actionButtonText,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Wrap(
        children: [
          SmallLessPrimaryText(value: inquiryText),
          SmallPrimaryExtraBoldText(value: actionButtonText),
        ],
      ),
    );
  }
}
