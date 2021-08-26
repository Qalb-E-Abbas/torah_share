import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:torah_share/screens/routes/routes_exporter.dart';
import 'package:torah_share/translations/locale_keys.g.dart';
import 'package:torah_share/utils/util_exporter.dart';
import 'package:torah_share/utils/widgets/widgets_exporter.dart';

class TermsAndConditions extends StatefulWidget {
  @override
  _TermsAndConditionsState createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  bool _isAgreedWithTOS = true;

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
                            localImage: "${Common.assetsIcons}back_icon.png",
                            onPressed: () => {
                              Get.back(),
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 15.0),
                      LargePrimaryBoldText(
                        value: tr(LocaleKeys.terms_and_conditions),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 15.0),
                      SmallPrimarySemiBoldText(
                        value: tr(LocaleKeys
                            .by_downloading_browsing_accessing_or_using_this_TORAHSHARE_application),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 15.0),
                      MediumPrimaryBoldText(
                        value: tr(LocaleKeys.TERMS_TO_USE),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          children: [
                            SmallPrimarySemiBoldText(
                              value: tr(LocaleKeys
                                  .torahshare_company_is_committed_to_ensuring_that_the_app_is_as),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5.0),
                            SmallPrimarySemiBoldText(
                              value: tr(LocaleKeys
                                  .the_TORAHSHARE_app_stores_and_processes_personal_data_that),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5.0),
                            SmallPrimarySemiBoldText(
                              value: tr(LocaleKeys
                                  .torahshare_company_cannot_always_take_responsibility_for_the),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5.0),
                            SmallPrimarySemiBoldText(
                              value: tr(LocaleKeys
                                  .at_some_point_we_may_wish_to_update_the_app),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5.0),
                            SmallPrimarySemiBoldText(
                              value: tr(LocaleKeys
                                  .we_strongly_recommend_that_you_only_download_the_TORAHSHARE_applications),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      MediumPrimaryBoldText(
                        value: tr(LocaleKeys.REGISTRATION_AND_ACCOUNT_SECURITY),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SmallPrimarySemiBoldText(
                              value: tr(LocaleKeys
                                  .torahshare_company_at_this_moment_grants_the_user_a_non_exclusive),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5.0),
                            SmallPrimarySemiBoldText(
                              value: tr(LocaleKeys
                                  .you_will_not_create_more_than_one_personal_account),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5.0),
                            SmallPrimarySemiBoldText(
                              value: tr(LocaleKeys.If_we_disable_your_account),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5.0),
                            SmallPrimarySemiBoldText(
                              value: tr(LocaleKeys.you_will_not_use_our_app),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5.0),
                            SmallPrimarySemiBoldText(
                              value: tr(LocaleKeys
                                  .you_will_keep_your_contact_information_accurate),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5.0),
                            SmallPrimarySemiBoldText(
                              value: tr(
                                  LocaleKeys.you_will_not_share_your_password),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      MediumPrimaryBoldText(
                        value: tr(LocaleKeys.SERVICE_TERMS),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SmallPrimarySemiBoldText(
                              value: tr(LocaleKeys
                                  .torahshare_company_at_this_moment_grants_the_user_a_non_exclusive),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5.0),
                            SmallPrimarySemiBoldText(
                              value: tr(LocaleKeys
                                  .the_use_of_the_service_is_at_the_user_own_expense_and_risk),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5.0),
                            SmallPrimarySemiBoldText(
                              value: tr(LocaleKeys
                                  .torah_means_the_study_of_the_bible),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5.0),
                            SmallPrimarySemiBoldText(
                              value: tr(LocaleKeys
                                  .torahshare_company_uses_its_own_ad_engine_for_monetizing),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5.0),
                            SmallPrimarySemiBoldText(
                              value: tr(LocaleKeys
                                  .to_upload_any_video_the_app_user_requires_to_get_approval_from_us),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5.0),
                            SmallPrimarySemiBoldText(
                              value: tr(LocaleKeys
                                  .all_videos_posted_need_to_be_clear_and_with_the_quality_that_complies),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5.0),
                            SmallPrimarySemiBoldText(
                              value: tr(LocaleKeys
                                  .anyone_who_uploads_the_video_that_will_be_visual_for_anyone),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5.0),
                            SmallPrimarySemiBoldText(
                              value: tr(LocaleKeys
                                  .torahshare_company_will_have_the_right),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5.0),
                            SmallPrimarySemiBoldText(
                              value: tr(LocaleKeys
                                  .we_may_disclose_the_user_personal_data),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      MediumPrimaryBoldText(
                        value: tr(
                            LocaleKeys.disclaimer_and_exclusion_of_liability),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SmallPrimarySemiBoldText(
                              value: tr(LocaleKeys
                                  .the_TORAHSHARE_Mobile_Application_the_services_the_information_on_the_TORAHSHARE),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5.0),
                            SmallPrimarySemiBoldText(
                              value: tr(LocaleKeys
                                  .to_the_fullest_extent_permitted_by_applicable_law),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5.0),
                            SmallPrimarySemiBoldText(
                              value: tr(LocaleKeys
                                  .we_do_not_warrant_that_the_TORAHSHARE_mobile_application),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5.0),
                            SmallPrimarySemiBoldText(
                              value: tr(LocaleKeys
                                  .while_we_may_use_reasonable_efforts_to_include_accurate_and_up),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5.0),
                            SmallPrimarySemiBoldText(
                              value: tr(LocaleKeys
                                  .we_shall_not_be_liable_for_any_acts_or_omissions_of_any_third),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5.0),
                            SmallPrimarySemiBoldText(
                              value: tr(LocaleKeys
                                  .we_shall_not_be_liable_in_contract_tort),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5.0),
                            SmallPrimarySemiBoldText(
                              value: tr(LocaleKeys
                                  .the_above_exclusions_and_limitations_apply_only_to_the_extent),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      MediumPrimaryBoldText(
                        value: tr(LocaleKeys.INTELLECTUAL_PROPERTY_RIGHTS),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SmallPrimarySemiBoldText(
                              value: tr(LocaleKeys
                                  .all_editorial_content_information_photographs_illustrations),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5.0),
                            SmallPrimarySemiBoldText(
                              value: tr(LocaleKeys
                                  .nothing_contained_on_the_TORAHSHARE_mobile_application),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5.0),
                            SmallPrimarySemiBoldText(
                              value: tr(LocaleKeys
                                  .we_will_not_hesitate_to_take_legal_action_against_any_unauthorized),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      MediumPrimaryBoldText(
                        value: tr(LocaleKeys.COPYRIGHT_INFRINGEMENTS),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 10.0),
                      SmallPrimarySemiBoldText(
                        value: tr(LocaleKeys
                            .we_respect_the_intellectual_property_rights_of_others),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 15.0),
                      MediumPrimaryBoldText(
                        value:
                            tr(LocaleKeys.CHANGES_TO_THIS_TERMS_AND_CONDITIONS),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 10.0),
                      SmallPrimarySemiBoldText(
                        value: tr(LocaleKeys
                            .i_may_update_our_terms_and_conditions_from_time_to_time),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 15.0),
                      MediumPrimaryBoldText(
                        value: tr(LocaleKeys.CONTACT_US),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 10.0),
                      SmallPrimarySemiBoldText(
                        value: tr(LocaleKeys
                            .if_you_have_any_questions_do_not_hesitate_to_contact_me),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CheckboxListTile(
                      value: _isAgreedWithTOS,
                      contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                      onChanged: (value) => {
                        setState(() {
                          _isAgreedWithTOS = value;
                        }),
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      title: RichText(
                        text: TextSpan(
                          style: Styles.smallBrightPrimaryRegularTS(),
                          children: [
                            TextSpan(
                              text: tr(LocaleKeys.i_agree_with_the),
                            ),
                            TextSpan(
                              text: tr(LocaleKeys.terms_and_conditions),
                              style: Styles.smallPrimarySemiBoldTS(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinePrimaryButton(
                            //todo: ask client about this (what to do when user decline !)
                            value: tr(LocaleKeys.decline),
                          ),
                        ),
                        const SizedBox(width: 30.0),
                        Expanded(
                          child: PrimaryButton(
                            value: tr(LocaleKeys.accept),
                            onPressed: () => _processAcceptance(),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _processAcceptance() {
    if (!_isAgreedWithTOS) {
      Common.showSnackBar(tr(LocaleKeys.agree_with_the_terms_and_conditions),
          tr(LocaleKeys.in_order_to_accept_the_terms_and_condition_agreement));
      return;
    }
    Get.offNamed(AppRoutes.homeRoute);
  }
}
