import 'package:flutter/material.dart';
import 'package:torah_share/utils/widgets/loader/loading_holder.dart';

class VideoGridViewLoading extends StatelessWidget {
  const VideoGridViewLoading({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: 4,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      itemBuilder: (BuildContext context, int index) {
        return LoadingHolder(
          child: Container(
            color: Colors.white,
          ),
        );
      },
    );
  }
}
