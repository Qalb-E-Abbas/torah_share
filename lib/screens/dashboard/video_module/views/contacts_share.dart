import 'package:contacts_service/contacts_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:telephony/telephony.dart';
import 'package:torah_share/modals/modals_exporter.dart';
import 'package:torah_share/screens/routes/routes_exporter.dart';
import 'package:torah_share/translations/locale_keys.g.dart';
import 'package:torah_share/utils/util_exporter.dart';
import 'package:torah_share/utils/widgets/widgets_exporter.dart';

class ContactsShare extends StatefulWidget {
  final String videoTitle;

  const ContactsShare({
    Key key,
    @required this.videoTitle,
  }) : super(key: key);

  @override
  _ContactsShareState createState() => _ContactsShareState();
}

class _ContactsShareState extends State<ContactsShare> {
  List<Contact> _contacts = [];
  Map<Contact, dynamic> _allContactsState = {};
  UserModal _currentUser;

  @override
  void initState() {
    _getUser();
    _getContacts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
                child: CustomAppBar(
                  textChild:
                      LargeWhiteBoldText(value: tr(LocaleKeys.invite_contacts)),
                  willPop: true,
                  hasIconAndTextWhiteTheme: true,
                  includeOptionButton: false,
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                  ),
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: _contacts.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        child: CheckboxListTile(
                          title: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: AppColors.primary,
                                child: Text(
                                  _contacts[index].displayName[0],
                                  style: TextStyle(
                                    color: AppColors.whiteColor,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20.0),
                              Expanded(
                                  child: Text(_contacts[index].displayName)),
                            ],
                          ),
                          onChanged: (bool value) =>
                              _toggleContact(value, index),
                          value: _allContactsState[_contacts[index]],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            right: MediaQuery.of(context).size.width * 0.25,
            left: MediaQuery.of(context).size.width * 0.25,
            child: FloatingActionButton.extended(
              backgroundColor: AppColors.primary,
              onPressed: () => _sendMessage(),
              label: Text(
                tr(LocaleKeys.send_invite),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _getContacts() async {
    if (await _getContactsPermission()) {
      Iterable<Contact> contacts =
          await ContactsService.getContacts(withThumbnails: false);
      contacts.forEach((element) {
        _contacts.add(element);
        _allContactsState[element] = false;
      });
      setState(() {});
    }
  }

  Future<bool> _getContactsPermission() async {
    try {
      final contactPermission = Permission.contacts;
      if (await contactPermission.isGranted)
        return true;
      else if (await contactPermission.isDenied ||
          await contactPermission.isLimited ||
          await contactPermission.isRestricted) {
        contactPermission.request().then((permission) => {
              if (permission.isRestricted ||
                  permission.isDenied ||
                  permission.isPermanentlyDenied)
                Get.offAllNamed(AppRoutes.homeRoute)
              else
                _getContacts()
            });
        return false;
      } else
        return false;
    } catch (e) {
      print(e);
    }
  }

  _toggleContact(bool value, int index) {
    _allContactsState[_contacts[index]] = value;
    setState(() {});
  }

  _sendMessage() async {
    final Telephony telephony = Telephony.instance;
    String textMessageForContact;
    // todo: 2 messages depending on langauge
    // if english
    textMessageForContact =
        "${_currentUser.username} Shared a video \"${widget.videoTitle}\" on ${Common.applicationName}. Download the application to view the content";
    // if hebrew
    textMessageForContact =
        "${_currentUser.username} שיתף סרטון \"${widget.videoTitle}\" עַל ${Common.applicationName}. הורד את היישום לצפייה בתוכן ";

    //todo: add multiple languages for database
    String textMessageForNotification =
        "You Shared video ${widget.videoTitle} with your friend";
    bool canSendSms = await telephony.isSmsCapable;

    // send message if device is capable
    if (canSendSms) {
      if (!(_allContactsState == null &&
          _allContactsState.isEmpty &&
          _allContactsState.length == 0)) {
        _allContactsState.forEach((key, value) {
          if (value == true) {
            textMessageForNotification =
                "You Shared video ${widget.videoTitle} with your friend";
            key.phones.forEach((element) async {
              telephony.sendSms(
                  to: element.value, message: textMessageForContact);
              // send self contact notification
              await ApiRequests.sendSelfContactNotification(
                  textMessageForNotification, _currentUser, key.displayName);
            });
          }
        });
      }
    }
    navigator.pop();
  }

  void _getUser() async {
    final user = FirebaseAuth.instance.currentUser;
    _currentUser = await ApiRequests.getUser(user.uid);
    setState(() {});
  }
}
