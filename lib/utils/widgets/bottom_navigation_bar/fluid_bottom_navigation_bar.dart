import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:torah_share/modals/modals_exporter.dart';
import 'package:torah_share/utils/util_exporter.dart';

class FluidBottomNavigationBar extends StatefulWidget {
  final double bottomBarHeight, borderRadius, elevation;
  final bodyBackgroundColor, bottomBarBackgroundColor;
  final int currentIndex;
  final Widget currentScreen;
  final Function(int) onScreenChanged;

  const FluidBottomNavigationBar({
    Key key,
    @required this.currentIndex,
    @required this.currentScreen,
    this.onScreenChanged,
    this.bottomBarHeight = 62.0,
    this.borderRadius = 10.0,
    this.elevation = 10.0,
    this.bodyBackgroundColor = AppColors.backgroundColor,
    this.bottomBarBackgroundColor = AppColors.whiteColor,
  }) : super(key: key);
  @override
  _FluidBottomNavigationBarState createState() =>
      _FluidBottomNavigationBarState();
}

class _FluidBottomNavigationBarState extends State<FluidBottomNavigationBar> {
  bool _isLoading = false, _approvalRequestSent = false;
  String _videoURL;
  UserModal _currentUser;

  @override
  void initState() {
    _getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: widget.bodyBackgroundColor,
        body: widget.currentScreen,
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.primary,
          child: _isLoading
              ? CircularProgressIndicator(
                  valueColor:
                      new AlwaysStoppedAnimation<Color>(AppColors.primary),
                )
              : Image.asset(
                  Common.assetsIconsOutlined + "add_outline.png",
                  width: 25.0,
                ),
          onPressed: _isLoading ? null : () => _processUploadVideoOptions(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
        bottomNavigationBar: Container(
          height: widget.bottomBarHeight,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(widget.borderRadius),
              topLeft: Radius.circular(widget.borderRadius),
            ),
            child: BottomAppBar(
              notchMargin: 6.0,
              elevation: widget.elevation,
              shape: CircularNotchedRectangle(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(),
                        InkWell(
                          onTap: () => widget.onScreenChanged(0),
                          child: Image.asset(
                            "${Common.assetsIcons}${
                                widget.currentIndex == 0 ?
                                "filled/search_filled" :
                                "outlined/search_outline"}.png",
                            height: 30.0,
                          ),
                        ),
                        InkWell(
                          onTap: () => widget.onScreenChanged(1),
                          child: Image.asset(
                            "assets/icons/${widget.currentIndex == 1 ?
                            "filled/inbox_filled" :
                            "outlined/inbox_outline"}.png",
                            height: 30.0,
                          ),
                        ),
                        InkWell(
                          onTap: () => widget.onScreenChanged(2),
                          child: Image.asset(
                            "assets/icons/${widget.currentIndex == 2 ?
                            "filled/profile_filled" : "outlined/profile_outline"}.png",
                            height: 30.0,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(),
                        widget.currentIndex == 0
                            ? Padding(
                                padding: const EdgeInsets.only(right: 55.0),
                                child: Hero(
                                  tag: "Bubble",
                                  child: Image.asset(
                                    "${Common.assetsIcons}navigation_bubble.png",
                                    height: 17.0,
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                        widget.currentIndex == 1
                            ? Padding(
                                padding: const EdgeInsets.only(right: 18.0),
                                child: Hero(
                                  tag: "Bubble",
                                  child: Image.asset(
                                    "${Common.assetsIcons}navigation_bubble.png",
                                    height: 17.0,
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                        widget.currentIndex == 2
                            ? Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Image.asset(
                                  "${Common.assetsIcons}navigation_bubble.png",
                                  height:17.0,
                                ),
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _processUploadVideoOptions() async {
    ApiRequests.videoUploadOptions(
        _currentUser.isProfileVerified, _approvalRequestSent, _videoURL);
  }

  void _getCurrentUser() {
    setState(() {
      _isLoading = true;
    });

    final user = FirebaseAuth.instance.currentUser;
    ApiRequests.getUser(user.uid).then((user) async {
      ApiRequests.isApprovalRequestSent(user.userID).then((value) async {
        _isLoading = false;
        _approvalRequestSent = value.pendingApproval;
        if (value.pendingApproval) _videoURL = value.videos.first;
      });

      setState(() {
        _isLoading = false;
        _currentUser = user;
      });
    });
  }
}
