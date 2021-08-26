import 'package:flutter/material.dart';
import 'package:torah_share/utils/util_exporter.dart';

class FilterToggleCard extends StatelessWidget {
  final bool isSelected;
  final String assetName, title;
  final Function onPressed;

  const FilterToggleCard({
    Key key,
    @required this.assetName,
    @required this.title,
    this.isSelected = false,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 30.0),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.filterSelectedCardColor.withOpacity(0.65)
              : AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          children: [
            Image.asset(
              "${Common.assetsIcons}$assetName",
              height: 60.0,
            ),
            const SizedBox(height: 10.0),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? AppColors.whiteColor : AppColors.primary,
                fontSize: 18.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
