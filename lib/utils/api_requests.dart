import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:torah_share/modals/modals_exporter.dart';
import 'package:torah_share/screens/routes/routes_exporter.dart';
import 'package:torah_share/screens/views_exporter.dart';
import 'package:torah_share/utils/util_exporter.dart';

class ApiRequests {
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  static Future<bool> isUserLoggedIn() async {
    if (firebaseAuth.currentUser != null)
      return true;
    else
      return false;
  }

  static Future<bool> loginUserWithEmail(String email, String password) async {
    final result = await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    if (result.user != null)
      return true;
    else
      return false;
  }

  static Future<UserModal> getUser(String userID) async {
    try {
      DocumentSnapshot userSnapshot = await firebaseFirestore
          .collection(Common.usersCollection)
          .doc(userID)
          .get();
      return UserModal.fromJson(userSnapshot.data());
    } catch (e) {
      throw (e);
    }
  }

  static Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  static Future<Approval> isApprovalRequestSent(String userID) async {
    try {
      var approvalCollection = await firebaseFirestore
          .collection(Common.approvalsCollection)
          .where("user_id", isEqualTo: userID)
          .where("pending_approval", isEqualTo: true)
          .get();
      if (approvalCollection.docs.length >= 1) {
        for (var elements in approvalCollection.docs) {
          return Approval.fromJson(elements.data());
        }
      } else
        return Approval(pendingApproval: false);
    } catch (e) {
      throw (e);
    }
  }

  static Future<List<Follower>> getFollowersList(String currentUserID) async {
    List<Follower> followersList = [];
    final followersResponse = await firebaseFirestore
        .collection(Common.followersCollection)
        .where("following_id", isEqualTo: currentUserID)
        .get();
    followersResponse.docs.forEach((follower) {
      followersList.add(Follower.fromJson(follower.data()));
    });
    return followersList;
  }

  static Future<bool> shareVideoWithFollowers(
      String videoID,
      String currentUserID,
      String videoURL,
      String thumbnailURL,
      String caption) async {
    // get all followers of current user
    try {
      List<Follower> followers =
          await ApiRequests.getFollowersList(currentUserID);
      if (followers == null || followers.length == 0) {
        // ask client if no follower message need to be displayed or not !
        return false;
      }

      // iterator each follower and make chat with all followers
      followers.forEach((follower) async {
        final followerUser = await ApiRequests.getUser(follower.followerId);
        if (!followerUser.takeInboxShares) return false;
        // get id of chat
        // if not exist, create one
        String inboxID =
            await ApiRequests.getInboxID(currentUserID, follower.followerId);

        // share video with this inbox id
        DocumentReference shareReference = firebaseFirestore
            .collection(Common.inboxCollection)
            .doc(inboxID)
            .collection(Common.sharesCollection)
            .doc();

        // add shared video with chat id
        Shares shares = new Shares(
          id: shareReference.id,
          senderId: currentUserID,
          inboxId: inboxID,
          videoUrl: videoURL,
          thumbnailUrl: thumbnailURL,
          videoID: videoID,
          createdOn: Common.getCurrentTimeInMilliseconds().toDouble(),
          isVideo: true,
        );

        // pushing shares
        await shareReference.set(shares.toJson());

        // add last caption and time to the inbox
        await ApiRequests.updateInbox(inboxID, caption, true);

        List<String> participants = [];
        participants.add(currentUserID);
        participants.add(follower.followerId);

        // send notification
        final sender = await ApiRequests.getUser(currentUserID);
        await ApiRequests.sendNotification(
          follower.followerId,
          currentUserID,
          "${sender.username} share a video with you $caption",
          sender.username,
          inboxID,
          followerUser.deviceToken,
          Common.videoCloudSharedNotification,
        );
      });

      return true;
    } catch (e) {
      throw (e);
    }
  }

  static Future<String> getInboxID(
      String currentUserID, String followerId) async {
    final inboxResponse = await firebaseFirestore
        .collectionGroup(Common.participantsCollection)
        .where("user_id", isEqualTo: currentUserID)
        .where("other_user_id", isEqualTo: followerId)
        .get();

    // create if not exists and get id
    if (inboxResponse.docs.length < 1) {
      // no inbox, create inbox now
      String chatID =
          await ApiRequests.createInboxAndGetInboxID(currentUserID, followerId);
      return chatID;
    }
    //inbox available return its id
    final participant = Participants.fromJson(inboxResponse.docs[0].data());

    // update the inbox last activity time to take it above in chats
    await firebaseFirestore
        .collection(Common.inboxCollection)
        .doc(participant.inboxId)
        .update({
      "last_activity_at": Common.getCurrentTimeInMilliseconds().toDouble(),
      "is_last_video": true
    });

    return participant.inboxId;
  }

  static Future<String> createInboxAndGetInboxID(
      String currentUserID, String otherUserID) async {
    DocumentReference inboxReference =
        firebaseFirestore.collection(Common.inboxCollection).doc();

    List<String> _participants = [];
    _participants.add(currentUserID);
    _participants.add(otherUserID);
    InboxModal inboxModal = InboxModal(
      id: inboxReference.id,
      createdOn: Common.getCurrentTimeInMilliseconds().toDouble(),
      isLastVideo: true,
      participants: _participants,
      createdBy: currentUserID,
      lastActivityAt: Common.getCurrentTimeInMilliseconds().toDouble(),
    );
    await inboxReference.set(inboxModal.toJson());

    // add participants
    await ApiRequests.addParticipantsToInbox(
        inboxReference.id, currentUserID, otherUserID);
    return inboxReference.id;
  }

  static Future<bool> addParticipantsToInbox(
      String inboxID, String currentUserID, String otherUserID) async {
    DocumentReference currentParticipantReference = firebaseFirestore
        .collection(Common.inboxCollection)
        .doc(inboxID)
        .collection(Common.participantsCollection)
        .doc();
    DocumentReference otherParticipantReference = firebaseFirestore
        .collection(Common.inboxCollection)
        .doc(inboxID)
        .collection(Common.participantsCollection)
        .doc();

    Participants currentParticipant = new Participants(
      id: currentParticipantReference.id,
      userId: currentUserID,
      otherUserId: otherUserID,
      createdOn: Common.getCurrentTimeInMilliseconds().toDouble(),
      inboxId: inboxID,
    );

    Participants otherParticipant = new Participants(
      id: otherParticipantReference.id,
      userId: otherUserID,
      otherUserId: currentUserID,
      createdOn: Common.getCurrentTimeInMilliseconds().toDouble(),
      inboxId: inboxID,
    );

    await currentParticipantReference.set(currentParticipant.toJson());
    await otherParticipantReference.set(otherParticipant.toJson());
    return true;
  }

  static void videoUploadOptions(
      bool isProfileVerified, bool approvalRequestSent, String videoURL) {
    // check the status of user account
    // if verified then take user to capture video route
    if (isProfileVerified)
      Get.toNamed(AppRoutes.captureVideoRoute);
    else {
      // if approval request already sent to the admin then take user to video not approved route
      // if user is not verified and no approval request pending then take user to questions route and send verification request of user to admin
      if (approvalRequestSent)
        Get.toNamed(
          AppRoutes.videoNotApprovedRoute,
          arguments: VideoNotApproved(videoURL: videoURL),
        );
      else
        Get.toNamed(AppRoutes.questionsRoute);
    }
  }

  static Future<void> sendNotification(
    String receiverID,
    String senderID,
    String message,
    String senderUsername,
    String inboxID,
    String receiverDeviceToken,
    String type,
  ) async {
    DocumentReference notificationReference =
        firebaseFirestore.collection(Common.notificationsCollection).doc();
    DocumentReference cloudNotificationReference =
        firebaseFirestore.collection(Common.cloudNotificationsCollection).doc();

    Notifications notification = new Notifications(
      notificationId: notificationReference.id,
      inboxId: inboxID,
      message: message,
      notificationFrom: senderID,
      notificationFor: receiverID,
      isRead: false,
      createdOn: Common.getCurrentTimeInMilliseconds().toDouble(),
    );

    CloudNotification cloudNotification = new CloudNotification(
      id: cloudNotificationReference.id,
      message: message,
      senderId: senderID,
      receiverId: receiverID,
      receiverDeviceToken: receiverDeviceToken,
      inboxId: inboxID,
      type: type,
      createdOn: Common.getCurrentTimeInMilliseconds().toDouble(),
    );

    await notificationReference.set(notification.toJson());
    await cloudNotificationReference.set(cloudNotification.toJson());
  }

  static Future<bool> makeShareNotificationIsRead(String notificationID) async {
    await firebaseFirestore
        .collection(Common.notificationsCollection)
        .doc(notificationID)
        .update({
      "is_read": true,
    });
    return true;
  }

  static Future<bool> updateInbox(
      String inboxID, String message, bool isLastVideo) async {
    await firebaseFirestore
        .collection(Common.inboxCollection)
        .doc(inboxID)
        .update({
      "last_activity_at": Common.getCurrentTimeInMilliseconds().toDouble(),
      "last_message": message,
      "is_last_video": isLastVideo
    });
    return true;
  }

  static Future<String> messageShare(
      String message, String senderID, String inboxID) async {
    DocumentReference shareReference = firebaseFirestore
        .collection(Common.inboxCollection)
        .doc(inboxID)
        .collection(Common.sharesCollection)
        .doc();

    Shares shares = new Shares(
      id: shareReference.id,
      message: message,
      senderId: senderID,
      inboxId: inboxID,
      createdOn: Common.getCurrentTimeInMilliseconds().toDouble(),
      isVideo: false,
    );

    await shareReference.set(shares.toJson());
    return shareReference.id;
  }

  static Future<void> makeComment(
      String videoID,
      String message,
      String commenterID,
      String commenterUsername,
      String commenterImageURL) async {
    DocumentReference commentsReference =
        firebaseFirestore.collection(Common.commentsCollection).doc();
    Comments comments = new Comments(
      id: commentsReference.id,
      message: message,
      videoId: videoID,
      commenterId: commenterID,
      createdOn: Common.getCurrentTimeInMilliseconds().toDouble(),
    );
    await commentsReference.set(comments.toJson());
    return;
  }

  static Future<void> followUser(String followerID, String followingID) async {
    DocumentReference followersReference =
        firebaseFirestore.collection(Common.followersCollection).doc();
    Follower follower = new Follower(
      id: followersReference.id,
      followingId: followingID,
      followerId: followerID,
      createdOn: Common.getCurrentTimeInMilliseconds().toDouble(),
    );
    await followersReference.set(follower.toJson());
    return;
  }

  static Future<void> unFollowUser(
      String followerID, String followingID) async {
    final followerDocument = await firebaseFirestore
        .collection(Common.followersCollection)
        .where("following_id", isEqualTo: followingID)
        .where("follower_id", isEqualTo: followerID)
        .get();
    followerDocument.docs.forEach((followerResponse) async {
      Follower follower = new Follower.fromJson(followerResponse.data());
      await firebaseFirestore
          .collection(Common.followersCollection)
          .doc(follower.id)
          .delete();
    });
    return;
  }

  static Future<void> uploadProfileImage(String userID) async {
    File _image;
    // take user image from gallery
    _image = await Common.getImageFromGallery();
    if (_image == null) return;
    // upload image to storage
    //upload video and take url
    Reference ref = FirebaseStorage.instance
        .ref()
        .child(Common.usersCollection)
        .child("Profile Pictures")
        .child(userID)
        .child(userID);

    UploadTask uploadTask = ref.putFile(_image);
    String imageURL;
    // get url from the storage
    uploadTask.then((value) async {
      imageURL = await value.ref.getDownloadURL();
      // update profile in database
      await ApiRequests.updateProfileImageInCollections(userID, imageURL);
      return;
    }).onError(
      (error, stackTrace) => throw (error),
    );
  }

  static Future<void> updateProfileImageInCollections(
      String userID, String imageURL) async {
    //upload video content to fire store
    // update user image in collection
    await firebaseFirestore
        .collection(Common.usersCollection)
        .doc(userID)
        .update({"profileImageURL": imageURL}).onError(
      (error, stackTrace) => throw (error),
    );
    return;
  }

  static Future<bool> updateProfileSendModeStatus(
      String userID, bool isPrivate) async {
    await firebaseFirestore
        .collection(Common.usersCollection)
        .doc(userID)
        .update({"takeInboxShares": isPrivate});
    return true;
  }

  static Future<bool> updateProfileChatModeStatus(
      String userID, bool isPrivate) async {
    await firebaseFirestore
        .collection(Common.usersCollection)
        .doc(userID)
        .update({"takeInboxMessages": isPrivate});
    return true;
  }

  static Future<bool> googleLogin() async {
    try {
      GoogleSignInAccount googleSignInAccount = await GoogleSignIn().signIn();
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      AuthCredential authCredential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );
      await firebaseAuth.signInWithCredential(authCredential);
      if (!await ApiRequests.userRecordExistInFirestore(
          Common.usersCollection, firebaseAuth.currentUser.uid)) {
        User currentUser = firebaseAuth.currentUser;
        UserModal userModal = UserModal(
          userID: currentUser.uid,
          username: googleSignInAccount.displayName,
          email: googleSignInAccount.email,
          profileImageUrl: googleSignInAccount.photoUrl,
          aboutMe: "",
          isProfileVerified: false,
          searchQueries:
              Common.getSearchQueries(googleSignInAccount.displayName),
          takeInboxShares: true,
        );

        await firebaseFirestore
            .collection(Common.usersCollection)
            .doc(currentUser.uid)
            .set(userModal.toJson());
      }
      return true;
    } catch (e) {
      throw (e);
    }
  }

  static userRecordExistInFirestore(String collection, String userID) async {
    try {
      var reference =
          await firebaseFirestore.collection(collection).doc(userID).get();
      return reference.exists;
    } catch (e) {
      throw (e);
    }
  }

  static Future<void> updateDeviceToken(
      String userID, String deviceToken) async {
    await firebaseFirestore
        .collection(Common.usersCollection)
        .doc(userID)
        .update({"device_token": deviceToken});
    return;
  }

  static Future<void> deleteDeviceToken(String userID) async {
    await firebaseFirestore
        .collection(Common.usersCollection)
        .doc(userID)
        .update({
      "device_token": FieldValue.delete(),
    });
    return;
  }

  static Future<void> sendSelfContactNotification(
      String message, UserModal user, String contactName) async {
    DocumentReference selfContactNotificationReference =
        firebaseFirestore.collection(Common.notificationsCollection).doc();
    // send self notification about this contact shared
    Notifications notifications = new Notifications(
      notificationId: selfContactNotificationReference.id,
      message: message,
      contactName: contactName,
      notificationFor: user.userID,
      isRead: false,
      selfNotification: true,
      createdOn: Common.getCurrentTimeInMilliseconds().toDouble(),
    );
    await firebaseFirestore
        .collection(Common.notificationsCollection)
        .doc(selfContactNotificationReference.id)
        .set(notifications.toJson());
    return;
  }

  static Future<AdEngineModal> getVideoAd() async {
    final adResponse = await firebaseFirestore
        .collection(Common.adEngineCollection)
        .limit(1)
        .get();
    return AdEngineModal.fromJson(adResponse.docs[0].data());
  }

  static Future<void> deleteVideoInComments(String videoID) async {
    final videoCommentsResponse = await firebaseFirestore
        .collection(Common.commentsCollection)
        .where("video_id", isEqualTo: videoID)
        .get();
    if (videoCommentsResponse.docs.length == 0)
      return;
    else {
      videoCommentsResponse.docs.forEach((element) async {
        // delete all comments of the video
        Comments comments = Comments.fromJson(element.data());
        await firebaseFirestore
            .collection(Common.commentsCollection)
            .doc(comments.id)
            .delete();
      });
    }
  }

  static Future<void> deleteVideoInVideos(String videoID) async {
    await firebaseFirestore
        .collection(Common.videosCollection)
        .doc(videoID)
        .delete();
    return;
  }

  static Future<void> deleteVideoInShares(String videoID) async {
    final videoSharesResponse = await firebaseFirestore
        .collection(Common.sharesCollection)
        .where("is_video", isEqualTo: true)
        .where("video_id", isEqualTo: videoID)
        .get();
    if (videoSharesResponse.docs.length == 0)
      return;
    else {
      videoSharesResponse.docs.forEach((element) async {
        // delete all comments of the video
        Shares shares = Shares.fromJson(element.data());
        await firebaseFirestore
            .collection(Common.commentsCollection)
            .doc(shares.id)
            .delete();
      });
    }
    return;
  }

  static Future<void> deleteVideoResourcesFromStorage(
      String videoURL, String thumbnailURL) async {
    FirebaseStorage storage = FirebaseStorage.instance;

    // delete thumbnail
    await storage.refFromURL(thumbnailURL).delete();
    // delete video
    await FirebaseStorage.instance.refFromURL(videoURL).delete();
    return;
  }

  static Future<void> sendVideoReport(String username, String videoID,
      String videoUploaderID, String reporterID) async {
    DocumentReference reportVideoReference =
        firebaseFirestore.collection(Common.reportVideoCollection).doc();

    ReportVideo reportVideo = new ReportVideo(
      id: reportVideoReference.id,
      message: "$username reported the video. Please Investigate the report",
      videoId: videoID,
      videoUploaderId: videoUploaderID,
      isReportResolved: false,
      lastActivityOn: Common.getCurrentTimeInMilliseconds().toDouble(),
      createdOn: Common.getCurrentTimeInMilliseconds().toDouble(),
      reportedBy: reporterID,
    );

    try {
      firebaseFirestore
          .collection(Common.reportVideoCollection)
          .doc(reportVideoReference.id)
          .set(reportVideo.toJson());
      return;
    } on Exception catch (e) {
      throw (e);
    }
  }

  static Future<Video> getVideo(String videoID) async {
    try {
      final videoResponse = await firebaseFirestore
          .collection(Common.videosCollection)
          .doc(videoID)
          .get();
      return Video.fromJson(videoResponse.data());
    } on Exception catch (e) {
      throw (e);
    }
  }

  static Future<bool> isUserFollowing(String followed, String following) async {
    try {
      final followerResponse = await firebaseFirestore
          .collection(Common.followersCollection)
          .where('follower_id', isEqualTo: followed)
          .where('following_id', isEqualTo: following)
          .get();
      if (followerResponse.docs.length >= 1)
        return true;
      else
        return false;
    } on Exception catch (e) {
      throw (e);
    }
  }

  static Future<void> updateUsername(String userID, String username) async {
    try {
      await FirebaseAuth.instance.currentUser.updateDisplayName(username);
      await firebaseFirestore
          .collection(Common.usersCollection)
          .doc(userID)
          .update({
        "username": username,
        "search_queries": Common.getSearchQueries(username),
      });
    } on Exception catch (e) {
      throw (e);
    }
  }

  static Future<void> updateAboutMe(String userID, String aboutMe) async {
    try {
      await firebaseFirestore
          .collection(Common.usersCollection)
          .doc(userID)
          .update({
        "about_me": aboutMe,
      });
    } on Exception catch (e) {
      throw (e);
    }
  }

  static Future<void> updateEmailAddress(
      String userID, String emailAddress) async {
    try {
      final _currentUser = FirebaseAuth.instance.currentUser;
      _currentUser.updateEmail(emailAddress);
      // first update email with firebase auth
      await firebaseFirestore
          .collection(Common.usersCollection)
          .doc(userID)
          .update({
        "email": emailAddress,
      });
    } on FirebaseAuthException catch (e) {
      throw (e);
    }
  }

  static Future<void> makeSubComment(String mainCommentID, String message,
      String commenterID, String videoID) async {
    DocumentReference subCommentsReference = firebaseFirestore
        .collection(Common.commentsCollection)
        .doc(mainCommentID)
        .collection(Common.subCommentsCollection)
        .doc();
    SubComment subComment = new SubComment(
      id: subCommentsReference.id,
      message: message,
      commenterId: commenterID,
      videoId: videoID,
      mainCommentId: mainCommentID,
      createdOn: Common.getCurrentTimeInMilliseconds().toDouble(),
    );
    await subCommentsReference.set(subComment.toJson());
    return;
  }

  static Future<InboxModal> getInbox(String inboxID) async {
    try {
      final inboxResponse = await firebaseFirestore
          .collection(Common.inboxCollection)
          .doc(inboxID)
          .get();
      return InboxModal.fromJson(inboxResponse.data());
    } on Exception catch (e) {
      throw (e);
    }
  }
}
