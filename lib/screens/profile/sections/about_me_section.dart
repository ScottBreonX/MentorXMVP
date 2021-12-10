import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/models/profile_model.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/home_screen.dart';
import 'package:mentorx_mvp/services/database.dart';
import '../../../constants.dart';
import '../../../components/alert_dialog.dart';
import '../../../components/icon_circle.dart';

class AboutMeSection extends StatefulWidget {
  final myUser loggedInUser;

  const AboutMeSection({
    this.loggedInUser,
  });

  @override
  _AboutMeSectionState createState() => _AboutMeSectionState();
}

class _AboutMeSectionState extends State<AboutMeSection> {
  @override
  void initState() {
    aboutMeEditStatus = false;
    super.initState();
  }

//  comment here

  bool aboutMeEditStatus = false;
  String aboutMeText;
  final _formKey1 = GlobalKey<FormState>();

  TextFormField _buildAboutMeTextField(BuildContext context) {
    return TextFormField(
      key: _formKey1,
      initialValue: aboutMeText = '',
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      textAlign: TextAlign.start,
      onChanged: (value) => aboutMeText = value,
      style: Theme.of(context).textTheme.subtitle2,
      autocorrect: false,
      decoration: kTextFieldDecorationDark,
    );
  }

  Future<void> _updateAboutMe(BuildContext context) async {
    try {
      final database = FirestoreDatabase(uid: loggedInUser.id);
      await database.updateAboutMe(
        AboutMeModel(
          aboutMe: aboutMeText,
        ),
      );
    } on FirebaseException catch (e) {
      showAlertDialog(context,
          title: 'Operation Failed', content: '$e', defaultActionText: 'Ok');
    }
    // setState(() {
    //   getProfileData().then((value) => aboutMeEditStatus = false);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: aboutMeEditStatus
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.end,
              children: [
                Text(
                  'About Me',
                  style: Theme.of(context).textTheme.headline3,
                ),
                aboutMeEditStatus
                    ? Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 8.0,
                              bottom: 10.0,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                _updateAboutMe(context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.green,
                                ),
                                height: 40.0,
                                width: 40.0,
                                child: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 8.0, bottom: 10.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  aboutMeEditStatus = false;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.red,
                                ),
                                height: 40.0,
                                width: 40.0,
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              aboutMeEditStatus = true;
                            });
                          },
                          child: IconCircle(
                            width: 30.0,
                            height: 30.0,
                            iconType: Icons.edit,
                            circleColor: Theme.of(context).backgroundColor,
                          ),
                        ),
                      ),
              ],
            ),
          ),
          aboutMeEditStatus
              ? _buildAboutMeTextField(context)
              : Padding(
                  padding: const EdgeInsets.only(top: 8.0, right: 10.0),
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          '',
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
