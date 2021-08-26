import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:torah_share/screens/views_exporter.dart';
import 'package:torah_share/translations/locale_keys.g.dart';
import 'package:torah_share/utils/util_exporter.dart';
import 'package:torah_share/utils/widgets/widgets_exporter.dart';

class CaptureVideo extends StatefulWidget {
  const CaptureVideo({Key key}) : super(key: key);

  @override
  _CaptureVideoState createState() => _CaptureVideoState();
}

class _CaptureVideoState extends State<CaptureVideo> {
  CameraController controller;
  String videoPath;
  List<CameraDescription> cameras;
  int selectedCameraIdx;

  @override
  void initState() {
    super.initState();
    // Get the listonNewCameraSelected of available cameras.
    // Then set the first camera as selected.
    availableCameras().then((availableCameras) {
      cameras = availableCameras;

      if (cameras.length > 0) {
        setState(() {
          selectedCameraIdx = 0;
        });

        _onCameraSwitched(cameras[selectedCameraIdx]).then((void v) {});
      }
    }).catchError((err) {
      print('Error: $err.code\nError Message: $err.message');
    });
  }

  Future<void> _onCameraSwitched(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }

    controller = CameraController(cameraDescription, ResolutionPreset.high);

    // If the controller is updated then update the UI.
    controller.addListener(() {
      if (mounted) {
        setState(() {});
      }

      if (controller.value.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Camera error ${controller.value.errorDescription}"),
          ),
        );
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _showCameraException(CameraException e) {
    String errorText = 'Error: ${e.code}\nError Message: ${e.description}';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Error: $errorText"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: CustomAppBar(
              textChild:
                  LargeWhiteBoldText(value: tr(LocaleKeys.capture_video)),
              willPop: true,
              includeOptionButton: false,
              hasIconAndTextWhiteTheme: true,
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              padding: const EdgeInsets.all(10.0),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30.0),
                      child: _cameraPreviewWidget(),
                    ),
                  ),
                  Positioned(
                    bottom: 20.0,
                    right: 0.0,
                    left: 0.0,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 30.0),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18.0,
                        vertical: 15.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.20),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          cameras == null
                              ? const SizedBox.shrink()
                              : RoundVideoHolder(
                                  onPressed: _onSwitchCamera,
                                  color: Colors.transparent,
                                  asset:
                                      "${Common.assetsIconsFilled}retake_video.png",
                                ),
                          _isVideoRecording()
                              ? SquareVideoHolder(
                                  onPressed: () => _startRecording(),
                                  color: Colors.transparent,
                                  asset:
                                      "${Common.assetsIconsFilled}record_video.png",
                                )
                              : SquareVideoHolder(
                                  onPressed: () => _stopVideoRecording(),
                                  color: Colors.transparent,
                                  child: Icon(
                                    Icons.stop,
                                    color: Colors.red,
                                    size: 40.0,
                                  ),
                                  padding: 10.0,
                                ),
                          InkWell(
                            onTap: () => _pickVideo(),
                            child: Image.asset(
                              "${Common.assetsImages}take_image_from_gallery.png",
                              width: 50.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // This function will helps you to pick a Video File
  _pickVideo() async {
    PickedFile pickedVideo = await ImagePicker().getVideo(
      source: ImageSource.gallery,
      maxDuration: Duration(minutes: 10),
    );
    setState(() {});
    if (pickedVideo != null)
      _moveScreen(pickedVideo.path, File(pickedVideo.path));
  }

  void _startRecording() {
    if (mounted) {
      setState(() {});
    }
    _startVideoRecording().then((String filePath) {
      if (filePath != null) {
        // start timer of 10 minutes and once timer is completed auto stop the recording and proceed to next screen
        Future.delayed(const Duration(minutes: 10), () {
          // Here you can write your code
          if (mounted) {
            setState(() {
              _stopVideoRecording();
            });
          }
        });
      }
    });
  }

  Future<void> _stopVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await controller.stopVideoRecording().then(
        (value) {
          _moveScreen(value.path, File(value.path));
        },
      );
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  Future<String> _startVideoRecording() async {
    if (!controller.value.isInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(tr(LocaleKeys.please_wait)),
        ),
      );
      return null;
    }

    // Do nothing if a recording is on progress
    if (controller.value.isRecordingVideo) {
      return null;
    }

    final Directory appDirectory = await getApplicationDocumentsDirectory();
    final String videoDirectory = '${appDirectory.path}/Videos';
    await Directory(videoDirectory).create(recursive: true);
    final String currentTime = DateTime.now().millisecondsSinceEpoch.toString();
    final String filePath = '$videoDirectory/$currentTime.mp4';

    try {
      await controller.startVideoRecording();
      videoPath = filePath;
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }

    return filePath;
  }

  bool _isVideoRecording() {
    return (controller != null &&
        controller.value.isInitialized &&
        !controller.value.isRecordingVideo);
  }

  // Display 'Loading' text when the camera is still loading.
  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return Text(
        tr(LocaleKeys
            .to_upload_any_video_the_app_user_requires_to_get_approval_from_us),
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w900,
        ),
      );
    }

    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: CameraPreview(controller),
    );
  }

  void _onSwitchCamera() {
    selectedCameraIdx =
        selectedCameraIdx < cameras.length - 1 ? selectedCameraIdx + 1 : 0;
    CameraDescription selectedCamera = cameras[selectedCameraIdx];

    _onCameraSwitched(selectedCamera);

    setState(() {
      selectedCameraIdx = selectedCameraIdx;
    });
  }

  void _moveScreen(String path, File videoFile) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PreviewCaptureVideo(videoURL: path),
      ),
    );
  }
}
