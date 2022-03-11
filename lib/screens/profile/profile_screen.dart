import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mentorx_mvp/components/alert_dialog.dart';
import 'package:mentorx_mvp/components/icon_circle.dart';
import 'package:mentorx_mvp/components/progress.dart';
import 'package:mentorx_mvp/screens/launch_screen.dart';
import 'package:mentorx_mvp/screens/menu_bar/menu_bar.dart';
import 'package:mentorx_mvp/components/profile_image_circle.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/profile/sections/about_me_section.dart';
import 'package:mentorx_mvp/screens/profile/sections/core_profile_section.dart';
import 'package:mentorx_mvp/screens/profile/sections/profile_mentee_section.dart';
import 'package:mentorx_mvp/screens/profile/sections/profile_mentor_section.dart';
import 'package:mentorx_mvp/screens/profile/sections/work_experience.dart';
import 'package:path/path.dart';

final usersRef = FirebaseFirestore.instance.collection('users');

class Profile extends StatefulWidget {
  final String loggedInUser;
  final String profileId;
  static String id = 'mentor_screen';

  Profile({this.profileId, this.loggedInUser});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final picker = ImagePicker();

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile.path != null) {
      setState(() {
        // _imageFile = File(pickedFile.path);
        uploadImageToFirebase(File(pickedFile.path));
        print(basename(pickedFile.path));
      });
    }
  }

  String profilePicFilePath;

  Future uploadImageToFirebase(File _imageFile) async {
    String fileName = basename(_imageFile.path);

    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('profilePictures/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    TaskSnapshot taskSnapshot = await uploadTask;
    taskSnapshot.ref.getDownloadURL().then(
          (value) => print('Done: $value'),
        );

    String filePrefix =
        "https://firebasestorage.googleapis.com/v0/b/mentorxmvp-9d7a4.appspot.com/o/profilePictures%2F";

    setState(() {
      _updateProfilePicture("$fileName");
      print(fileName);
    });
  }

  Future<void> _updateProfilePicture(String fileName) async {
    try {
      await usersRef.doc(loggedInUser.id).update({
        "Profile Picture": fileName,
      });
      print('updated profile picture');
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  bool aboutMeEditStatus = false;
  bool coreProfileEditStatus = false;
  bool myProfileView = false;

  @override
  Widget build(BuildContext context) {
    if (widget.profileId == null) {
      return circularProgress();
    }

    if (widget.profileId == loggedInUser.id) {
      setState(() {
        myProfileView = true;
      });
    }

    double circleSize = 55.0;

    final drawerItems = MentorXMenuList();
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();

    return FutureBuilder<Object>(
        future: usersRef.doc(widget.profileId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          myUser user = myUser.fromDocument(snapshot.data);
          return Scaffold(
            key: _scaffoldKey,
            drawer: !myProfileView
                ? null
                : Drawer(
                    child: Container(
                      child: drawerItems,
                    ),
                  ),
            appBar: AppBar(
              elevation: 5,
              title: Text(!myProfileView
                  ? '${user.firstName}\'s Profile'
                  : 'My Profile'),
            ),
            body: SingleChildScrollView(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 120.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.white,
                                width: 3,
                              ),
                            ),
                          ),
                          child: Image.asset(
                            'assets/images/MLogoBlue.png',
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 65.0),
                          child: Stack(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: circleSize + 3,
                                child: ProfileImageCircle(
                                  profileImage: user.profilePicture,
                                  iconSize: circleSize,
                                  circleSize: circleSize,
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 5,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                  ),
                                  height: 35.0,
                                  width: 35.0,
                                  child: GestureDetector(
                                    onTap: () async {
                                      pickImage();
                                    },
                                    child: Icon(
                                      Icons.add_a_photo,
                                      color: Theme.of(context).iconTheme.color,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        !myProfileView
                            ? Container()
                            : Positioned(
                                top: 20,
                                right: 10,
                                child: IconCircle(
                                  height: 30.0,
                                  width: 30.0,
                                  iconSize: 20.0,
                                  iconType: Icons.edit,
                                  circleColor:
                                      Theme.of(context).backgroundColor,
                                  iconColor: Theme.of(context).iconTheme.color,
                                ),
                              ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: CoreProfileSection(
                        profileId: user.id,
                        myProfileView: myProfileView,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: const Divider(
                        thickness: 4,
                        color: Colors.grey,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: AboutMeSection(
                        profileId: user.id,
                        myProfileView: myProfileView,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: const Divider(
                        thickness: 4,
                        color: Colors.grey,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: WorkExperienceSection(
                        profileId: user.id,
                        myProfileView: myProfileView,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                        right: 8.0,
                        top: 15.0,
                      ),
                      child: const Divider(
                        thickness: 4,
                        color: Colors.grey,
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                          child: Text(
                            'Mentoring Preferences',
                            style: Theme.of(context).textTheme.headline3,
                          ),
                        ),
                      ],
                    ),
                    ProfileMentorSection(
                      profileId: user.id,
                      myProfileView: myProfileView,
                    ),
                    ProfileMenteeSection(
                      myProfileView: myProfileView,
                      profileId: user.id,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                        right: 8.0,
                        top: 15.0,
                      ),
                      child: const Divider(
                        thickness: 4,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
