import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/alert_dialog.dart';
import 'package:mentorx_mvp/models/profile_model.dart';
import 'package:mentorx_mvp/services/auth.dart';
import 'package:mentorx_mvp/services/database.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import 'icon_circle.dart';

User loggedInUser;

class AboutMe extends StatefulWidget {
  const AboutMe({
    Key key,
  });

  @override
  _AboutMeState createState() => _AboutMeState();
}

class _AboutMeState extends State<AboutMe> {
  @override
  void initState() {
    getCurrentUser();
    getProfileData();
    aboutMeEditStatus = false;
    super.initState();
  }

  bool aboutMeEditStatus = false;
  String aboutMeText;
  final _formKey1 = GlobalKey<FormState>();

  TextFormField _buildAboutMeTextField(BuildContext context) {
    return TextFormField(
      key: _formKey1,
      initialValue: aboutMeText = profileData['About Me'],
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      textAlign: TextAlign.start,
      onChanged: (value) => aboutMeText = value,
      style: TextStyle(
        color: kMentorXPrimary,
        fontWeight: FontWeight.w400,
      ),
      autocorrect: false,
      decoration: kTextFieldDecorationLight.copyWith(
        fillColor: Colors.grey.shade200,
        filled: true,
        labelText: '',
        hintText: '',
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kMentorXPrimary, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kMentorXPrimary, width: 3.0),
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
      ),
    );
  }

  dynamic profileData;

  Future<dynamic> getProfileData() async {
    await FirebaseFirestore.instance
        .collection('users/${loggedInUser.uid}/profile')
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        if (mounted) {
          setState(() {
            profileData = result.data();
          });
        }
      });
    });
  }

  void getCurrentUser() {
    final auth = Provider.of<AuthBase>(context, listen: false);
    try {
      final user = auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _updateAboutMe(BuildContext context) async {
    try {
      final database = FirestoreDatabase(uid: loggedInUser.uid);
      await database.updateAboutMe(
        AboutMeModel(
          aboutMe: aboutMeText,
        ),
      );
    } on FirebaseException catch (e) {
      showAlertDialog(context,
          title: 'Operation Failed', content: '$e', defaultActionText: 'Ok');
    }
    setState(() {
      getProfileData().then((value) => aboutMeEditStatus = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (profileData == null) {
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: kMentorXPrimary,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
        child: Container(
          child: SizedBox(
            height: double.infinity,
            child: ListView(
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
                        style: TextStyle(
                          fontSize: 25.0,
                          color: kMentorXPrimary,
                          fontWeight: FontWeight.w600,
                        ),
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
                                      height: 40.0,
                                      width: 40.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 2,
                                            offset: Offset(2, 2),
                                            color: Colors.black54,
                                            spreadRadius: 0.5,
                                          )
                                        ],
                                      ),
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 8.0, bottom: 10.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        aboutMeEditStatus = false;
                                      });
                                    },
                                    child: Container(
                                      height: 40.0,
                                      width: 40.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 2,
                                            offset: Offset(2, 2),
                                            color: Colors.black54,
                                            spreadRadius: 0.5,
                                          )
                                        ],
                                      ),
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.red,
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
                                  circleColor: kMentorXPrimary,
                                  iconColor: Colors.white,
                                  iconSize: 20.0,
                                  iconType: Icons.edit,
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
                                '${profileData['About Me']}',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
