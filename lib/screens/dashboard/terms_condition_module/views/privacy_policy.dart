import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:torah_share/translations/locale_keys.g.dart';
import 'package:torah_share/utils/util_exporter.dart';
import 'package:torah_share/utils/widgets/widgets_exporter.dart';

class PrivacyPolicy extends StatefulWidget {
  @override
  _PrivacyPolicyState createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
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
                        value: tr(LocaleKeys.privacy_policy),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 15.0),
                      SmallPrimarySemiBoldText(
                        value: tr(LocaleKeys.read_our_privacy_policy),
                      ),
                      const SizedBox(height: 5.0),
                      SmallPrimarySemiBoldText(
                        value: tr(LocaleKeys
                            .order_to_use_app_you_must_first_acknowledge),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 15.0),
                      MediumPrimaryBoldText(
                        value: tr(LocaleKeys.GENERAL),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 10.0),
                      SmallPrimarySemiBoldText(
                        value: tr(
                            LocaleKeys.torahshare_company_provides_application),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 15.0),
                      MediumPrimaryBoldText(
                        value: tr(LocaleKeys.PERSONAL_DATA_YOU_PROVIDE),
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
                                  .account_credentials_in_order_to_use_the_torahshare_services),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5.0),
                            SmallPrimarySemiBoldText(
                              value: tr(LocaleKeys
                                  .profile_information_when_you_create_torahshare_account),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5.0),
                            SmallPrimarySemiBoldText(
                              value: tr(LocaleKeys
                                  .feedback_support_If_you_provide_us_feedback_contact),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5.0),
                            SmallPrimarySemiBoldText(
                              value: tr(LocaleKeys
                                  .photos_videos_and_audio_if_you_upload_a_photo_or_video),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5.0),
                            SmallPrimarySemiBoldText(
                              value: tr(LocaleKeys
                                  .you_will_keep_your_contact_information_accurate),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      MediumPrimaryBoldText(
                        value:
                            tr(LocaleKeys.GENERAL_DATA_PROTECTION_REGULATION),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 10.0),
                      SmallPrimarySemiBoldText(
                        value: tr(LocaleKeys.we_are_a_data_controller),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 5.0),
                      SmallPrimarySemiBoldText(
                        value: tr(LocaleKeys
                            .torahshare_company_legal_basis_for_collecting_and_using_the_personal),
                        textAlign: TextAlign.start,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SmallPrimarySemiBoldText(
                              value: tr(LocaleKeys
                                  .torahshare_company_needs_to_perform_a_contract),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5.0),
                            SmallPrimarySemiBoldText(
                              value: tr(
                                  LocaleKeys.you_have_given_torahshare_company),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5.0),
                            SmallPrimarySemiBoldText(
                              value: tr(LocaleKeys
                                  .processing_your_personal_information_is_in_torahshare),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5.0),
                            SmallPrimarySemiBoldText(
                              value: tr(LocaleKeys
                                  .torahshare_company_needs_to_comply),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      SmallPrimarySemiBoldText(
                        value: tr(LocaleKeys
                            .torahshare_company_will_retain_your_personal_information_only),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 5.0),
                      SmallPrimarySemiBoldText(
                        value: tr(LocaleKeys
                            .if_you_are_a_resident_of_the_eropean_economic_area),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 5.0),
                      SmallPrimarySemiBoldText(
                        value: tr(LocaleKeys
                            .you_are_entitled_to_the_following_rights),
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
                                  .the_right_to_access_you_may_at_any_time_request),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5.0),
                            SmallPrimarySemiBoldText(
                              value: tr(LocaleKeys
                                  .the_right_to_rectification_you_are_entitled_to_obtain_rectification),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5.0),
                            SmallPrimarySemiBoldText(
                              value: tr(LocaleKeys
                                  .the_right_to_erase_under_certain_circumstances),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5.0),
                            SmallPrimarySemiBoldText(
                              value: tr(LocaleKeys
                                  .the_right_to_object_to_certain_processing_activities),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5.0),
                            SmallPrimarySemiBoldText(
                              value: tr(LocaleKeys
                                  .the_right_to_data_portability_you_are_entitled_to_receive_your_personal),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      MediumPrimaryBoldText(
                        value: tr(LocaleKeys.PERMISSIONS_REQUIRED),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SmallPrimarySemiBoldText(
                              value: tr(LocaleKeys.INTERNET),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5.0),
                            SmallPrimarySemiBoldText(
                              value: tr(LocaleKeys.READ_WRITE_TO_PHONE_STORAGE),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5.0),
                            SmallPrimarySemiBoldText(
                              value: tr(LocaleKeys.CAMERA),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5.0),
                            SmallPrimarySemiBoldText(
                              value: tr(LocaleKeys.NOTIFICATION),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      MediumPrimaryBoldText(
                        value: tr(LocaleKeys
                            .link_to_the_privacy_policy_of_third_party_service_providers_used),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SmallPrimarySemiBoldText(
                              value: tr(LocaleKeys.apple_app_store_services),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5.0),
                            SmallPrimarySemiBoldText(
                              value: tr(LocaleKeys.google_cloud_services),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      MediumPrimaryBoldText(
                        value: tr(LocaleKeys.LOG_DATA),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 5.0),
                      SmallPrimarySemiBoldText(
                        value: tr(LocaleKeys
                            .torahshare_company_wants_to_inform_you_that_whenever_you),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 10.0),
                      MediumPrimaryBoldText(
                        value: tr(LocaleKeys.COOKIES_USAGE_DATA),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 5.0),
                      SmallPrimarySemiBoldText(
                        value: tr(LocaleKeys
                            .cookies_are_files_with_a_small_amount_of_data),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 5.0),
                      SmallPrimarySemiBoldText(
                        value: tr(LocaleKeys
                            .this_service_does_not_use_these_explicitly),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 15.0),
                      MediumPrimaryBoldText(
                        value: tr(LocaleKeys.USE_OF_DATA),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 5.0),
                      SmallPrimarySemiBoldText(
                        value: tr(LocaleKeys
                            .when_you_access_the_service_with_a_mobile_device),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 15.0),
                      MediumPrimaryBoldText(
                        value: tr(LocaleKeys.TRACKING_COOKIES_DATA),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 5.0),
                      SmallPrimarySemiBoldText(
                        value: tr(LocaleKeys
                            .we_use_cookies_and_similar_tracking_technologies),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 5.0),
                      SmallPrimarySemiBoldText(
                        value: tr(LocaleKeys
                            .cookies_are_files_with_a_small_amount_of_data_that_are_commonly),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 5.0),
                      SmallPrimarySemiBoldText(
                        value: tr(LocaleKeys
                            .you_can_instruct_your_browser_to_refuse_all_cookies),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 5.0),
                      SmallPrimarySemiBoldText(
                        value: tr(LocaleKeys.examples_of_cookies),
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
                                  .session_cookies_we_use_session_cookies),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5.0),
                            SmallPrimarySemiBoldText(
                              value: tr(LocaleKeys
                                  .preference_cookies_we_use_preference_cookies),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5.0),
                            SmallPrimarySemiBoldText(
                              value: tr(LocaleKeys
                                  .security_cookies_we_use_security_cookies),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      MediumPrimaryBoldText(
                        value: tr(LocaleKeys.USE_OF_DATA),
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
                                  .to_provide_and_maintain_our_service),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5.0),
                            SmallPrimarySemiBoldText(
                              value: tr(LocaleKeys.to_notify_you_about_changes),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5.0),
                            SmallPrimarySemiBoldText(
                              value: tr(LocaleKeys
                                  .to_allow_you_to_participate_in_interactive_features),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5.0),
                            SmallPrimarySemiBoldText(
                              value: tr(LocaleKeys.to_provide_customer_support),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5.0),
                            SmallPrimarySemiBoldText(
                              value: tr(LocaleKeys
                                  .to_gather_analysis_valuable_information),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5.0),
                            SmallPrimarySemiBoldText(
                              value: tr(LocaleKeys.to_monitor_the_usage),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5.0),
                            SmallPrimarySemiBoldText(
                              value: tr(LocaleKeys
                                  .to_detect_prevent_and_address_technical_issues),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5.0),
                            SmallPrimarySemiBoldText(
                              value: tr(LocaleKeys
                                  .to_provide_you_with_news_special_offers),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      MediumPrimaryBoldText(
                        value: tr(LocaleKeys.YOUR_PERSONAL_DATA),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 10.0),
                      SmallPrimarySemiBoldText(
                        value: tr(LocaleKeys
                            .torahshare_company_is_using_a_strong_backend),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 15.0),
                      MediumPrimaryBoldText(
                        value: tr(LocaleKeys.SECURITY),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 10.0),
                      SmallPrimarySemiBoldText(
                        value: tr(LocaleKeys
                            .we_value_your_trust_in_providing_us_your_personal_information),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 15.0),
                      MediumPrimaryBoldText(
                        value: tr(LocaleKeys.PAYMENT_TERMS),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 10.0),
                      SmallPrimarySemiBoldText(
                        value: tr(LocaleKeys
                            .we_may_provide_paid_products_and_services),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 5.0),
                      SmallPrimarySemiBoldText(
                        value: tr(LocaleKeys
                            .we_will_not_store_or_collect_your_payment_card_details),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 5.0),
                      SmallPrimarySemiBoldText(
                        value: tr(
                            LocaleKeys.the_payment_processors_we_work_with_are),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SmallPrimarySemiBoldText(
                              value: tr(LocaleKeys.apple_store_in_app_payments),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5.0),
                            SmallPrimarySemiBoldText(
                              value: tr(LocaleKeys.google_play_in_app_payments),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      MediumPrimaryBoldText(
                        value: tr(LocaleKeys.SERVICE_PROVIDERS),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 10.0),
                      SmallPrimarySemiBoldText(
                        value: tr(LocaleKeys
                            .we_may_employ_third_party_companies_and_individuals),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SmallPrimarySemiBoldText(
                              value: tr(LocaleKeys.to_facilitate_our_service),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5.0),
                            SmallPrimarySemiBoldText(
                              value: tr(LocaleKeys
                                  .to_provide_the_service_on_our_behalf),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5.0),
                            SmallPrimarySemiBoldText(
                              value: tr(LocaleKeys
                                  .to_perform_service_related_services),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5.0),
                            SmallPrimarySemiBoldText(
                              value: tr(LocaleKeys.to_assist_us_in_analyzing),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      SmallPrimarySemiBoldText(
                        value: tr(
                            LocaleKeys.we_want_to_inform_users_of_this_service),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 10.0),
                      MediumPrimaryBoldText(
                        value: tr(LocaleKeys.CHILDRENS_PRIVACY),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 5.0),
                      SmallPrimarySemiBoldText(
                        value: tr(LocaleKeys
                            .these_services_do_not_address_anyone_under_the_age_of_13),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 10.0),
                      MediumPrimaryBoldText(
                        value: tr(LocaleKeys.BEHAVIORAL_REMARKETING),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 5.0),
                      SmallPrimarySemiBoldText(
                        value: tr(LocaleKeys
                            .torahshare_company_uses_remarketing_services_to_advertise),
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
                                  .google_ads_remarketing_service_is_provided_by_google),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5.0),
                            SmallPrimarySemiBoldText(
                              value: tr(LocaleKeys
                                  .facebook_remarketing_service_is_provided_by_facebook),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5.0),
                            SmallPrimarySemiBoldText(
                              value: tr(LocaleKeys
                                  .youronlinechoices_or_opt_out_using_your_mobile_device),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      MediumPrimaryBoldText(
                        value: tr(LocaleKeys
                            .UPDATES_OR_CHANGES_TO_OUR_PRIVACY_POLICY),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 5.0),
                      SmallPrimarySemiBoldText(
                        value: tr(LocaleKeys
                            .occasionally_we_may_change_or_update_this_privacy_policy),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 10.0),
                      MediumPrimaryBoldText(
                        value: tr(LocaleKeys.CONTROLLER),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 5.0),
                      SmallPrimarySemiBoldText(
                        value: tr(LocaleKeys.torahShare_company_mail),
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
