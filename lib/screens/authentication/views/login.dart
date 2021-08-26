import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:torah_share/translations/locale_keys.g.dart';

import '../../../utils/util_exporter.dart';
import '../../../utils/widgets/widgets_exporter.dart';
import '../../routes/app_routes.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ApplicationIcon(),
                      const SizedBox(height: 40.0),
                      PrimaryCard(
                        child: Column(
                          children: [
                            ExtraLargeExtraBoldPrimaryText(
                              value: tr(LocaleKeys.login),
                            ),
                            const SizedBox(height: 30.0),
                            PrimaryLabelAndField(
                              label: tr(LocaleKeys.email),
                              hint: tr(LocaleKeys.enter_email_address),
                              controller: emailController,
                            ),
                            const SizedBox(height: 20.0),
                            PrimaryLabelAndField(
                              label: tr(LocaleKeys.password),
                              hint: tr(LocaleKeys.enter_your_password),
                              isPasswordField: true,
                              controller: passwordController,
                            ),
                            const SizedBox(height: 40.0),
                            PrimaryButton(
                              value: tr(LocaleKeys.login),
                              onPressed: () => _processLogin(context),
                            ),
                            const SizedBox(height: 20.0),
                            InquiryTextAndTextButton(
                              inquiryText:
                                  tr(LocaleKeys.dont_have_an_account_question),
                              actionButtonText: tr(LocaleKeys.sign_up),
                              onPressed: () =>
                                  Get.offNamed(AppRoutes.signupRoute),
                            ),
                            const SizedBox(height: 20.0),
                            BackgroundButton(
                              onPressed: () => _processGoogleLogin(),
                              value: tr(LocaleKeys.google),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            isLoading
                ? Positioned.fill(
                    child: Container(
                      color: AppColors.blackColor.withOpacity(0.25),
                    ),
                  )
                : const SizedBox.shrink(),
            isLoading
                ? Positioned.fill(
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            AppColors.primary),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  void _processLogin(BuildContext context) {
    if (emailController.text.trim() == null ||
        emailController.text.trim().isEmpty ||
        !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(emailController.text.trim())) {
      Common.showSnackBar(tr(LocaleKeys.email_required),
          tr(LocaleKeys.enter_valid_email_address));
      return;
    } else if (passwordController.text.trim() == null ||
        passwordController.text.trim().isEmpty ||
        passwordController.text.length < 8) {
      Common.showSnackBar(tr(LocaleKeys.password_required),
          tr(LocaleKeys.enter_strong_password_message));
      return;
    } else {
      FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
      setState(() {
        FocusScope.of(context).unfocus();
        isLoading = true;
      });

      ApiRequests.loginUserWithEmail(
        emailController.text.trim(),
        passwordController.text.trim(),
      ).then((value) async {
        final user = FirebaseAuth.instance.currentUser;
        await ApiRequests.updateDeviceToken(
            user.uid, await firebaseMessaging.getToken());
        setState(() {
          isLoading = false;
        });
        Get.offNamed(AppRoutes.homeRoute);
      }).onError((error, stackTrace) {
        setState(() {
          isLoading = false;
        });
        Common.showOnePrimaryButtonDialog(
          context: context,
          dialogMessage: error.toString(),
        );
      });
    }
  }

  void _processGoogleLogin() async {
    setState(() {
      isLoading = true;
    });
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    ApiRequests.googleLogin().then((value) async {
      final user = FirebaseAuth.instance.currentUser;
      await ApiRequests.updateDeviceToken(
          user.uid, await firebaseMessaging.getToken());
      setState(() {
        isLoading = false;
      });

      Get.offAllNamed(AppRoutes.homeRoute);
    }).onError((error, stackTrace) {
      setState(() {
        isLoading = false;
      });

      Common.showOnePrimaryButtonDialog(
        context: context,
        dialogMessage: error.toString(),
      );
    });
  }
}
