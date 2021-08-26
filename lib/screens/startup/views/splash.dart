import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:torah_share/screens/routes/routes_exporter.dart';
import 'package:torah_share/utils/util_exporter.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    _runSplash();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(
            "assets/icons/application_icon.png",
            height: 150.0,
          ),
          Text(
            Common.applicationName,
            style: Styles.largeWhiteBoldTS(),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _runSplash() async {
    //check firebase auth logged in status
    bool isLoggedIn = await ApiRequests.isUserLoggedIn();
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        isLoggedIn
            ? Get.offAndToNamed(AppRoutes.homeRoute)
            : Get.offAndToNamed(AppRoutes.signupRoute);
      });
    });
  }
}
