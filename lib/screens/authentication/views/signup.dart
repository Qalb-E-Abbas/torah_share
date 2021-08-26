import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:torah_share/modals/modals_exporter.dart';
import 'package:torah_share/screens/routes/routes_exporter.dart';
import 'package:torah_share/translations/locale_keys.g.dart';

import '../../../utils/util_exporter.dart';
import '../../../utils/widgets/widgets_exporter.dart';
import '../../routes/app_routes.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController usernameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ApplicationIcon(),
                    const SizedBox(height: 40.0),
                    PrimaryCard(
                      child: Column(
                        children: [
                          ExtraLargeExtraBoldPrimaryText(
                              value: tr(LocaleKeys.sign_up)),
                          const SizedBox(height: 30.0),
                          PrimaryLabelAndField(
                            label: tr(LocaleKeys.username),
                            hint: tr(LocaleKeys.enter_your_name),
                            controller: usernameController,
                          ),
                          const SizedBox(height: 20.0),
                          PrimaryLabelAndField(
                            label: tr(LocaleKeys.email),
                            hint: tr(LocaleKeys.enter_your_email),
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
                            value: tr(LocaleKeys.sign_up),
                            onPressed: () => _processSignup(),
                          ),
                          const SizedBox(height: 20.0),
                          InquiryTextAndTextButton(
                            inquiryText:
                                EasyLocalization.of(context).currentLocale ==
                                        Locale("en")
                                    ? tr(LocaleKeys.have_an_account)
                                    : tr(LocaleKeys.login),
                            actionButtonText:
                                EasyLocalization.of(context).currentLocale ==
                                        Locale("en")
                                    ? tr(LocaleKeys.login)
                                    : tr(LocaleKeys.have_an_account),
                            onPressed: () => Get.offNamed(AppRoutes.loginRoute),
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
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  void _processSignup() {
    if (usernameController.text.trim() == null ||
        usernameController.text.trim().isEmpty) {
      Common.showSnackBar("שם משתמש (חובה", "אנא הזן את שם המשתמש");
      return;
    } else if (emailController.text.trim() == null ||
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
      // TODO: check for the gender as well, allow if only Male

      setState(() {
        FocusScope.of(context).unfocus();
        isLoading = true;
      });

      FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      )
          .then((value) async {
        //if success, uploading data to fire-store

        FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
        UserModal userModal = UserModal(
          userID: value.user.uid,
          username: usernameController.text.trim(),
          profileImageUrl: "",
          aboutMe: "",
          email: emailController.text.trim(),
          isProfileVerified: false,
          takeInboxShares: true,
          takeInboxMessages: true,
          searchQueries: Common.getSearchQueries(
              usernameController.text.trim().toLowerCase()),
          deviceToken: await firebaseMessaging.getToken(),
        );

        // add user data to user modal and push to firebase auth
        FirebaseFirestore.instance
            .collection(Common.usersCollection)
            .doc(value.user.uid)
            .set(userModal.toJson())
            .then((value) {
          setState(() {
            isLoading = false;
          });
          Get.offAllNamed(AppRoutes.termsAndConditionsRoute);
        }).onError((error, stackTrace) {
          setState(() {
            isLoading = false;
          });
          Common.showOnePrimaryButtonDialog(
            context: context,
            dialogMessage: error.toString(),
          );
        });
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
}
