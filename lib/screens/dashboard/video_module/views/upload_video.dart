import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:torah_share/modals/modals_exporter.dart';
import 'package:torah_share/screens/views_exporter.dart';
import 'package:torah_share/translations/locale_keys.g.dart';
import 'package:torah_share/utils/util_exporter.dart';
import 'package:torah_share/utils/widgets/widgets_exporter.dart';

class UploadVideo extends StatefulWidget {
  final String videoURL;

  const UploadVideo({
    Key key,
    @required this.videoURL,
  }) : super(key: key);

  @override
  _UploadVideoState createState() => _UploadVideoState();
}

class _UploadVideoState extends State<UploadVideo> {
  List<String> tagsList = [];
  List<String> searchTagsList = [];

  final _tagsTextController = TextEditingController();
  TextEditingController captionController = new TextEditingController();
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
    return Container(
      width: size.width,
      height: size.height,
      child: Stack(
        children: [
          Scaffold(
              backgroundColor: AppColors.primary,
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 20.0),
                    child: CustomAppBar(
                      textChild:
                          LargeWhiteBoldText(value: tr(LocaleKeys.upload)),
                      willPop: true,
                      hasIconAndTextWhiteTheme: true,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(40.0),
                                topLeft: Radius.circular(40.0),
                              ),
                            ),
                            padding: EdgeInsets.all(13.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(40.0),
                                topLeft: Radius.circular(40.0),
                              ),
                              child:
                                  CustomVideoPlayer(videoURL: widget.videoURL),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: SizedBox(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              bottomSheet: CustomBottomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ButtonIcon(
                      localImage: "${Common.assetsIcons}indicator_slider.png",
                      width: 50.0,
                    ),
                    const SizedBox(height: 20.0),
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          LargePrimaryBoldText(
                            value: tr(LocaleKeys.write_a_caption),
                            textAlign: TextAlign.start,
                          ),
                          const SizedBox(height: 15.0),
                          PrimaryField(
                            hint: tr(LocaleKeys.enter_your_caption_here),
                            keyboardType: TextInputType.text,
                            backgroundColor: AppColors.whiteColor,
                            controller: captionController,
                          ),
                          const SizedBox(height: 5.0),
                          PrimaryField(
                            hint: tr(LocaleKeys.enter_hashtag),
                            keyboardType: TextInputType.text,
                            backgroundColor: AppColors.whiteColor,
                            controller: _tagsTextController,
                            suffixIcon: InkWell(
                              onTap: () =>
                                  _tagsTextController.text.trim().isEmpty ||
                                          tagsList.length > 6
                                      ? _tagsTextController.clear()
                                      : _addHashtag(
                                          _tagsTextController.text.trim(),
                                        ),
                              child: Icon(
                                FontAwesomeIcons.plusCircle,
                                size: 18.0,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          _displayTags(),
                          const SizedBox(height: 40.0),
                          PrimaryButton(
                            value: tr(LocaleKeys.upload),
                            onPressed: () => _processUpload(),
                          ),
                          const SizedBox(height: 5.0),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
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
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  void _addHashtag(String hashTag) {
    _tagsTextController.clear();
    setState(() {
      tagsList.add("#" + hashTag);
      searchTagsList.add(hashTag);
    });
  }

  _displayTags() {
    if (tagsList == null || tagsList.isEmpty) {
      return _buildTag(tag: tr(LocaleKeys.NoHashtag));
    } else {
      return renderTags();
    }
  }

  Widget renderTags() {
    List<Widget> list = [];
    for (var i = 0; i < tagsList.length; i++) {
      list.add(_buildTag(tag: tagsList[i]));
    }
    return Wrap(children: list);
  }

  _buildTag({String tag}) {
    return Container(
      margin: EdgeInsets.only(right: 4.0),
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.grey[200],
      ),
      child: Text(
        tag,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 16.0,
        ),
      ),
    );
  }

  void _processUpload() async {
    //caption is must
    if (captionController.text.trim() == null ||
        captionController.text.trim().isEmpty) {
      Common.showSnackBar(
          tr(LocaleKeys.video_caption_required),
          tr(LocaleKeys
              .please_enter_suitable_caption_for_your_video_before_uploading));
      return;
    } else if (tagsList == null || tagsList.isEmpty || tagsList.length == 0) {
      Common.showSnackBar(
          tr(LocaleKeys.tags_are_required),
          tr(LocaleKeys
              .please_enter_at_least_one_tag_to_process_uploading_video));
      return;
    }

    setState(() {
      FocusScope.of(context).unfocus();
      isLoading = true;
    });

    String videoURL, thumbnailURL;
    DocumentReference videoReference =
        FirebaseFirestore.instance.collection(Common.videosCollection).doc();

    //get thumbnail and upload to storage
    File videoThumbnail = await Common.getThumbnail(widget.videoURL);

    Reference videoThumbnailStorageReference = FirebaseStorage.instance
        .ref()
        .child("Video-Thumbnails")
        .child(_currentUser.userID)
        .child(videoReference.id);
    Reference videoStorageReference = FirebaseStorage.instance
        .ref()
        .child(Common.videosCollection)
        .child(_currentUser.userID)
        .child(videoReference.id);

    final thumbnailUpload =
        await videoThumbnailStorageReference.putFile(videoThumbnail);
    thumbnailURL = await thumbnailUpload.ref.getDownloadURL();

    //upload video and take url
    final videoUpload =
        await videoStorageReference.putFile(File(widget.videoURL));
    videoURL = await videoUpload.ref.getDownloadURL();

    List<String> searchQueryList = [];
    searchTagsList.forEach((element) {
      final queryList = Common.getSearchQueries(element.toLowerCase());
      queryList.forEach((element) {
        searchQueryList.add(element);
      });
    });

    //upload video content to fire store
    Video videoModal = Video(
      videoId: videoReference.id,
      uploaderId: _currentUser.userID,
      caption: captionController.text.trim().toString(),
      tags: tagsList,
      searchQueries: searchQueryList,
      videoUrl: videoURL,
      thumbnailURL: thumbnailURL,
      createdOn: Common.getCurrentTimeInMilliseconds().toDouble(),
    );
    await videoReference.set(videoModal.toJson());
    setState(() {
      isLoading = false;
    });

    //move user to route once uploading is done
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => ShareVideo(video: videoModal),
      ),
    );
  }

  void _getCurrentUser() {
    final user = FirebaseAuth.instance.currentUser;
    ApiRequests.getUser(user.uid).then((value) {
      setState(() {
        _currentUser = value;
      });
    });
  }
}
