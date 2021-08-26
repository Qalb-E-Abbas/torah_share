import 'package:flutter/material.dart';
import 'package:torah_share/utils/util_exporter.dart';

class ThumbnailHolder extends StatelessWidget {
  final String url, videoURL;
  final double bottomMargin;
  final bool fillPositioned;
  final Function() onPressed;

  const ThumbnailHolder({
    Key key,
    @required this.url,
    @required this.videoURL,
    this.fillPositioned = false,
    this.bottomMargin = 10.0,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed ?? () => Common.openAdAndFullViewVideo(videoURL),
      child: Container(
        margin: EdgeInsets.only(bottom: bottomMargin),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Stack(
            children: [
              fillPositioned
                  ? Positioned.fill(
                      child: Image.network(
                        url,
                        fit: BoxFit.fill,
                      ),
                    )
                  : Image.network(
                      url,
                      width: double.infinity,
                      fit: BoxFit.fill,
                    ),
              Positioned.fill(
                child: Image.asset(
                  "${Common.assetsIcons}pause_button.png",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
