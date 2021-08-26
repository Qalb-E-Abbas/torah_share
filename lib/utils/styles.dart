import 'package:flutter/material.dart';

import '../utils/util_exporter.dart';

class Styles {
  static const double extraLargeTextSize = 24.0;
  static const double largeTextSize = 20.0;
  static const double mediumTextSize = 16.0;
  static const double smallTextSize = 14.0;
  static const double extraSmallTextSize = 10.0;

  static TextStyle largeWhiteBoldTS() {
    return TextStyle(
      color: AppColors.whiteColor,
      fontSize: largeTextSize,
      fontFamily: "NunitoSans-Bold",
    );
  }

  static TextStyle extraLargePrimaryExtraBoldTS() {
    return TextStyle(
      color: AppColors.primary,
      fontSize: extraLargeTextSize,
      fontFamily: "NunitoSans-ExtraBold",
    );
  }

  static TextStyle customTS({
    Color color = AppColors.primary,
    double textSize = extraLargeTextSize,
    String family = "NunitoSans-ExtraBold",
  }) {
    return TextStyle(
      color: color,
      fontSize: textSize,
      fontFamily: family,
    );
  }

  static TextStyle largePrimaryBoldTS() {
    return TextStyle(
      color: AppColors.primary,
      fontSize: largeTextSize,
      fontFamily: "NunitoSans-Bold",
    );
  }

  static TextStyle mediumWhiteRegularTS() {
    return TextStyle(
      color: AppColors.whiteColor,
      fontSize: mediumTextSize,
      fontFamily: "NunitoSans-Regular",
    );
  }

  static TextStyle mediumPrimaryBoldTS() {
    return TextStyle(
      color: AppColors.primary,
      fontSize: mediumTextSize,
      fontFamily: "NunitoSans-Bold",
    );
  }

  static TextStyle mediumPrimarySemiBoldTS() {
    return TextStyle(
      color: AppColors.primary,
      fontSize: mediumTextSize,
      fontFamily: "NunitoSans-SemiBold",
    );
  }

  static TextStyle mediumPrimaryRegularTS() {
    return TextStyle(
      color: AppColors.primary,
      fontSize: mediumTextSize,
      fontFamily: "NunitoSans-Regular",
    );
  }

  static TextStyle smallLightTS() {
    return TextStyle(
      color: AppColors.primary,
      fontSize: smallTextSize,
      fontFamily: "NunitoSans-Light",
    );
  }

  static TextStyle mediumBrightPrimaryBoldTS() {
    return TextStyle(
      color: AppColors.brightPrimaryColor,
      fontSize: mediumTextSize,
      fontFamily: "NunitoSans-Bold",
    );
  }

  static TextStyle smallPrimarySemiBoldTS() {
    return TextStyle(
      color: AppColors.primary,
      fontSize: smallTextSize,
      fontFamily: "NunitoSans-SemiBold",
    );
  }

  static TextStyle mediumPrimaryExtraBoldTS() {
    return TextStyle(
      color: AppColors.primary,
      fontSize: mediumTextSize,
      fontFamily: "NunitoSans-ExtraBold",
    );
  }

  static TextStyle smallLessPrimaryRegularTS() {
    return TextStyle(
      color: AppColors.lessPrimaryColor,
      fontSize: smallTextSize,
      fontFamily: "NunitoSans-Regular",
    );
  }

  static TextStyle extraSmallLessPrimaryRegularTS() {
    return TextStyle(
      color: AppColors.lessPrimaryColor,
      fontSize: extraSmallTextSize,
      fontFamily: "NunitoSans-SemiBold",
    );
  }

  static TextStyle smallPrimaryExtraBoldTS() {
    return TextStyle(
      color: AppColors.primary,
      fontSize: smallTextSize,
      fontFamily: "NunitoSans-ExtraBold",
    );
  }

  static TextStyle smallBrightPrimaryRegularTS() {
    return TextStyle(
      color: AppColors.brightPrimaryColor,
      fontSize: smallTextSize,
      fontFamily: "NunitoSans-Regular",
    );
  }

  static TextStyle smallDarkPrimaryBoldTS() {
    return TextStyle(
      color: AppColors.darkPrimaryColor,
      fontSize: smallTextSize,
      fontFamily: "NunitoSans-Bold",
    );
  }
}
