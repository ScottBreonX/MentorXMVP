import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/alert_dialog.dart';
import 'package:mentorx_mvp/components/icon_circle.dart';
import 'package:mentorx_mvp/components/work_experience_form.dart';
import 'package:mentorx_mvp/components/work_experience_section.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mentorx_mvp/models/profile_model.dart';
import 'package:mentorx_mvp/services/auth.dart';
import 'package:mentorx_mvp/services/database.dart';
import 'package:provider/provider.dart';

User loggedInUser;

class MyProfile extends StatefulWidget {
  const MyProfile({
    Key key,
    this.database,
  }) : super(key: key);

  static const String id = 'profile_screen';
  final Database database;

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  bool aboutMeEditStatus = false;
  bool profilePhotoStatus = false;
  bool profilePhotoSelected = false;
  final _formKey1 = GlobalKey<FormState>();
  String aboutMe;

  @override
  void initState() {
    getCurrentUser();
    getProfileData();
    getWorkExpData();
    aboutMeEditStatus = false;
    super.initState();
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

  dynamic workExperienceData;

  Future<dynamic> getWorkExpData() async {
    await FirebaseFirestore.instance
        .collection('users/${loggedInUser.uid}/workExperience')
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        if (mounted) {
          setState(() {
            workExperienceData = result.data();
          });
        }
      });
    });
  }

  Future<void> _updateAboutMe(BuildContext context) async {
    try {
      final database = FirestoreDatabase(uid: loggedInUser.uid);
      await database.updateAboutMe(
        AboutMeModel(
          aboutMe: aboutMe,
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

  Future<void> _editWorkExperience(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return WorkExperienceForm(
              title: 'Mentee Enrollment',
              titleFontSize: 20.0,
              descriptions: 'Confirm enrollment as mentee?',
              descriptionFontSize: 20.0,
              textLeft: 'Cancel',
              textRight: 'Yes',
              leftOnPressed: () {
                Navigator.pop(context);
              },
              rightOnPressed: () {
                Navigator.pop(context);
              });
        });
  }

  TextFormField _buildAboutMeTextField(BuildContext context) {
    return TextFormField(
      key: _formKey1,
      initialValue: aboutMe = profileData['About Me'],
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      textAlign: TextAlign.start,
      onChanged: (value) => aboutMe = value,
      style: TextStyle(
        color: kMentorXDark,
        fontWeight: FontWeight.w400,
      ),
      autocorrect: false,
      decoration: kTextFieldDecorationLight.copyWith(
        fillColor: Colors.white,
        filled: true,
        labelText: '',
        hintText: '',
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kMentorXBlack, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kMentorXPrimary, width: 2.0),
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
      ),
    );
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

    if (profileData['images'] == null) {
      setState(() {
        profilePhotoStatus = false;
      });
    } else {
      setState(() {
        profilePhotoStatus = true;
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMentorXDark.withOpacity(0.95),
        elevation: 5,
        title: Text('My Profile'),
      ),
      body: Container(
        color: kMentorXDark,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 2,
                      offset: Offset(2, 3),
                      color: kMentorXBlack,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 2,
                                        offset: Offset(2, 3),
                                        color: kMentorXBlack,
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(60),
                                  ),
                                  child: CircleAvatar(
                                    backgroundColor:
                                        Colors.white.withOpacity(0.10),
                                    radius: 50,
                                    backgroundImage: profilePhotoStatus
                                        ? NetworkImage(profileData['images'])
                                        : null,
                                    child: profilePhotoStatus
                                        ? null
                                        : Icon(
                                            Icons.person,
                                            color: kMentorXPrimary,
                                            size: 70,
                                          ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    height: 35.0,
                                    width: 35.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: kMentorXPrimary,
                                    ),
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: Icon(
                                        Icons.photo_camera,
                                        color: Colors.white,
                                        size: 25.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${profileData['First Name']}',
                            style: TextStyle(
                              fontSize: 30.0,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            '${profileData['Last Name']}',
                            style: TextStyle(
                              fontSize: 30.0,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: 120,
                                  child: Center(
                                    child: Text(
                                      '${profileData['Year in School']}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              color: kMentorXPrimary,
                              height: 25,
                              width: 2,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: 120,
                                  child: Center(
                                    child: Text(
                                      '${profileData['Major']}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              color: kMentorXPrimary,
                              height: 25,
                              width: 2,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: 120,
                                  child: Center(
                                    child: Text(
                                      '${profileData['Minor']}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: kMentorXDark.withOpacity(0.95),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
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
                                                      color: Colors.grey,
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
                                                      color: Colors.grey,
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
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
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
                                  padding: const EdgeInsets.only(
                                      top: 8.0, right: 10.0),
                                  child: Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          '${profileData['About Me']}',
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          Padding(
                            padding: const EdgeInsets.only(top: 40.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Work Experience',
                                  style: TextStyle(
                                    fontSize: 25.0,
                                    color: kMentorXPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _editWorkExperience(context);
                                      });
                                    },
                                    child: IconCircle(
                                      height: 30.0,
                                      width: 30.0,
                                      iconSize: 20.0,
                                      iconType: Icons.edit,
                                      circleColor: kMentorXPrimary,
                                      iconColor: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          WorkExperienceSection(
                            title: workExperienceData['title1'] ?? "<Blank>",
                            company:
                                workExperienceData['company1'] ?? "<Blank>",
                            dateRange:
                                workExperienceData['dateRange1'] ?? "<Blank>",
                            location:
                                workExperienceData['location1'] ?? "<Blank>",
                            description:
                                workExperienceData['description1'] ?? "<Blank>",
                            dividerColor: Colors.transparent,
                            dividerHeight: 0,
                            workExpEditStatus: () {
                              setState(() {
                                _editWorkExperience(context);
                              });
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: const Divider(
                              color: Colors.white,
                            ),
                          ),
                          WorkExperienceSection(
                            title: 'Summer Bro Intern',
                            company: 'The Walt Disney Company',
                            dateRange: 'April 2019 - April 2020',
                            location: 'Burbank, CA',
                            description: profileData['About Me'],
                            dividerColor: Colors.transparent,
                            dividerHeight: 0,
                            workExpEditStatus: () {
                              setState(() {
                                _editWorkExperience(context);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
