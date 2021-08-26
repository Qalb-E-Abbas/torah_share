import 'package:flutter/material.dart';
import 'package:torah_share/modals/modals_exporter.dart';
import 'package:torah_share/utils/widgets/widgets_exporter.dart';

class ChatVideoCard extends StatelessWidget {
  final bool isMe;
  final String userImageURL;
  final Video video;
  final UserModal currentUser, otherUser;
  final Function onPressed;

  const ChatVideoCard({
    Key key,
    @required this.isMe,
    @required this.video,
    @required this.userImageURL,
    @required this.currentUser,
    @required this.otherUser,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 6.0),
          child: IntrinsicHeight(
            child: isMe
                ? CurrentUserVideoCard(
                    video: video,
                    userImageURL: userImageURL,
                    onPressed: onPressed,
                  )
                : OtherUserVideoCard(
                    userImageURL: userImageURL,
                    onPressed: onPressed,
                    video: video,
                    otherUser: otherUser,
                    currentUser: currentUser,
                  ),
          ),
        ),
        Divider(),
      ],
    );
  }
}
