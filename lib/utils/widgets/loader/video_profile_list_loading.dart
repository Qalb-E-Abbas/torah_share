import 'package:flutter/material.dart';
import 'package:torah_share/utils/util_exporter.dart';
import 'package:torah_share/utils/widgets/widgets_exporter.dart';

class VideoProfileListLoading extends StatelessWidget {
  const VideoProfileListLoading({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 2,
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return PostCard(
          verticalPadding: 20.0,
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, right: 10.0, bottom: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    LoadingHolder(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        width: 45.0,
                        height: 45.0,
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: LoadingHolder(
                        child: Container(
                          height: 16.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12.0),
                  ],
                ),
              ),
              Divider(
                color: AppColors.backgroundColor,
                thickness: 2.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 10.0),
                    LoadingHolder(
                      child: Container(
                        height: 16.0,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
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
                  ],
                ),
              ),
              Divider(
                color: AppColors.backgroundColor,
                thickness: 2.0,
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, right: 10.0, bottom: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: LoadingHolder(
                        child: Container(
                          height: 16.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20.0),
                    Expanded(
                      child: LoadingHolder(
                        child: Container(
                          height: 16.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20.0),
                    Expanded(
                      child: LoadingHolder(
                        child: Container(
                          height: 16.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20.0),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
