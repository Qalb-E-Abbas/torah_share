import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:torah_share/screens/dashboard/video_module/views/full_screen_video.dart';
import 'package:torah_share/utils/widgets/widgets_exporter.dart';

class AdEngine extends StatefulWidget {
  final String adURL, videoURL;

  const AdEngine({
    Key key,
    @required this.adURL,
    @required this.videoURL,
  }) : super(key: key);
  @override
  _AdEngineState createState() => _AdEngineState();
}

class _AdEngineState extends State<AdEngine> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          child: CustomVideoPlayer(
            videoURL: widget.adURL,
            height: size.height,
            autoPlay: true,
            borderRadius: BorderRadius.circular(0.0),
            onVideoEnded: (value) => navigator.pushReplacement(
              MaterialPageRoute(
                builder: (context) => FullScreenVideo(
                  videoURL: widget.videoURL,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
