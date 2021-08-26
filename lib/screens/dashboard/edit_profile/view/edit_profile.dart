import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:torah_share/modals/modals_exporter.dart';
import 'package:torah_share/screens/routes/routes_exporter.dart';
import 'package:torah_share/translations/locale_keys.g.dart';
import 'package:torah_share/utils/util_exporter.dart';
import 'package:torah_share/utils/widgets/widgets_exporter.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  UserModal _user;

  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _aboutMeController = new TextEditingController();

  bool _isLoading = true;

  @override
  void initState() {
    _getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            _isLoading
                ? Positioned.fill(
                    child: Stack(
                      children: [
                        Container(
                          color: AppColors.blackColor.withOpacity(0.25),
                        ),
                        Center(
                          child: CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 20.0),
                          child: CustomAppBar(
                            textChild: LargePrimaryBoldText(
                                value: tr(LocaleKeys.edit_profile)),
                            willPop: true,
                            includeOptionButton: false,
                            hasIconAndTextWhiteTheme: false,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: PrimaryCard(
                            child: Column(
                              children: [
                                PrimaryLabelAndField(
                                  label: tr(LocaleKeys.username),
                                  hint: "${_user.username}",
                                  controller: _usernameController,
                                ),
                                const SizedBox(height: 20.0),
                                PrimaryLabelAndField(
                                  label: tr(LocaleKeys.email_address),
                                  hint: "${_user.email}",
                                  controller: _emailController,
                                ),
                                const SizedBox(height: 20.0),
                                PrimaryLabelAndField(
                                  label: tr(LocaleKeys.about_me),
                                  hint:
                                      "${_user.aboutMe.isEmpty ? tr(LocaleKeys.let_people_know_about_you) : _user.aboutMe}",
                                  controller: _aboutMeController,
                                ),
                                const SizedBox(height: 40.0),
                                PrimaryButton(
                                  value: tr(LocaleKeys.update),
                                  onPressed: () => _processUpdate(),
                                ),
                                const SizedBox(height: 20.0),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  void _getUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _user = await ApiRequests.getUser(user.uid);
      _isLoading = false;
      setState(() {});
    }
  }

  void _processUpdate() async {
    if (_usernameController.text.trim().isEmpty &&
        _emailController.text.trim().isEmpty &&
        _aboutMeController.text.trim().isEmpty) {
      Common.showSnackBar(tr(LocaleKeys.please_fill_fields),
          tr(LocaleKeys.fill_the_field_you_want_update));
      return;
    }
    if (_usernameController.text.trim().isNotEmpty) {
      setState(() {
        FocusScope.of(context).unfocus();
        _isLoading = true;
      });
      ApiRequests.updateUsername(_user.userID, _usernameController.text.trim())
          .then((value) {
        _usernameController.clear();
        _getUser();
      }).onError((error, stackTrace) {
        _showError(error.toString());
      });
    }
    if (_emailController.text.trim().isNotEmpty) {
      if (!RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(_emailController.text.trim())) {
        Common.showSnackBar(tr(LocaleKeys.enter_email_address),
            tr(LocaleKeys.enter_valid_email_address));
        return;
      } else {
        setState(() {
          FocusScope.of(context).unfocus();
          _isLoading = true;
        });
        ApiRequests.updateEmailAddress(
                _user.userID, _emailController.text.trim())
            .then((value) async {
          setState(() {
            _isLoading = false;
          });
          await Common.processLogout();
        }).onError(
          (error, stackTrace) => _showError(
            error,
            route: AppRoutes.loginRoute,
          ),
        );
      }
    }
    if (_aboutMeController.text.trim().isNotEmpty) {
      setState(() {
        FocusScope.of(context).unfocus();
        _isLoading = true;
      });
      ApiRequests.updateAboutMe(_user.userID, _aboutMeController.text.trim())
          .then((value) {
        _aboutMeController.clear();
        _getUser();
      }).onError((error, stackTrace) => _showError(error));
    }
  }

  _showError(String error, {String route}) {
    setState(() {
      _isLoading = false;
    });
    Common.showOnePrimaryButtonDialog(
      context: context,
      dialogMessage: error,
      primaryButtonOnPressed:
          route == null ? () => Get.back() : Get.offAndToNamed(route),
    );
  }
}
