import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:torah_share/main.dart';
import 'package:torah_share/modals/modals_exporter.dart';
import 'package:torah_share/screens/routes/routes_exporter.dart';
import 'package:torah_share/translations/locale_keys.g.dart';
import 'package:torah_share/utils/util_exporter.dart';
import 'package:torah_share/utils/widgets/widgets_exporter.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  // for language localization
  SharedPreferences sharedPreferences;
  UserModal _currentUser;
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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor:
                    new AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            )
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomAppBar(
                      textChild:
                          MediumPrimaryBoldText(value: tr(LocaleKeys.settings)),
                      willPop: true,
                      includeOptionButton: false,
                    ),
                    const SizedBox(height: 30.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        MediumPrimarySemiBoldText(
                          value: tr(LocaleKeys.management),
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(height: 15.0),
                        CustomBorderCard(
                          onPressed: () => Get.toNamed(AppRoutes.editProfile),
                          cardPadding: EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MediumPrimaryRegularText(
                                  value: tr(LocaleKeys.edit_profile)),
                              ButtonIcon(
                                localImage:
                                    "${Common.assetsIcons}next_icon.png",
                                onPressed: null,
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 30.0),
                        MediumPrimarySemiBoldText(
                          value: tr(LocaleKeys.about_application),
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(height: 20.0),
                        CustomBorderCard(
                          onPressed: () =>
                              Get.toNamed(AppRoutes.termsAndConditionsRoute),
                          cardPadding: EdgeInsets.all(20.0),
                          bottomLeft: const Radius.circular(0.0),
                          bottomRight: const Radius.circular(0.0),
                          dividerPadding: EdgeInsets.only(left: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MediumPrimaryRegularText(
                                  value: tr(LocaleKeys.terms_and_conditions)),
                              ButtonIcon(
                                localImage:
                                    "${Common.assetsIcons}next_icon.png",
                                onPressed: null,
                              )
                            ],
                          ),
                        ),
                        CustomBorderCard(
                          onPressed: () =>
                              Get.toNamed(AppRoutes.privacyPolicyRoute),
                          cardPadding: EdgeInsets.all(20.0),
                          topLeft: const Radius.circular(0.0),
                          bottomLeft: const Radius.circular(0.0),
                          topRight: const Radius.circular(0.0),
                          bottomRight: const Radius.circular(0.0),
                          dividerPadding: EdgeInsets.only(left: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MediumPrimaryRegularText(
                                value: tr(LocaleKeys.privacy_policy),
                              ),
                              ButtonIcon(
                                localImage:
                                    "${Common.assetsIcons}next_icon.png",
                                onPressed: null,
                              )
                            ],
                          ),
                        ),
                        CustomBorderCard(
                          onPressed: () =>
                              Get.toNamed(AppRoutes.disclaimerRoute),
                          cardPadding: EdgeInsets.all(20.0),
                          topLeft: const Radius.circular(0.0),
                          topRight: const Radius.circular(0.0),
                          dividerPadding: EdgeInsets.only(left: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MediumPrimaryRegularText(
                                value: tr(LocaleKeys.disclaimer),
                              ),
                              ButtonIcon(
                                localImage:
                                    "${Common.assetsIcons}next_icon.png",
                                onPressed: null,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        MediumPrimarySemiBoldText(
                          value: tr(LocaleKeys.privacy),
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(height: 20.0),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: CheckboxListTile(
                            value: !_currentUser.takeInboxShares,
                            secondary: MediumPrimaryRegularText(
                              value: tr(LocaleKeys.send_only_mode),
                            ),
                            tileColor: AppColors.whiteColor,
                            controlAffinity: ListTileControlAffinity.trailing,
                            onChanged: (value) => _processSendOnlyMode(value),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 3.0),
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: CheckboxListTile(
                            value: !_currentUser.takeInboxMessages,
                            secondary: MediumPrimaryRegularText(
                              value: tr(LocaleKeys.no_chat_mode),
                            ),
                            tileColor: AppColors.whiteColor,
                            controlAffinity: ListTileControlAffinity.trailing,
                            onChanged: (value) => _processNoChatMode(value),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 3.0),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30.0),
                    MediumPrimarySemiBoldText(
                      value: tr(LocaleKeys.language),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 20.0),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: SwitchListTile(
                        value: EasyLocalization.of(context).currentLocale ==
                            Locale("en"),
                        secondary: MediumPrimaryRegularText(
                          value: EasyLocalization.of(context).currentLocale !=
                                  Locale("en")
                              ? "Switch to English"
                              : "Switch to Hebrew",
                        ),
                        tileColor: AppColors.whiteColor,
                        controlAffinity: ListTileControlAffinity.trailing,
                        onChanged: (value) => _processLanguageFilter(value),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 3.0),
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        MediumPrimarySemiBoldText(
                          value: tr(LocaleKeys.preferences),
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(height: 10.0),
                        CustomBorderCard(
                          onPressed: () => Common.processLogout(),
                          cardPadding: EdgeInsets.all(20.0),
                          dividerPadding: EdgeInsets.only(left: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MediumPrimaryRegularText(
                                  value: tr(LocaleKeys.logout)),
                              ButtonIcon(
                                localImage:
                                    "${Common.assetsIcons}next_icon.png",
                                onPressed: null,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void _getUser() async {
    final user = FirebaseAuth.instance.currentUser;
    _currentUser = await ApiRequests.getUser(user.uid);
    _isLoading = false;
    setState(() {});
  }

  void _processSendOnlyMode(bool isPrivate) async {
    setState(() {
      _isLoading = true;
    });
    await ApiRequests.updateProfileSendModeStatus(
        _currentUser.userID, !isPrivate);
    _getUser();
  }

  void _processNoChatMode(bool isPrivate) async {
    setState(() {
      _isLoading = true;
    });
    await ApiRequests.updateProfileChatModeStatus(
        _currentUser.userID, !isPrivate);
    _getUser();
  }

  _processLanguageFilter(bool value) async {
    Locale _newLocale =
        EasyLocalization.of(context).currentLocale == Locale("en")
            ? Locale("he")
            : Locale("en");
    EasyLocalization.of(context).setLocale(_newLocale);
    MyApp.setLocale(context, _newLocale);
    setState(() {});
  }
}
