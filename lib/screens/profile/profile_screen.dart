import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mentorx_mvp/components/profile_image_circle.dart';
import 'package:mentorx_mvp/components/progress.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/profile/sections/about_me_section.dart';
import 'package:mentorx_mvp/screens/profile/sections/core_profile_section.dart';
import 'package:mentorx_mvp/screens/profile/sections/work_experience.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Im;
import 'package:uuid/uuid.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');

final Reference storageRef = FirebaseStorage.instance.ref();

class Profile extends StatefulWidget {
  final myUser loggedInUser;
  final String profileId;
  static String id = 'mentor_screen';

  Profile({this.profileId, this.loggedInUser});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  File file;
  final imagePicker = ImagePicker();
  final double profilePhotoHeight = 150;

  handleTakePhoto() async {
    Navigator.pop(context);
    final picked = await ImagePicker.platform
        .getImage(source: ImageSource.camera, maxHeight: 675, maxWidth: 960);
    if (picked != null) {
      setState(() {
        file = File(picked.path);
      });
    }
  }

  handleChooseFromGallery() async {
    Navigator.pop(context);
    final picked =
        await ImagePicker.platform.getImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        file = File(picked.path);
      });
    }
  }

  selectImage(parentContext, titleText) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              titleText,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: kMentorXPAccentDark,
                fontFamily: 'Montserrat',
                fontSize: 25,
                fontWeight: FontWeight.w500,
              ),
            ),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Divider(
                  height: 4,
                  color: Colors.grey,
                ),
              ),
              SimpleDialogOption(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.camera_alt,
                        size: 30,
                        color: kMentorXPSecondary,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "Photo with Camera",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                  ],
                ),
                onPressed: handleTakePhoto,
              ),
              SimpleDialogOption(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.photo,
                        size: 30,
                        color: kMentorXPSecondary,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "Image from Gallery",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                  ],
                ),
                onPressed: handleChooseFromGallery,
              ),
              SimpleDialogOption(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.cancel,
                        size: 30,
                        color: kMentorXPAccentDark,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "Remove Current Photo",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  Navigator.pop(context);
                  removePhotoConfirm(context, widget.loggedInUser.program);
                },
              ),
              SimpleDialogOption(
                child: RoundedButton(
                  title: 'Cancel',
                  textAlignment: MainAxisAlignment.center,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  buttonColor: kMentorXPAccentDark,
                  fontColor: Colors.white,
                  onPressed: () => Navigator.pop(context),
                ),
                onPressed: () {},
              )
            ],
          );
        });
  }

  removePhotoConfirm(parentContext, programID) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Center(
              child: Text(
                "Confirm Photo Removal",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RoundedButton(
                        minWidth: 130,
                        title: "Cancel",
                        buttonColor: Colors.grey,
                        fontColor: Colors.white,
                        onPressed: () => Navigator.pop(context)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RoundedButton(
                      minWidth: 130,
                      title: "Remove",
                      buttonColor: Colors.red,
                      fontColor: Colors.white,
                      onPressed: () {
                        Navigator.pop(context);
                        removeCurrentPhoto(
                          programID,
                        );
                        setState(() {
                          isUploading = true;
                        });
                      },
                    ),
                  )
                ],
              ),
            ],
          );
        });
  }

  bool aboutMeEditStatus = false;
  bool coreProfileEditStatus = false;
  bool myProfileView = false;
  bool isUploading = false;
  String postId = Uuid().v4();
  bool profilePhotoExist = false;

  clearImage() {
    setState(() {
      file = null;
    });
  }

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(file.readAsBytesSync());
    final compressedImageFile = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 75));
    setState(() {
      file = compressedImageFile;
    });
  }

  Future<String> uploadImage(imageFile) async {
    UploadTask uploadTask =
        storageRef.child("post_$postId.jpg").putFile(imageFile);
    TaskSnapshot storageSnap = await uploadTask;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  savePhotoInUserCollection({String mediaUrl, String programID}) async {
    await usersRef
        .doc(widget.loggedInUser.id)
        .update({"Profile Picture": mediaUrl});
    if (programID == "" || programID == null) {
    } else {
      await programsRef
          .doc(programID)
          .collection('mentors')
          .doc(widget.loggedInUser.id)
          .get()
          .then((doc) => {
                if (doc.exists)
                  {
                    programsRef
                        .doc(programID)
                        .collection('mentors')
                        .doc(widget.loggedInUser.id)
                        .update({
                      "Profile Picture": mediaUrl,
                    })
                  }
              });
    }
    if (programID == "" || programID == null) {
    } else {
      await programsRef
          .doc(programID)
          .collection('mentees')
          .doc(widget.loggedInUser.id)
          .get()
          .then((doc) => {
                if (doc.exists)
                  {
                    programsRef
                        .doc(programID)
                        .collection('mentees')
                        .doc(widget.loggedInUser.id)
                        .update({
                      "Profile Picture": mediaUrl,
                    })
                  }
              });
    }
    setState(() {
      file = null;
      isUploading = false;
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Profile(
          profileId: widget.profileId,
          loggedInUser: widget.loggedInUser,
        ),
      ),
    );
  }

  removeCurrentPhoto(programID) async {
    await usersRef.doc(widget.loggedInUser.id).update({'Profile Picture': ""});
    if (programID == "" || programID == null) {
      setState(() {
        isUploading = false;
        profilePhotoExist = false;
      });
      setState(() {
        isUploading = false;
      });
    } else {
      await programsRef
          .doc(programID)
          .collection('mentors')
          .doc(widget.loggedInUser.id)
          .get()
          .then((doc) => {
                if (doc.exists)
                  {
                    programsRef
                        .doc(programID)
                        .collection('mentors')
                        .doc(widget.loggedInUser.id)
                        .update({'Profile Picture': ""})
                  }
              });
      await programsRef
          .doc(programID)
          .collection('mentees')
          .doc(widget.loggedInUser.id)
          .get()
          .then((doc) => {
                if (doc.exists)
                  {
                    programsRef
                        .doc(programID)
                        .collection('mentees')
                        .doc(widget.loggedInUser.id)
                        .update({'Profile Picture': ""})
                  }
              });
      setState(() {
        isUploading = false;
        profilePhotoExist = false;
      });
      setState(() {
        isUploading = false;
      });
    }
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => Profile(
          profileId: widget.profileId,
          loggedInUser: widget.loggedInUser,
        ),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  handleSubmit(programID) async {
    setState(() {
      isUploading = true;
    });
    await compressImage();
    String mediaUrl = await uploadImage(file);
    savePhotoInUserCollection(mediaUrl: mediaUrl, programID: programID);
  }

  Scaffold buildUploadScreen(programID) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kMentorXPPrimary,
          title: Center(
            child: Text(
              "Upload Profile Picture",
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ),
        ),
        body: Stack(
          children: [
            Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Column(
                        children: [
                          Text(
                            'Confirm Upload of',
                            style: Theme.of(context).textTheme.headlineLarge,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Profile Picture',
                            style: Theme.of(context).textTheme.headlineLarge,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    CircleAvatar(
                      radius: 120,
                      backgroundImage: FileImage(file),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RoundedButton(
                            title: 'Cancel',
                            buttonColor: Colors.white,
                            fontColor: Colors.black45,
                            minWidth: 150,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            onPressed: isUploading
                                ? null
                                : () {
                                    Navigator.pushReplacement(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder:
                                            (context, animation1, animation2) =>
                                                Profile(
                                          profileId: widget.profileId,
                                          loggedInUser: widget.loggedInUser,
                                        ),
                                        transitionDuration: Duration.zero,
                                        reverseTransitionDuration:
                                            Duration.zero,
                                      ),
                                    );
                                  },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RoundedButton(
                            title: 'Upload',
                            buttonColor: Theme.of(context).colorScheme.tertiary,
                            fontColor: Colors.white,
                            minWidth: 150,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            onPressed: isUploading
                                ? null
                                : () => handleSubmit(programID),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            isUploading
                ? Container(
                    color: Colors.white.withOpacity(0.8),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          circularProgress(
                            Theme.of(context).primaryColor,
                          ),
                        ],
                      ),
                    ),
                  )
                : Text(""),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    // final top = 200 - profilePhotoHeight / 2;

    if (widget.profileId == null) {
      return circularProgress(Theme.of(context).primaryColor);
    }

    if (widget.profileId == widget.loggedInUser.id) {
      if (this.mounted) {
        setState(() {
          myProfileView = true;
        });
      }
    }

    return FutureBuilder<Object>(
        future: usersRef.doc(widget.profileId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress(Theme.of(context).primaryColor);
          }
          myUser user = myUser.fromDocument(snapshot.data);

          if (user.profilePicture != "") {
            profilePhotoExist = true;
          }

          return file != null
              ? buildUploadScreen(widget.loggedInUser.program)
              : Scaffold(
                  appBar: AppBar(
                    backgroundColor: kMentorXPPrimary,
                    elevation: 5,
                    leading: GestureDetector(
                      child: Icon(Icons.close),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    title: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 35.0, bottom: 10),
                        child: Image.asset(
                          'assets/images/MentorXP.png',
                          fit: BoxFit.contain,
                          height: 35,
                        ),
                      ),
                    ),
                  ),
                  body: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Container(
                          child: Column(
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    height: 200,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.vertical(
                                          bottom: Radius.circular(0)),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: <Color>[
                                          kMentorXPPrimary,
                                          Colors.white,
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 120,
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        profilePhotoExist
                                            ? CircleAvatar(
                                                backgroundColor: Theme.of(
                                                        context)
                                                    .scaffoldBackgroundColor,
                                                radius: profilePhotoHeight / 2,
                                                child: CachedNetworkImage(
                                                  imageUrl: user.profilePicture,
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Container(
                                                    // width: 180.0,
                                                    height: 140.0,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  placeholder: (context, url) =>
                                                      Container(),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Icon(
                                                    Icons.person,
                                                    size: 50,
                                                    color: kMentorXPSecondary,
                                                  ),
                                                ),
                                              )
                                            : CircleAvatar(
                                                backgroundColor: Theme.of(
                                                        context)
                                                    .scaffoldBackgroundColor,
                                                radius: profilePhotoHeight / 2,
                                                child: ProfileImageCircle(
                                                  iconSize:
                                                      profilePhotoHeight / 2,
                                                  circleSize:
                                                      profilePhotoHeight /
                                                          2 *
                                                          .95,
                                                  circleColor: Colors.grey,
                                                ),
                                              ),
                                        !myProfileView
                                            ? Container()
                                            : Positioned(
                                                right: 5,
                                                top: 5,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    selectImage(
                                                      context,
                                                      "Upload a Profile Photo",
                                                    );
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                      color: Theme.of(context)
                                                          .scaffoldBackgroundColor
                                                          .withOpacity(0.8),
                                                    ),
                                                    height: 35.0,
                                                    width: 35.0,
                                                    child: GestureDetector(
                                                      child: Icon(
                                                        Icons.edit,
                                                        color:
                                                            kMentorXPAccentDark,
                                                        size: 25,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              !myProfileView
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 90.0),
                                      child: CoreProfileSection(
                                        profileId: user.id,
                                        myProfileView: myProfileView,
                                        fNameImport: user.firstName,
                                        lNameImport: user.lastName,
                                        programImport: user.program,
                                        loggedInUser: user,
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(top: 60.0),
                                      child: CoreProfileSection(
                                        profileId: user.id,
                                        myProfileView: myProfileView,
                                        fNameImport: user.firstName,
                                        lNameImport: user.lastName,
                                        programImport: user.program,
                                        loggedInUser: user,
                                      ),
                                    ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0),
                                child: Divider(
                                  thickness: 2,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: AboutMeSection(
                                  loggedInUser: user,
                                  aboutMeTextImport: user.aboutMe,
                                  profileId: user.id,
                                  myProfileView: myProfileView,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0),
                                child: Divider(
                                  thickness: 2,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20.0),
                                child: WorkExperienceSection(
                                  loggedInUser: user,
                                  workExperienceImport: user.workExperience,
                                  profileId: user.id,
                                  myProfileView: myProfileView,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      isUploading
                          ? Container(
                              color: Colors.white.withOpacity(0.8),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    circularProgress(
                                      Theme.of(context).primaryColor,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Text(''),
                    ],
                  ),
                );
        });
  }
}
