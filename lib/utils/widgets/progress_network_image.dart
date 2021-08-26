import 'package:flutter/material.dart';
import 'package:torah_share/utils/util_exporter.dart';

class ProgressNetworkImage extends StatelessWidget {
  final String imageURL;
  final Function(bool) hasAssetLoaded;

  const ProgressNetworkImage({
    Key key,
    @required this.imageURL,
    @required this.hasAssetLoaded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageURL,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent loadingProgress) {
        if (loadingProgress == null) {
          hasAssetLoaded(true);
          return child;
        }
        return Center(
          child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(AppColors.primary),
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes
                : null,
          ),
        );
      },
    );
  }
}
