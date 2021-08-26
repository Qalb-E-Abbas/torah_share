import 'package:flutter/material.dart';
import 'package:torah_share/utils/util_exporter.dart';
import 'package:torah_share/utils/widgets/widgets_exporter.dart';

class SharesNotificationLoader extends StatelessWidget {
  const SharesNotificationLoader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
      ),
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
      child: Row(
        children: [
          LoadingHolder(
            child: Container(
              width: 50.0,
              height: 50.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LoadingHolder(
                    child: Container(
                      color: Colors.white,
                      height: 16.0,
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  LoadingHolder(
                    child: Container(
                      color: Colors.white,
                      height: 16.0,
                      width: 100.0,
                    ),
                  ),
                ],
              )),
          const SizedBox(width: 10.0),
          Expanded(
            flex: 1,
            child: LoadingHolder(
              child: Container(
                color: Colors.white,
                height: 16.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
