import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mentorx_mvp/components/alert_dialog.dart';
import 'package:mentorx_mvp/components/menu_bar.dart';
import 'package:mentorx_mvp/components/work_experience_form.dart';
import 'package:mentorx_mvp/components/work_experience_section.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mentorx_mvp/models/profile_model.dart';
import 'package:mentorx_mvp/services/auth.dart';
import 'package:mentorx_mvp/services/database.dart';
import 'package:path/path.dart' as p;
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
    getWorkData();
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

  Future<dynamic> getWorkData() async {
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

  // Image Picker
  File _image; // Used only if you need a single picture

  Future getImage(bool gallery) async {
    ImagePicker picker = ImagePicker();
    PickedFile pickedFile;
    // Let user select photo from gallery
    if (gallery) {
      pickedFile = await picker.getImage(
        source: ImageSource.gallery,
      );
    }
    // Otherwise open camera to get new photo
    else {
      pickedFile = await picker.getImage(
        source: ImageSource.camera,
      );
    }

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        profilePhotoSelected = true;
      } else {
        profilePhotoSelected = false;
      }
    });
  }

  Future<void> saveImage(File _image) async {
    DocumentReference profileReference = FirebaseFirestore.instance
        .collection('users')
        .doc('${loggedInUser.uid}')
        .collection('profile')
        .doc('coreInfo');

    String imageURL = await uploadFile(_image);
    profileReference.update({'images': imageURL});
    setState(() {
      getProfileData();
    });
  }

//  image formatting

  Future<String> uploadFile(File _image) async {
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('profilePictures/${p.basename(_image.path)}');

    UploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask;
    print('File Uploaded');
    String returnURL;
    await storageReference.getDownloadURL().then((fileURL) {
      returnURL = fileURL;
    });
    return returnURL;
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
            borderSide: BorderSide(color: Colors.white, width: 1.0),
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

    var drawerHeader = MentorXMenuHeader(
      fName: '${profileData['First Name']}',
      lName: '${profileData['Last Name']}',
      email: '${profileData['Email Address']}',
      profilePicture: '${profileData['images']}',
    );

    final drawerItems = MentorXMenuList(drawerHeader: drawerHeader);

    return Scaffold(
      drawer: Drawer(
        child: Container(
          child: drawerItems,
          color: kMentorXDark,
        ),
      ),
      appBar: AppBar(
        backgroundColor: kMentorXBlack,
        elevation: 0,
        title: Text('My Profile'),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: kMentorXDark,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            Container(
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 60,
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
                                  onTap: () async {
                                    getImage(true).whenComplete(() =>
                                        profilePhotoSelected
                                            ? saveImage(_image)
                                            : null);
                                  },
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
                          SizedBox(
                            width: 120,
                            child: Center(
                              child: Text(
                                '${profileData['Year in School']}',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            color: Colors.white,
                            height: 30,
                            width: 2,
                          ),
                          SizedBox(
                            width: 120,
                            child: Center(
                              child: Text(
                                '${profileData['Major']}',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            color: Colors.white,
                            height: 30,
                            width: 2,
                          ),
                          SizedBox(
                            width: 120,
                            child: Center(
                              child: Text(
                                '${profileData['Minor']}',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
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
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: kMentorXDark,
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
                                    fontSize: 20.0,
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
                                          child: Container(
                                            height: 30.0,
                                            width: 30.0,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                            ),
                                            child: Icon(
                                              Icons.edit,
                                              color: kMentorXPrimary,
                                              size: 20,
                                            ),
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
                                    fontSize: 20.0,
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
                                    child: Container(
                                      height: 30.0,
                                      width: 30.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: kMentorXPrimary,
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
                                        Icons.add,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
                          Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                            child: Row(
                              children: [
                                Text(
                                  'Top Skills',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    color: kMentorXPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20.0, left: 10.0, right: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 5,
                                        offset: Offset(2, 3),
                                        color: Colors.grey,
                                        spreadRadius: 1,
                                      )
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    backgroundColor: kMentorXPrimary,
                                    radius: 45,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 43,
                                      child: Icon(
                                        Icons.add,
                                        color: kMentorXPrimary,
                                        size: 45,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 5,
                                        offset: Offset(2, 3),
                                        color: Colors.grey,
                                        spreadRadius: 1,
                                      )
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    backgroundColor: kMentorXPrimary,
                                    radius: 45,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 43,
                                      child: Icon(
                                        Icons.add,
                                        color: kMentorXPrimary,
                                        size: 45,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 5,
                                        offset: Offset(2, 3),
                                        color: Colors.grey,
                                        spreadRadius: 1,
                                      )
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    backgroundColor: kMentorXPrimary,
                                    radius: 45,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 43,
                                      child: Icon(
                                        Icons.add,
                                        color: kMentorXPrimary,
                                        size: 45,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                            child: Row(
                              children: [
                                Text(
                                  'Hobbies / Interests',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    color: kMentorXPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20.0, left: 10.0, right: 10.0, bottom: 40),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 5,
                                        offset: Offset(2, 3),
                                        color: Colors.grey,
                                        spreadRadius: 1,
                                      )
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    backgroundColor: kMentorXPrimary,
                                    radius: 45,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 43,
                                      child: Icon(
                                        Icons.add,
                                        color: kMentorXPrimary,
                                        size: 45,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 5,
                                        offset: Offset(2, 3),
                                        color: Colors.grey,
                                        spreadRadius: 1,
                                      )
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    backgroundColor: kMentorXPrimary,
                                    radius: 45,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 43,
                                      child: Icon(
                                        Icons.add,
                                        color: kMentorXPrimary,
                                        size: 45,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 5,
                                        offset: Offset(2, 3),
                                        color: Colors.grey,
                                        spreadRadius: 1,
                                      )
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    backgroundColor: kMentorXPrimary,
                                    radius: 45,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 43,
                                      child: Icon(
                                        Icons.add,
                                        color: kMentorXPrimary,
                                        size: 45,
                                      ),
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
              ),
            )
          ],
        ),
      ),
    );
  }
}
