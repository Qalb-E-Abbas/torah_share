import 'package:flutter/material.dart';

import '../../utils/util_exporter.dart';
import '../widgets/widgets_exporter.dart';

class OutlinePrimaryButton extends StatelessWidget {
  final String value;
  final EdgeInsetsGeometry padding;
  final Function onPressed;

  const OutlinePrimaryButton({
    Key key,
    @required this.value,
    this.padding = const EdgeInsets.symmetric(vertical: 15.0),
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: AppColors.primary,
          ),
        ),
        padding: padding,
        child: MediumPrimaryBoldText(value: value),
      ),
    );
  }
}
