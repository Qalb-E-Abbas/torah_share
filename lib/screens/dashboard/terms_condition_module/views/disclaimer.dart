import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:torah_share/translations/locale_keys.g.dart';
import 'package:torah_share/utils/util_exporter.dart';
import 'package:torah_share/utils/widgets/widgets_exporter.dart';

class Disclaimer extends StatefulWidget {
  @override
  _DisclaimerState createState() => _DisclaimerState();
}

class _DisclaimerState extends State<Disclaimer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 5,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20.0),
                      Row(
                        children: [
                          ButtonIcon(
                              localImage: "${Common.assetsIcons}back_icon.png"),
                        ],
                      ),
                      const SizedBox(height: 15.0),
                      LargePrimaryBoldText(
                        value: tr(LocaleKeys.disclaimer),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 15.0),
                      SmallPrimarySemiBoldText(
                        value: tr(LocaleKeys
                            .require_information_about_app_disclaimer),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 5.0),
                      SmallPrimarySemiBoldText(
                        value: tr(
                            LocaleKeys.provides_application_ideas_inspiration),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 5.0),
                      SmallPrimarySemiBoldText(
                        value: tr(LocaleKeys.by_downloading_accessing),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 5.0),
                      SmallPrimarySemiBoldText(
                        value:
                            tr(LocaleKeys.app_expressly_disclaims_warranties),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 5.0),
                      SmallPrimarySemiBoldText(
                        value: tr(LocaleKeys.you_agree_to_hold_torahshare),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 5.0),
                      SmallPrimarySemiBoldText(
                        value: tr(LocaleKeys
                            .app_may_include_inaccuracies_typographical_errors),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 10.0),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
