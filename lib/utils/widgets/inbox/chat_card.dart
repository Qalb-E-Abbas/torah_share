import 'package:flutter/material.dart';
import 'package:torah_share/utils/widgets/widgets_exporter.dart';

class ChatCard extends StatelessWidget {
  final bool isMe;
  final String message, userImageURL;

  const ChatCard({
    Key key,
    @required this.isMe,
    @required this.message,
    @required this.userImageURL,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: isMe
              ? CurrentUserCard(
                  message: message,
                  userImageURL: userImageURL,
                )
              : OtherUserCard(
                  message: message,
                  userImageURL: userImageURL,
                ),
        ),
        Divider(),
      ],
    );
  }
}
