import 'package:flutter/material.dart';
import 'package:torah_share/utils/widgets/widgets_exporter.dart';

class FullScreenVideo extends StatefulWidget {
  final String videoURL;
  const FullScreenVideo({
    Key key,
    @required this.videoURL,
  }) : super(key: key);

  @override
  _FullScreenVideoState createState() => _FullScreenVideoState();
}

class _FullScreenVideoState extends State<FullScreenVideo> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        child: CustomVideoPlayer(
          videoURL: widget.videoURL,
          height: size.height,
          autoPlay: true,
          borderRadius: BorderRadius.circular(0.0),
        ),
      ),
    );
  }
}
