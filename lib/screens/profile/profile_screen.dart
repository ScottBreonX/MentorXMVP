import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mentorx_mvp/components/icon_circle.dart';
import 'package:mentorx_mvp/components/profile_image_circle.dart';
import 'package:mentorx_mvp/components/progress.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/screens/launch_screen.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/profile/sections/about_me_section.dart';
import 'package:mentorx_mvp/screens/profile/sections/core_profile_section.dart';
import 'package:mentorx_mvp/screens/profile/sections/work_experience.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Im;
import 'package:uuid/uuid.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
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
  File file;
  final imagePicker = ImagePicker();
  final double coverPhotoHeight = 200;
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

  selectImage(parentContext, titleText, pictureType) {
    setState(() {
      this.pictureType = pictureType;
    });

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
                        style: TextStyle(
                          color: Colors.black54,
                          fontFamily: 'Montserrat',
                          fontSize: 20,
                        ),
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
                        style: TextStyle(
                          color: Colors.black54,
                          fontFamily: 'Montserrat',
                          fontSize: 20,
                        ),
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
                        style: TextStyle(
                          color: Colors.black54,
                          fontFamily: 'Montserrat',
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  Navigator.pop(context);
                  removePhotoConfirm(context, pictureType);
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

  removePhotoConfirm(parentContext, pictureType) {
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
                style: Theme.of(context).textTheme.headline4,
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
                      title: "Remove Photo",
                      buttonColor: Colors.red,
                      fontColor: Colors.white,
                      onPressed: () => removeCurrentPhoto(pictureType),
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
  bool coverPhotoExist = false;
  String pictureType;

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

  savePhotoInUserCollection({String mediaUrl, String pictureType}) {
    usersRef.doc(loggedInUser.id).update({pictureType: mediaUrl});
    setState(() {
      file = null;
      isUploading = false;
    });
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Profile(
            profileId: loggedInUser.id,
            loggedInUser: loggedInUser,
          ),
        ));
  }

  removeCurrentPhoto(pictureType) {
    usersRef.doc(loggedInUser.id).update({pictureType: ""});
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Profile(
            loggedInUser: loggedInUser,
            profileId: loggedInUser.id,
          ),
        ));
  }

  handleSubmit(pictureType) async {
    setState(() {
      isUploading = true;
    });
    await compressImage();
    String mediaUrl = await uploadImage(file);
    savePhotoInUserCollection(mediaUrl: mediaUrl, pictureType: pictureType);
  }

  Scaffold buildUploadScreen(pictureType) {
    bool isCoverPhoto = false;

    if (pictureType == "Cover Photo") {
      setState(() {
        isCoverPhoto = true;
      });
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: kMentorXPPrimary,
          title: Center(
            child: Text(
                isCoverPhoto ? "Upload Cover Photo" : "Upload Profile Picture"),
          ),
        ),
        body: Stack(
          children: [
            isUploading
                ? Container(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Opacity(
                            opacity: 1.0,
                            child: CircularProgressIndicator(),
                          ),
                        ],
                      ),
                    ),
                  )
                : Text(""),
            Opacity(
              opacity: isUploading ? 0.2 : 1.0,
              child: Container(
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
                              style: Theme.of(context).textTheme.headline1,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              isCoverPhoto ? 'Cover Photo' : 'Profile Photo',
                              style: Theme.of(context).textTheme.headline1,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      isCoverPhoto
                          ? Container(
                              width: 500,
                              height: 150.0,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: FileImage(file),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : CircleAvatar(
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
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Profile(
                                            loggedInUser: widget.loggedInUser,
                                            profileId: widget.loggedInUser.id,
                                          ),
                                        ),
                                      );
                                    },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RoundedButton(
                              title: 'Upload',
                              buttonColor: kMentorXPAccentDark,
                              fontColor: Colors.white,
                              minWidth: 150,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              onPressed: isUploading
                                  ? null
                                  : () => handleSubmit(pictureType),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    final top = coverPhotoHeight - profilePhotoHeight / 2;

    if (widget.profileId == null) {
      return circularProgress();
    }

    if (widget.profileId == widget.loggedInUser.id) {
      setState(() {
        myProfileView = true;
      });
    }

    return file != null
        ? buildUploadScreen(pictureType)
        : FutureBuilder<Object>(
            future: usersRef.doc(widget.profileId).get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return circularProgress();
              }
              myUser user = myUser.fromDocument(snapshot.data);

              if (user.profilePicture != "") {
                profilePhotoExist = true;
              }

              if (user.coverPhoto != "") {
                coverPhotoExist = true;
              }

              return Scaffold(
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
                    child: Image.asset(
                      'assets/images/MentorXP.png',
                      height: 100,
                    ),
                  ),
                ),
                body: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: coverPhotoHeight,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.white,
                                    width: 5,
                                  ),
                                ),
                              ),
                              child: coverPhotoExist
                                  ? CachedNetworkImage(
                                      imageUrl: user.coverPhoto,
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.fitWidth,
                                          ),
                                        ),
                                      ),
                                      placeholder: (context, url) =>
                                          Container(),
                                      errorWidget: (context, url, error) =>
                                          Container(),
                                    )
                                  : Image.asset(
                                      'assets/images/defaultCover.png',
                                      fit: BoxFit.fitWidth,
                                    ),
                            ),
                            Positioned(
                              top: top,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  profilePhotoExist
                                      ? CircleAvatar(
                                          backgroundColor: Colors.white,
                                          radius: profilePhotoHeight / 2,
                                          child: CachedNetworkImage(
                                            imageUrl: user.profilePicture,
                                            imageBuilder:
                                                (context, imageProvider) =>
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
                                                (context, url, error) => Icon(
                                              Icons.person,
                                              size: 50,
                                              color: kMentorXPSecondary,
                                            ),
                                          ),
                                        )
                                      : CircleAvatar(
                                          backgroundColor: Colors.white,
                                          radius: profilePhotoHeight / 2,
                                          child: ProfileImageCircle(
                                            iconSize: profilePhotoHeight / 2,
                                            circleSize:
                                                profilePhotoHeight / 2 * .95,
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
                                                "Profile Picture",
                                              );
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                color: Colors.white
                                                    .withOpacity(0.9),
                                              ),
                                              height: 35.0,
                                              width: 35.0,
                                              child: GestureDetector(
                                                child: Icon(
                                                  Icons.edit,
                                                  color: kMentorXPAccentDark,
                                                  size: 25,
                                                ),
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
                                    child: GestureDetector(
                                      onTap: () {
                                        selectImage(
                                          context,
                                          "Upload a Cover Photo",
                                          "Cover Photo",
                                        );
                                      },
                                      child: IconCircle(
                                        iconSize: 23.0,
                                        iconType: Icons.edit,
                                        circleColor: Colors.transparent,
                                        iconColor: kMentorXPAccentMed,
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 100.0),
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
                      ],
                    ),
                  ),
                ),
              );
            });
  }
}
