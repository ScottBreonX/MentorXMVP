import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mentorx_mvp/components/icon_circle.dart';
import 'package:mentorx_mvp/components/progress.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:mentorx_mvp/screens/launch_screen.dart';
import 'package:mentorx_mvp/screens/menu_bar/menu_bar.dart';
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
        this.file = file;
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

  selectImage(parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Upload a photo"),
            children: <Widget>[
              SimpleDialogOption(
                  child: Text("Photo with Camera"), onPressed: handleTakePhoto),
              SimpleDialogOption(
                  child: Text("Image from Gallery"),
                  onPressed: handleChooseFromGallery),
              SimpleDialogOption(
                child: Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }

  bool aboutMeEditStatus = false;
  bool coreProfileEditStatus = false;
  bool myProfileView = false;
  bool isUploading = false;
  String postId = Uuid().v4();

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
      ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 85));
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

  createPostInFirestore({String mediaUrl}) {
    usersRef.doc(loggedInUser.id).update({"Profile Picture": mediaUrl});
    setState(() {
      file = null;
      isUploading = false;
    });
  }

  handleSubmit() async {
    setState(() {
      isUploading = true;
    });
    await compressImage();
    String mediaUrl = await uploadImage(file);
    createPostInFirestore(mediaUrl: mediaUrl);
  }

  Scaffold buildUploadScreen() {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Upload Profile Picture",
          ),
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
                        child: Text(
                          'Confirm Upload',
                          style: Theme.of(context).textTheme.headline1,
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
                                          ));
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
                              onPressed:
                                  isUploading ? null : () => handleSubmit(),
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

    final drawerItems = MentorXMenuList();
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();
    return file != null
        ? buildUploadScreen()
        : FutureBuilder<Object>(
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
                              padding:
                                  const EdgeInsets.only(left: 8.0, top: 65.0),
                              child: Stack(
                                children: [
                                  CircleAvatar(
                                      backgroundColor: Colors.blue,
                                      radius: circleSize + 4,
                                      child: CachedNetworkImage(
                                        imageUrl: user.profilePicture,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          width: 110.0,
                                          height: 110.0,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            Icon(
                                          Icons.person,
                                          size: 50,
                                          color: Colors.white,
                                        ),
                                      )),
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
                                        onTap: () {
                                          selectImage(context);
                                        },
                                        child: Icon(
                                          Icons.add_a_photo,
                                          color:
                                              Theme.of(context).iconTheme.color,
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
                                      iconColor:
                                          Theme.of(context).iconTheme.color,
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
