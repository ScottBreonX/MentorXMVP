import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/models/profile_model.dart';
import 'package:mentorx_mvp/services/auth.dart';
import 'package:mentorx_mvp/services/database.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../components/alert_dialog.dart';
import '../../../components/icon_circle.dart';

User loggedInUser;

class ProfileMentorSection extends StatefulWidget {
  const ProfileMentorSection({
    Key key,
  });

  @override
  _ProfileMentorSectionState createState() => _ProfileMentorSectionState();
}

class _ProfileMentorSectionState extends State<ProfileMentorSection> {
  @override
  void initState() {
    mentorEditStatus = false;
    getCurrentUser();
    getProfileData();
    super.initState();
  }

  bool mentorEditStatus = false;
  String mentorText;
  final _formKey1 = GlobalKey<FormState>();

  TextFormField _buildMentorTextField(BuildContext context) {
    return TextFormField(
      key: _formKey1,
      initialValue: mentorText = profileData['Mentoring Attributes'],
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      textAlign: TextAlign.start,
      onChanged: (value) => mentorText = value,
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

  Future<void> _updateMentoringAttributes(BuildContext context) async {
    try {
      final database = FirestoreDatabase(uid: loggedInUser.uid);
      await database.updateMentoringAttributes(
        MentoringAttributesModel(
          mentoringAttributes: mentorText,
        ),
      );
    } on FirebaseException catch (e) {
      showAlertDialog(context,
          title: 'Operation Failed', content: '$e', defaultActionText: 'Ok');
    }
    setState(() {
      getProfileData().then((value) => mentorEditStatus = false);
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

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: mentorEditStatus
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    'What makes me a good mentor',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black54,
                      fontFamily: 'WorkSans',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                mentorEditStatus
                    ? Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 8.0,
                              bottom: 10.0,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                _updateMentoringAttributes(context);
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
                            padding:
                                const EdgeInsets.only(right: 8.0, bottom: 10.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  mentorEditStatus = false;
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
                              mentorEditStatus = true;
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
          mentorEditStatus
              ? _buildMentorTextField(context)
              : Padding(
                  padding: const EdgeInsets.only(top: 8.0, right: 10.0),
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          '${profileData['Mentoring Attributes']}',
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
    );
  }
}
