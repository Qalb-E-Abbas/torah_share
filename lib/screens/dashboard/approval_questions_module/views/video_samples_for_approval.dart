import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:torah_share/modals/modals_exporter.dart';
import 'package:torah_share/screens/routes/routes_exporter.dart';
import 'package:torah_share/translations/locale_keys.g.dart';
import 'package:torah_share/utils/util_exporter.dart';
import 'package:torah_share/utils/widgets/widgets_exporter.dart';

class VideoSamplesForApproval extends StatefulWidget {
  const VideoSamplesForApproval({Key key}) : super(key: key);

  @override
  _VideoSamplesForApprovalState createState() =>
      _VideoSamplesForApprovalState();
}

class _VideoSamplesForApprovalState extends State<VideoSamplesForApproval> {
  File _sampleFirstVideo, _sampleSecondVideo;
  final imagePicker = ImagePicker();
  bool isLoading = false;

  UserModal _currentUser;

  @override
  void initState() {
    _getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Container(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 10.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ApplicationIcon(),
                    const SizedBox(height: 6.0),
                    Text(
                      tr(LocaleKeys.approval_form),
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 3.0),
                    Text(
                      tr(LocaleKeys.two_sample_content),
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 14.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20.0),
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            flex: 1,
                            child: _sampleFirstVideo == null
                                ? RoundVideoHolder(
                                    onPressed: () => _getVideo(0),
                                  )
                                : CustomVideoPlayer(
                                    videoURL: _sampleFirstVideo.path,
                                  ),
                          ),
                          const SizedBox(height: 10.0),
                          Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                Expanded(
                                  child: _sampleSecondVideo == null
                                      ? RoundVideoHolder(
                                          onPressed: () => _getVideo(1),
                                        )
                                      : CustomVideoPlayer(
                                          videoURL: _sampleSecondVideo.path,
                                        ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          PrimaryButton(
                            value: tr(LocaleKeys.apply),
                            onPressed: () => _processSampleVideos(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            isLoading
                ? Positioned.fill(
                    child: Container(
                      color: AppColors.blackColor.withOpacity(0.25),
                    ),
                  )
                : const SizedBox.shrink(),
            isLoading
                ? Positioned.fill(
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            AppColors.primary),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  void _processSampleVideos() async {
    //check if all three sample videos are provided by the user otherwise ask user to do so
    if (_sampleFirstVideo == null || _sampleSecondVideo == null) {
      Common.showSnackBar(tr(LocaleKeys.two_videos_show_work),
          tr(LocaleKeys.choose_video_admin_approve_after_verification));
      return;
    }

    setState(() {
      isLoading = true;
    });

    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    // get questions / answers from shared preference
    List<String> questions = [], answers = [], videos = [];

    // upload videos to storage and store link in videos list
    int milliSeconds = Common.getCurrentTimeInMilliseconds();

    Reference ref = FirebaseStorage.instance
        .ref()
        .child(Common.approvalsCollection)
        .child(_currentUser.userID)
        .child(milliSeconds.toString());

    await ref.putFile(_sampleFirstVideo).then((taskSnapshot) async {
      Common.showProgressDialog(
          context: context, progressTitle: tr(LocaleKeys.uploading_videos));
      videos.add(await taskSnapshot.ref.getDownloadURL());
    });

    await ref.putFile(_sampleSecondVideo).then((taskSnapshot) async {
      videos.add(await taskSnapshot.ref.getDownloadURL());
    });

    if (videos.length == 2) {
      questions = _sharedPreferences.getStringList(Common.sharedQuestionsList);
      answers = _sharedPreferences.getStringList(Common.sharedAnswersList);

      // store video and questions in modal
      DocumentReference approvalsReference = FirebaseFirestore.instance
          .collection(Common.approvalsCollection)
          .doc();

      Approval approval = new Approval(
        id: approvalsReference.id,
        answers: answers,
        questions: questions,
        videos: videos,
        updatedOn: Common.getCurrentTimeInMilliseconds().toDouble(),
        userId: _currentUser.userID,
        pendingApproval: true,
      );

      // push to approvals collection
      await approvalsReference.set(approval.toJson());

      await Common.deleteQuestionsAnswersSharedPrefs();

      setState(() {
        isLoading = false;
      });

      //once all uploads are complete,
      Get.offAllNamed(AppRoutes.homeRoute);
    }
  }

  void _getCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    _currentUser = await ApiRequests.getUser(user.uid);
    setState(() {});
  }

  _getVideo(int videoCount) async {
    PickedFile pickedVideo =
        await ImagePicker().getVideo(source: ImageSource.gallery);
    if (videoCount == 0)
      _sampleFirstVideo = File(pickedVideo.path);
    else if (videoCount == 1) _sampleSecondVideo = File(pickedVideo.path);
    setState(() {});
  }
}
