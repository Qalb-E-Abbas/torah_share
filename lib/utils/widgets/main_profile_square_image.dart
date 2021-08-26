import 'package:flutter/material.dart';
import 'package:torah_share/utils/widgets/level_badge.dart';

import '../util_exporter.dart';

class MainProfileSquareImage extends StatelessWidget {
  final String imageURL;
  final int followersCount;
  final Function onPressed;

  const MainProfileSquareImage({
    Key key,
    @required this.imageURL,
    @required this.followersCount,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Stack(
        children: [
          Container(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
              ),
              child: imageURL.isEmpty
                  ? Image.asset(
                      "${Common.assetsImages}default_user.png",
                      fit: BoxFit.fill,
                    )
                  : FadeInImage(
                      placeholder:
                          AssetImage("${Common.assetsImages}default_user.png"),
                      image: NetworkImage(imageURL),
                      fit: BoxFit.fill,
                    ),
            ),
            width: 100.0,
            height: 100.0,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: LevelBadge(
              followersCount: followersCount,
            ),
          ),
        ],
      ),
    );
  }
}
