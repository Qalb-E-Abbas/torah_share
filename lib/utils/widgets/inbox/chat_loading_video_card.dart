import 'package:flutter/material.dart';
import 'package:torah_share/utils/util_exporter.dart';
import 'package:torah_share/utils/widgets/widgets_exporter.dart';

class ChatLoadingVideoCard extends StatelessWidget {
  final bool isMe;

  const ChatLoadingVideoCard({
    Key key,
    @required this.isMe,
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
                ? Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: Container(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Stack(
                                children: [
                                  LoadingHolder(
                                    child: Container(
                                      height: 160.0,
                                      color: Colors.white,
                                    ),
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
                        ),
                      ),
                      const SizedBox(width: 5.0),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: LoadingHolder(
                          child: Container(
                            width: 40.0,
                            height: 40.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: LoadingHolder(
                          child: Container(
                            width: 40.0,
                            height: 40.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5.0),
                      Expanded(
                        flex: 12,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: Container(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Stack(
                                children: [
                                  LoadingHolder(
                                    child: Container(
                                      height: 160.0,
                                      color: Colors.white,
                                    ),
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
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        Divider(),
      ],
    );
  }
}
