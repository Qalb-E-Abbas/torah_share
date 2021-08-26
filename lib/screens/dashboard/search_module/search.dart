import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:torah_share/modals/modals_exporter.dart';
import 'package:torah_share/screens/views_exporter.dart';
import 'package:torah_share/translations/locale_keys.g.dart';
import 'package:torah_share/utils/util_exporter.dart';
import 'package:torah_share/utils/widgets/widgets_exporter.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController _searchUserController = new TextEditingController();
  String _toBeSearched = "";
  bool _searchAvailable = false, _searchByVideos = false, _searchByUsers = true;
  UserModal _currentUser;

  @override
  void initState() {
    _searchUserController.addListener(() {
      _toBeSearched = _searchUserController.text.trim();
      setState(() {});
    });
    getCurrentUser();
    super.initState();
  }

  @override
  void dispose() {
    _searchUserController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
        child: PrimaryCard(
          verticalPadding: 6.0,
          horizontalPadding: 8.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _searchUserController.clear(),
                      child: Image.asset(
                        Common.assetsIcons + "close.png",
                        height: 22.0,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: TextFormField(
                      controller: _searchUserController,
                      decoration: InputDecoration.collapsed(
                        hintText: (_searchByVideos && _searchByUsers)
                            ? tr(LocaleKeys.username_video_tag_to_search)
                            : _searchByUsers
                                ? tr(LocaleKeys.type_username_to_search)
                                : _searchByVideos
                                    ? tr(LocaleKeys.type_tag_of_video_to_search)
                                    : tr(
                                        LocaleKeys.please_add_filter_to_search),
                      ),
                    ),
                  ),
                  Expanded(
                    child: CustomBorderCard(
                      onPressed: () => _toggleFilterBottomSheet(),
                      cardPadding: const EdgeInsets.all(12.0),
                      color: AppColors.backgroundColor,
                      child:
                          Image.asset(Common.assetsIcons + "menu_settings.png",
                            height:  MediaQuery.of(context).size.height * 0.027
                          ),
                    ),
                  ),
                ],
              ),
              _searchByUsers
                  ? StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection(Common.usersCollection)
                          .where("search_queries", arrayContains: _toBeSearched)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          _searchAvailable = false;
                          return const SizedBox();
                        }
                        if (snapshot.data.docs.length == 0) {
                          _searchAvailable = false;
                          return SizedBox();
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.docs.length,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            DocumentSnapshot searchedUser =
                                snapshot.data.docs[index];
                            UserModal user =
                                UserModal.fromJson(searchedUser.data());
                            if (user.userID == _currentUser.userID) {
                              _searchAvailable = false;
                              return const SizedBox();
                            }
                            _searchAvailable = true;
                            return Container(
                              padding:
                                  const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                              child: SearchUserTileCard(
                                userID: user.userID,
                                imageURL: user.profileImageUrl,
                                onPressed: () => Get.to(
                                  Home(
                                    screens: [
                                      OtherUserProfile(userID: user.userID),
                                      Share(),
                                      CurrentUserProfile(),
                                    ],
                                    index: 0,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    )
                  : const SizedBox.shrink(),
              _searchByVideos
                  ? Column(
                      children: [
                        _searchAvailable
                            ? const SizedBox(height: 10.0)
                            : const SizedBox.shrink(),
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection(Common.videosCollection)
                              .where("search_queries",
                                  arrayContains: "#" + _toBeSearched)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              _searchAvailable = false;
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15.0),
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
                              );
                            }
                            if (snapshot.data.docs.length == 0) {
                              _searchAvailable = false;
                              return const SizedBox();
                            }
                            _searchAvailable = true;
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data.docs.length,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                DocumentSnapshot searchedVideo =
                                    snapshot.data.docs[index];
                                Video video =
                                    Video.fromJson(searchedVideo.data());
                                return Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      10.0, 0.0, 10.0, 0.0),
                                  child: ThumbnailHolder(
                                    url: video.thumbnailURL,
                                    videoURL: video.videoUrl,
                                    bottomMargin: 15.0,
                                  ),
                                );
                              },
                            );
                          },
                        )
                      ],
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  void getCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    _currentUser = await ApiRequests.getUser(user.uid);
    setState(() {});
  }

  void _toggleFilterBottomSheet() {
    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setModalState) {
          return CustomBottomCard(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                ButtonIcon(
                  localImage: "${Common.assetsIcons}indicator_slider.png",
                  width: 50.0,
                ),
                const SizedBox(height: 8.0),
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      LargePrimaryBoldText(
                        value: tr(LocaleKeys.filters),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 30.0),
                      Row(
                        children: [
                          Expanded(
                            child: FilterToggleCard(
                              onPressed: () =>
                                  _toggleVideoSearch(setModalState),
                              assetName: 'video_search.png',
                              title: tr(LocaleKeys.by_videos),
                              isSelected: _searchByVideos,
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: FilterToggleCard(
                              onPressed: () => _toggleUserSearch(setModalState),
                              assetName: 'user_search.png',
                              title: tr(LocaleKeys.by_users),
                              isSelected: _searchByUsers,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30.0),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _toggleVideoSearch(StateSetter setModalState) {
    // if both will be removed then show snackbar that one filter is must
    if (!_searchByVideos == false && _searchByUsers == false) {
      Common.showSnackBar(tr(LocaleKeys.one_filter_is_must),
          tr(LocaleKeys.you_can_not_remove_both_filters));
      return;
    }
    setModalState(() {
      _searchByVideos = !_searchByVideos;
    });
    setState(() {});
  }

  void _toggleUserSearch(StateSetter setModalState) {
    // if both will be removed then show snackbar that one filter is must
    if (_searchByVideos == false && !_searchByUsers == false) {
      Common.showSnackBar(tr(LocaleKeys.one_filter_is_must),
          tr(LocaleKeys.you_can_not_remove_both_filters));
      return;
    }
    setModalState(() {
      _searchByUsers = !_searchByUsers;
    });
    setState(() {});
  }
}

class SearchUserTileCard extends StatefulWidget {
  final String imageURL, userID;
  final Function onPressed;

  const SearchUserTileCard({
    Key key,
    @required this.imageURL,
    @required this.userID,
    @required this.onPressed,
  }) : super(key: key);

  @override
  _SearchUserTileCardState createState() => _SearchUserTileCardState();
}

class _SearchUserTileCardState extends State<SearchUserTileCard> {
  bool _isLoading = true;
  UserModal _searchedUser;

  @override
  void initState() {
    _getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? SearchUserLoadingCard()
        : InkWell(
            onTap: widget.onPressed,
            child: Container(
              margin: const EdgeInsets.only(bottom: 15.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Stack(
                      children: [
                        SmallCircleAvatar(userImage: widget.imageURL),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection(Common.followersCollection)
                                .where("following_id", isEqualTo: widget.userID)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData)
                                return LoadingHolder(
                                  baseColor: Colors.grey[400],
                                  child: Container(
                                    height: 20.0,
                                    width: 20.0,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    padding: const EdgeInsets.all(4.0),
                                  ),
                                );
                              return SizedBox(
                                width: 20.0,
                                height: 20.0,
                                child: LevelBadge(
                                  followersCount: snapshot.data.docs.length,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 5.0),
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LargePrimaryBoldText(
                          value: _searchedUser.username,
                          textAlign: TextAlign.start,
                        ),
                        SmallBrightPrimaryText(
                          value: "@${_searchedUser.username.toLowerCase()}",
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Future<void> _getUser() async {
    _searchedUser = await ApiRequests.getUser(widget.userID);
    _isLoading = false;
    setState(() {});
  }
}
