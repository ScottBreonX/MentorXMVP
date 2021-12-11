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

class ProfileMenteeSection extends StatefulWidget {
  const ProfileMenteeSection({
    Key key,
  });

  @override
  _ProfileMenteeSectionState createState() => _ProfileMenteeSectionState();
}

class _ProfileMenteeSectionState extends State<ProfileMenteeSection> {
  @override
  void initState() {
    menteeEditStatus = false;
    getCurrentUser();
    getProfileData();
    super.initState();
  }

  bool menteeEditStatus = false;
  String menteeText;
  final _formKey1 = GlobalKey<FormState>();

  TextFormField _buildMenteeTextField(BuildContext context) {
    return TextFormField(
      key: _formKey1,
      initialValue: menteeText = profileData['Mentee Attributes'],
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      textAlign: TextAlign.start,
      onChanged: (value) => menteeText = value,
      style: Theme.of(context).textTheme.subtitle2,
      autocorrect: false,
      decoration: kTextFieldDecorationDark,
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

  Future<void> _updateMenteeAttributes(BuildContext context) async {
    try {
      final database = FirestoreDatabase(uid: loggedInUser.uid);
      await database.updateMenteeAttributes(
        MenteeAttributesModel(
          menteeAttributes: menteeText,
        ),
      );
    } on FirebaseException catch (e) {
      showAlertDialog(context,
          title: 'Operation Failed', content: '$e', defaultActionText: 'Ok');
    }
    setState(() {
      getProfileData().then((value) => menteeEditStatus = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (profileData == null) {
      return Center();
    }

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: menteeEditStatus
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    'What I seek in a mentor',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
                menteeEditStatus
                    ? Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 8.0,
                              bottom: 10.0,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                _updateMenteeAttributes(context);
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
                                  menteeEditStatus = false;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.red,
                                ),
                                height: 40.0,
                                width: 40.0,
                                // decoration: BoxDecoration(
                                //   shape: BoxShape.circle,
                                // ),
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
                              menteeEditStatus = true;
                            });
                          },
                          child: IconCircle(
                            circleColor: Theme.of(context).backgroundColor,
                            width: 30.0,
                            height: 30.0,
                            iconSize: 20.0,
                            iconType: Icons.edit,
                          ),
                        ),
                      ),
              ],
            ),
          ),
          menteeEditStatus
              ? _buildMenteeTextField(context)
              : Padding(
                  padding: const EdgeInsets.only(top: 8.0, right: 10.0),
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          '${profileData['Mentee Attributes']}',
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
