import 'package:flutter/material.dart';
import 'package:torah_share/utils/util_exporter.dart';

class DraggableScrolledContainer extends StatefulWidget {
  final Widget child;
  final double initialChildSize, minChildSize, maxChildSize;

  const DraggableScrolledContainer({
    Key key,
    @required this.child,
    this.initialChildSize = 0.58,
    this.minChildSize = 0.53,
    this.maxChildSize = 0.6,
  }) : super(key: key);

  @override
  _DraggableScrolledContainerState createState() =>
      _DraggableScrolledContainerState();
}

class _DraggableScrolledContainerState
    extends State<DraggableScrolledContainer> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: widget.initialChildSize,
      minChildSize: widget.minChildSize,
      maxChildSize: widget.maxChildSize,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.backgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: widget.child,
          ),
        );
      },
    );
  }
}
