import 'package:flutter/material.dart';
import 'package:torah_share/utils/util_exporter.dart';

class DialogPrimaryButton extends StatelessWidget {
  final String buttonText;
  final Function onPressed;

  const DialogPrimaryButton({
    Key key,
    @required this.buttonText,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 20.0,
        ),
        child: Text(
          buttonText,
          style: TextStyle(
            color: AppColors.whiteColor,
          ),
        ),
      ),
    );
  }
}
