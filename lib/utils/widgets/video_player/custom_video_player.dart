import 'package:flutter/material.dart';
import 'package:torah_share/utils/util_exporter.dart';
import 'package:torah_share/utils/widgets/widgets_exporter.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatefulWidget {
  final String videoURL;
  final bool isLocal, autoPlay;
  final double height;
  final BorderRadius borderRadius;
  final Function(bool) onVideoEnded;

  const CustomVideoPlayer({
    Key key,
    @required this.videoURL,
    this.isLocal = false,
    this.autoPlay = false,
    this.height = 215.0,
    this.borderRadius,
    this.onVideoEnded,
  }) : super(key: key);
  @override
  _CustomVideoPlayerState createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  VideoPlayerController _videoController;

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    widget.isLocal
        ? (_videoController = VideoPlayerController.asset(widget.videoURL)
          ..addListener(() {
            if ((_videoController.value.isInitialized) &&
                !_videoController.value.isPlaying &&
                (_videoController.value.duration ==
                    _videoController.value.position)) {
              //checking the duration and position every time
              //Video Completed//
              setState(() {
                _videoController.seekTo(Duration(seconds: 0));
              });
            }
          })
          ..initialize())
        : _videoController = VideoPlayerController.network(widget.videoURL)
      ..addListener(() {
        if ((_videoController.value.isInitialized) &&
            !_videoController.value.isPlaying &&
            (_videoController.value.duration ==
                _videoController.value.position)) {
          //checking the duration and position every time
          //Video Completed//
          setState(() {
            _videoController.seekTo(Duration(seconds: 0));
          });
        }
      })
      ..initialize();
    if (widget.autoPlay) _videoController.play();
    if (widget.onVideoEnded != null) _videoController.addListener(listenVideo);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ClipRRect(
          borderRadius: widget.borderRadius ?? BorderRadius.circular(10.0),
          child: Stack(
            children: [
              Positioned(
                child: InkWell(
                  onTap: () => {
                    if (_videoController.value.isPlaying)
                      {
                        _videoController.pause(),
                      }
                    else if (!_videoController.value.isPlaying)
                      {
                        _videoController.play(),
                      },
                    setState(() {}),
                  },
                  child: _loadAndDisplayVideo(
                      _videoController.value.isInitialized),
                ),
              ),
              Positioned.fill(
                child: _videoController.value.isPlaying
                    ? const SizedBox.shrink()
                    : DarkOverlay(
                        child: InkWell(
                          onTap: () => {
                            if ((_videoController.value.isInitialized) &&
                                (!_videoController.value.isPlaying))
                              {
                                _videoController.play(),
                              },
                            setState(() {}),
                          },
                          child: Image.asset(
                            "${Common.assetsIcons}pause_button.png",
                          ),
                        ),
                      ),
              ),
            ],
          )),
    );
  }

  Widget _loadAndDisplayVideo(bool isVideoInitialized) {
    return VideoPlayer(_videoController);
  }

  void listenVideo() {
    if (_videoController.value.position == _videoController.value.duration) {
      widget.onVideoEnded(true);
    }
  }
}
