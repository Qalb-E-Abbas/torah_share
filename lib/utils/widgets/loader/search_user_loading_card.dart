import 'package:flutter/material.dart';
import 'package:torah_share/utils/widgets/widgets_exporter.dart';

class SearchUserLoadingCard extends StatelessWidget {
  const SearchUserLoadingCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Stack(
              children: [
                LoadingHolder(
                  child: Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10.0),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LoadingHolder(
                  child: Container(
                    color: Colors.white,
                    height: 16.0,
                  ),
                ),
                const SizedBox(height: 5.0),
                LoadingHolder(
                  child: Container(
                    color: Colors.white,
                    height: 16.0,
                    width: 150.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
