import 'package:flutter/material.dart';
import 'package:torah_share/utils/util_exporter.dart';
import 'package:torah_share/utils/widgets/widgets_exporter.dart';

class CurrentUserCard extends StatelessWidget {
  final String userImageURL, message;

  const CurrentUserCard({
    Key key,
    @required this.userImageURL,
    @required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(15.0),
              topLeft: Radius.circular(15.0),
              bottomLeft: Radius.circular(15.0),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
          child: MediumWhiteText(
            value: message,
          ),
        ),
        const SizedBox(width: 5.0),
        SmallCircleAvatar(
          radius: 20.0,
          userImage: userImageURL,
        ),
      ],
    );
  }
}
