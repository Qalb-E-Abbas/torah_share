import 'package:flutter/material.dart';
import 'package:torah_share/utils/widgets/widgets_exporter.dart';

class SharesNotificationListLoading extends StatelessWidget {
  const SharesNotificationListLoading({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 4,
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 5.0),
          child: SharesNotificationLoader(),
        );
      },
    );
  }
}
