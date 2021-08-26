import 'package:flutter/material.dart';

class DarkOverlay extends StatelessWidget {
  final Widget child;

  const DarkOverlay({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(255, 255, 255, 0.09),
      child: child,
    );
  }
}
