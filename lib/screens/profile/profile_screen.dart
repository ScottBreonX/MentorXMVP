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
import 'package:mentorx_mvp/screens/launch_screen.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/profile/sections/about_me_section.dart';
import 'package:mentorx_mvp/screens/profile/sections/core_profile_section.dart';
import 'package:mentorx_mvp/screens/profile/sections/profile_mentee_section.dart';
import 'package:mentorx_mvp/screens/profile/sections/profile_mentor_section.dart';
import 'package:mentorx_mvp/screens/profile/sections/work_experience.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Im;
import 'package:uuid/uuid.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final Reference storageRef = FirebaseStorage.instance.ref();

class Profile extends StatefulWidget {
  final String loggedInUser;
  final String profileId;
  static String id = 'mentor_screen';

  Profile({this.profileId, this.loggedInUser});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File file;
  final imagePicker = ImagePicker();

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
              style: Theme.of(context).textTheme.headline4,
            ),
            children: <Widget>[
              SimpleDialogOption(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.camera_alt,
                          size: 30,
                          color: Colors.blue,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "Photo with Camera",
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      ),
                    ],
                  ),
                  onPressed: handleTakePhoto),
              SimpleDialogOption(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.photo,
                          size: 30,
                          color: Colors.blue,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "Image from Gallery",
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      ),
                    ],
                  ),
                  onPressed: handleChooseFromGallery),
              SimpleDialogOption(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.cancel,
                        size: 30,
                        color: Colors.red,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "Remove Current Photo",
                        style: Theme.of(context).textTheme.subtitle2,
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
                child: Text(
                  "Cancel",
                  style: Theme.of(context).textTheme.headline4,
                ),
                onPressed: () => Navigator.pop(context),
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
          builder: (context) => LaunchScreen(pageIndex: 0),
        ));
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LaunchScreen(pageIndex: 2),
        ));
  }

  removeCurrentPhoto(pictureType) {
    usersRef.doc(loggedInUser.id).update({pictureType: ""});
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LaunchScreen(pageIndex: 2),
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
        print(pictureType);
        isCoverPhoto = true;
      });
    }

    print("$pictureType Upload Screen");
    print(isCoverPhoto);
    return Scaffold(
        appBar: AppBar(
          title: Text(
              isCoverPhoto ? "Upload Cover Photo" : "Upload Profile Picture"),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                child: Icon(Icons.cancel_rounded),
                onTap: () => Navigator.pop(context),
              ),
            ),
          ],
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
                              fontWeight: FontWeight.bold,
                              onPressed: isUploading
                                  ? null
                                  : () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              LaunchScreen(pageIndex: 2),
                                        ),
                                      );
                                    },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RoundedButton(
                              title: 'Upload',
                              buttonColor: Colors.blue,
                              fontColor: Colors.white,
                              minWidth: 150,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
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
    if (widget.profileId == null) {
      return circularProgress();
    }

    if (widget.profileId == loggedInUser.id) {
      setState(() {
        myProfileView = true;
      });
    }

    double circleSize = 55.0;

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
                  elevation: 5,
                  title: Image.asset(
                    'assets/images/MentorPinkWhite.png',
                    height: 150,
                  ),
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
                              child: coverPhotoExist
                                  ? CachedNetworkImage(
                                      imageUrl: user.coverPhoto,
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        width: 125.0,
                                        height: 125.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      placeholder: (context, url) =>
                                          circularProgress(),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                        'assets/images/MLogoBlue.png',
                                        fit: BoxFit.fitHeight,
                                      ),
                                    )
                                  : Image.asset(
                                      'assets/images/MLogoBlue.png',
                                      fit: BoxFit.fitHeight,
                                    ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, top: 65.0),
                              child: Stack(
                                children: [
                                  profilePhotoExist
                                      ? CircleAvatar(
                                          backgroundColor: Colors.white,
                                          radius: circleSize + 10,
                                          child: CachedNetworkImage(
                                            imageUrl: user.profilePicture,
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              width: 125.0,
                                              height: 125.0,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover),
                                              ),
                                            ),
                                            placeholder: (context, url) =>
                                                CircularProgressIndicator(),
                                            errorWidget:
                                                (context, url, error) => Icon(
                                              Icons.person,
                                              size: 50,
                                              color: Colors.blue,
                                            ),
                                          ),
                                        )
                                      : CircleAvatar(
                                          backgroundColor: Colors.white,
                                          radius: circleSize + 3,
                                          child: ProfileImageCircle(
                                            iconSize: circleSize,
                                            circleSize: circleSize,
                                            circleColor: Colors.grey,
                                          ),
                                        ),
                                  Positioned(
                                    bottom: 0,
                                    right: 5,
                                    child: !myProfileView
                                        ? Text("")
                                        : Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Colors.white,
                                            ),
                                            height: 35.0,
                                            width: 35.0,
                                            child: GestureDetector(
                                              onTap: () {
                                                selectImage(
                                                    context,
                                                    "Upload a Profile Photo",
                                                    "Profile Picture");
                                              },
                                              child: Icon(
                                                Icons.add_a_photo,
                                                color: Theme.of(context)
                                                    .iconTheme
                                                    .color,
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
                                            "Cover Photo");
                                      },
                                      child: IconCircle(
                                        height: 30.0,
                                        width: 30.0,
                                        iconSize: 20.0,
                                        iconType: Icons.camera_alt,
                                        circleColor:
                                            Theme.of(context).backgroundColor,
                                        iconColor:
                                            Theme.of(context).iconTheme.color,
                                      ),
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
                              padding:
                                  const EdgeInsets.only(left: 8.0, top: 8.0),
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
