import 'package:flutter/material.dart';
import 'package:torah_share/screens/views_exporter.dart';

import '../../../utils/widgets/widgets_exporter.dart';

class Home extends StatefulWidget {
  final int index;
  final List<Widget> screens;

  const Home({
    Key key,
    this.index,
    this.screens,
  }) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _index = 2;
  List<Widget> _screens = [
    Search(),
    Share(),
    CurrentUserProfile(),
  ];

  @override
  void initState() {
    //check if constructor contains new screens to show
    if (widget.screens != null) {
      _screens = widget.screens;
      _index = widget.index;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FluidBottomNavigationBar(
      currentIndex: _index,
      currentScreen: _screens[_index],
      onScreenChanged: (int index) {
        setState(() {
          _index = index;
        });
      },
    );
  }
}
