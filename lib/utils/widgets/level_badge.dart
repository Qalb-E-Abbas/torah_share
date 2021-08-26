import 'package:flutter/material.dart';
import 'package:torah_share/utils/util_exporter.dart';

class LevelBadge extends StatefulWidget {
  final int followersCount;
  const LevelBadge({
    Key key,
    @required this.followersCount,
  }) : super(key: key);

  @override
  _LevelBadgeState createState() => _LevelBadgeState();
}

class _LevelBadgeState extends State<LevelBadge> {
  Color badgeColor = AppColors.levelOneColor;
  bool badgeAvailable = false;

  @override
  void initState() {
    _decideColor();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return badgeAvailable
        ? Container(
            decoration: BoxDecoration(
              // color: badgeColor,
              borderRadius: BorderRadius.circular(5.0),
            ),
            padding: const EdgeInsets.all(4.0),
            child:
                Image.asset(Common.assetsIcons + "level_colorless_badge.png", height: 24,),
          )
        : const SizedBox.shrink();
  }

  void _decideColor() {
    if (widget.followersCount == 1) {
      // condition: followersCount < 100
      // badge status: badgeAvailable = false
      // remove color
      badgeAvailable = true;
      badgeColor = AppColors.levelOneColor;
    } else if (widget.followersCount == 2) {
      // condition: widget.followersCount >= 100 && widget.followersCount < 1000
      // color: levelOneColor
      badgeAvailable = true;
      badgeColor = AppColors.levelTwoColor;
    } else if (widget.followersCount > 2) {
      // condition: widget.followersCount >= 1000 && widget.followersCount < 10000
      // color: levelTwoColor
      badgeAvailable = true;
      badgeColor = AppColors.levelThreeColor;
    } else if (widget.followersCount >= 10000) {
      badgeAvailable = true;
      badgeColor = AppColors.levelThreeColor;
    } else
      badgeAvailable = false;
    setState(() {});
  }
}
