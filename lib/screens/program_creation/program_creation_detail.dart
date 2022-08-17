import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mentorx_mvp/components/icon_card.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/home_screen/home_screen.dart';
import 'package:mentorx_mvp/screens/programs/program_launch/program_enrollment_screen.dart';
import '../../components/progress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Im;
import 'package:uuid/uuid.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');
final Reference storageRef = FirebaseStorage.instance.ref();

class ProgramCreationDetail extends StatefulWidget {
  final myUser loggedInUser;
  final String programUID;
  final String programLogo;

  const ProgramCreationDetail({
    Key key,
    this.loggedInUser,
    @required this.programUID,
    this.programLogo,
  }) : super(key: key);

  static const String id = 'program_creation_detail';

  @override
  _ProgramCreationDetailState createState() => _ProgramCreationDetailState();
}

class _ProgramCreationDetailState extends State<ProgramCreationDetail> {
  @override
  void initState() {
    super.initState();
  }

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

  savePhotoInUserCollection({String mediaUrl}) {
    programsRef.doc(widget.programUID).update({'programLogo': mediaUrl});
    setState(() {
      file = null;
      isUploading = false;
    });
    Navigator.pop(context);
    _successScreen(context);
  }

  handleSubmit() async {
    setState(() {
      isUploading = true;
    });
    await compressImage();
    String mediaUrl = await uploadImage(file);
    savePhotoInUserCollection(mediaUrl: mediaUrl);
  }

  Scaffold buildUploadScreen() {
    return Scaffold(
        appBar: AppBar(
          title: Text("Upload Program Logo"),
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
                  child: Padding(
                    padding: const EdgeInsets.only(top: 100.0),
                    child: Column(
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
                                'Program Logo',
                                style: Theme.of(context).textTheme.headline1,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        IconCard(
                          cardColor: Colors.white,
                          textSize: 0,
                          imageAsset: Image.file(
                            file,
                            width: 150,
                            height: 150,
                            fit: BoxFit.fill,
                          ),
                          boxHeight: 200,
                          boxWidth: 200,
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
                                        setState(() {
                                          clearImage();
                                        });
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
            ),
          ],
        ));
  }

  _successScreen(parentContext) {
    setState(() {
      isLoading = false;
    });

    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Center(
              child: Text(
                'Success!',
                style: TextStyle(
                  fontFamily: 'Work Sans',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.pink,
                ),
              ),
            ),
            children: <Widget>[
              SimpleDialogOption(
                child: Row(
                  children: [
                    Container(
                      width: 250,
                      child: Column(
                        children: [
                          Text(
                            'Program successfully created!',
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SimpleDialogOption(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RoundedButton(
                      title: 'Return to Home',
                      buttonColor: Colors.pink,
                      fontColor: Colors.white,
                      minWidth: 200,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        });
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();

    return file != null
        ? buildUploadScreen()
        : FutureBuilder<Object>(
            future: programsRef.doc(widget.programUID).get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return circularProgress();
              }
              // Program program = Program.fromDocument(snapshot.data);

              return FutureBuilder<Object>(
                  future: usersRef.doc(widget.loggedInUser.id).get(),
                  builder: (context, snapshot) {
                    if (isLoading == true) {
                      return circularProgress();
                    }
                    if (!snapshot.hasData) {
                      return circularProgress();
                    }
                    return Scaffold(
                      key: _scaffoldKey,
                      appBar: AppBar(
                        elevation: 5,
                        title: Image.asset(
                          'assets/images/MentorPinkWhite.png',
                          height: 150,
                        ),
                      ),
                      body: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 100.0, bottom: 20.0),
                              child: Text(
                                'Update Program Logo?',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Work Sans',
                                  fontSize: 30,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: IconCard(
                                    cardColor: Colors.white,
                                    imageAsset: widget.programLogo == null ||
                                            widget.programLogo.isEmpty ||
                                            widget.programLogo == ""
                                        ? Image.asset(
                                            'assets/images/MLogoPink.png',
                                            height: 120,
                                            width: 120,
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                    cachedNetworkImage: widget.programLogo ==
                                                null ||
                                            widget.programLogo.isEmpty ||
                                            widget.programLogo == ""
                                        ? null
                                        : CachedNetworkImage(
                                            imageUrl: widget.programLogo,
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              height: 125.0,
                                              width: 125,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            placeholder: (context, url) =>
                                                circularProgress(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Image.asset(
                                              'assets/images/MLogoBlue.png',
                                              height: 120,
                                              width: 120,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                    textSize: 0,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 20.0, left: 30, right: 30),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ButtonCard(
                                    buttonCardText: 'Upload Logo',
                                    cardAlignment: MainAxisAlignment.center,
                                    cardIconBool: Container(),
                                    buttonCardHeight: 70,
                                    buttonCardColor: Colors.pink,
                                    buttonCardTextColor: Colors.white,
                                    buttonCardTextSize: 25,
                                    buttonCardRadius: 20,
                                    onPressed: () async {
                                      await selectImage(context, 'Upload Logo');
                                    },
                                  ),
                                  ButtonCard(
                                    buttonCardText: 'Not Now',
                                    cardAlignment: MainAxisAlignment.center,
                                    cardIconBool: Container(),
                                    buttonCardHeight: 70,
                                    buttonCardColor: Colors.white,
                                    buttonCardTextColor: Colors.pink,
                                    buttonCardTextSize: 25,
                                    buttonCardRadius: 20,
                                    onPressed: () {
                                      _successScreen(context);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            });
  }
}
