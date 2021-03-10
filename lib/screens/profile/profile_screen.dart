import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mentorx_mvp/components/alert_dialog.dart';
import 'package:mentorx_mvp/components/menu_bar.dart';
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
        color: kMentorXTeal,
        fontWeight: FontWeight.w400,
      ),
      autocorrect: false,
      decoration: kTextFieldDecorationLight.copyWith(
        labelText: '',
        hintText: '',
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 2.0),
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (profileData == null) {
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: kMentorXTeal,
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
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade900,
        elevation: 0,
        title: Text('My Profile'),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              height: 300,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.blueGrey.shade800,
                    Colors.blueGrey.shade900,
                  ],
                ),
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
                                radius: 70,
                                backgroundImage: profilePhotoStatus
                                    ? NetworkImage(profileData['images'])
                                    : null,
                                child: profilePhotoStatus
                                    ? null
                                    : Icon(
                                        Icons.person,
                                        color: kMentorXTeal,
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
                                  color: Colors.blueGrey,
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
                      height: 20,
                    ),
                    Row(
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
                          height: 50,
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
                          height: 50,
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
                    )
                  ],
                ),
              ),
            ),
            Expanded(
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
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'About Me',
                                style: TextStyle(
                                    fontSize: 25.0,
                                    color: kMentorXTeal.shade700,
                                    fontWeight: FontWeight.w600),
                              ),
                              aboutMeEditStatus
                                  ? Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 8.0, bottom: 10.0),
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
                                            Icons.edit,
                                            color: Colors.blueGrey,
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
                                          fontSize: 18.0,
                                          color: kMentorXTeal,
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
                                  color: kMentorXTeal.shade700,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        WorkExperienceSection(
                          title: 'Summer Finance Intern',
                          company: 'The Walt Disney Company',
                          dateRange: 'April 2019 - April 2020',
                          location: 'Burbank, CA',
                          description: profileData['About Me'],
                          dividerColor: Colors.transparent,
                          dividerHeight: 0,
                        ),
                        WorkExperienceSection(
                          title: 'Summer Finance Intern',
                          company: 'The Walt Disney Company',
                          dateRange: 'April 2019 - April 2020',
                          location: 'Burbank, CA',
                          description: profileData['About Me'],
                          dividerColor: Colors.grey.shade400,
                          dividerThickness: 1,
                        ),
                        WorkExperienceSection(
                          title: 'Summer Finance Intern',
                          company: 'The Walt Disney Company',
                          dateRange: 'April 2019 - April 2020',
                          location: 'Burbank, CA',
                          description: profileData['About Me'],
                          dividerColor: Colors.grey.shade400,
                          dividerThickness: 1,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: Row(
                            children: [
                              Text(
                                'Top Skills',
                                style: TextStyle(
                                  fontSize: 25.0,
                                  color: kMentorXTeal.shade700,
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
                                  backgroundColor: kMentorXTeal.shade700,
                                  radius: 45,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 43,
                                    child: Icon(
                                      Icons.add,
                                      color: kMentorXTeal.shade700,
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
                                  backgroundColor: kMentorXTeal.shade700,
                                  radius: 45,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 43,
                                    child: Icon(
                                      Icons.add,
                                      color: kMentorXTeal.shade700,
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
                                  backgroundColor: kMentorXTeal.shade700,
                                  radius: 45,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 43,
                                    child: Icon(
                                      Icons.add,
                                      color: kMentorXTeal.shade700,
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
                                  fontSize: 25.0,
                                  color: kMentorXTeal.shade700,
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
                                  backgroundColor: kMentorXTeal.shade700,
                                  radius: 45,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 43,
                                    child: Icon(
                                      Icons.add,
                                      color: kMentorXTeal.shade700,
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
                                  backgroundColor: kMentorXTeal.shade700,
                                  radius: 45,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 43,
                                    child: Icon(
                                      Icons.add,
                                      color: kMentorXTeal.shade700,
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
                                  backgroundColor: kMentorXTeal.shade700,
                                  radius: 45,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 43,
                                    child: Icon(
                                      Icons.add,
                                      color: kMentorXTeal.shade700,
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
            )
          ],
        ),
      ),
    );
  }
}
