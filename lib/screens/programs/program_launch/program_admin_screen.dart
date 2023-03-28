import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/program_creation/program_creation_detail.dart';
import 'package:mentorx_mvp/screens/programs/program_launch/program_launch_screen.dart';
import '../../../components/alert_dialog.dart';
import '../../../components/icon_circle.dart';
import '../../../components/progress.dart';
import '../../../components/rounded_button.dart';
import '../../../constants.dart';
import '../../../models/program.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');

class ProgramAdminScreen extends StatefulWidget {
  final myUser loggedInUser;
  final String programUID;
  final String enrollmentType;
  final String programCode;
  final String programName;
  final String institutionName;
  final String aboutProgram;

  const ProgramAdminScreen({
    Key key,
    this.loggedInUser,
    this.programUID,
    this.enrollmentType,
    this.programCode,
    this.programName,
    this.institutionName,
    this.aboutProgram,
  }) : super(key: key);

  static const String id = 'program_admin_screen';

  @override
  _ProgramAdminScreenState createState() => _ProgramAdminScreenState();
}

class _ProgramAdminScreenState extends State<ProgramAdminScreen> {
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey4 = GlobalKey<FormState>();
  final _formKey6 = GlobalKey<FormState>();

  String institutionName;
  String programType;
  String aboutProgram;
  String headAdmin;
  String programName;
  String programCode;

  @override
  void initState() {
    super.initState();
    institutionName = widget.institutionName;
    programType = widget.enrollmentType;
    aboutProgram = widget.aboutProgram;
    programName = widget.programName;
    programCode = widget.programCode;
  }

  TextFormField _buildTextField(
    BuildContext context,
    Key _key,
    String fieldName,
    String labelText,
    Icon _prefixIcon,
    String initialValueText,
  ) {
    return TextFormField(
      key: _key,
      initialValue: initialValueText,
      textInputAction: TextInputAction.next,
      textAlign: TextAlign.left,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      onChanged: (value) {
        setState(() {});
        if (fieldName == 'institutionName') {
          institutionName = value;
        } else if (fieldName == 'aboutProgram') {
          aboutProgram = value;
        } else if (fieldName == 'programName') {
          programName = value;
        } else if (fieldName == 'programCode') {
          programCode = value;
        }
      },
      style: TextStyle(
        color: Colors.black45,
        fontSize: 15,
        fontWeight: FontWeight.w400,
      ),
      autocorrect: false,
      decoration: kTextFieldDecorationLight.copyWith(
        prefixIcon: _prefixIcon,
        prefixIconColor: kMentorXPSecondary,
        labelText: '$labelText',
        alignLabelWithHint: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelStyle: TextStyle(color: Colors.grey.shade400),
        hintStyle: TextStyle(color: Colors.grey.shade400),
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kMentorXPAccentDark, width: 4.0),
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
      ),
    );
  }

  Future<void> _updateProgram(
    BuildContext context,
  ) async {
    try {
      await programsRef.doc(widget.programUID).update({
        "aboutProgram": aboutProgram,
        "institutionName": institutionName,
        "programName": programName,
        "programCode": programCode,
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProgramLaunchScreen(
                    loggedInUser: widget.loggedInUser,
                    programUID: widget.programUID,
                  )));
    } on FirebaseException catch (e) {
      showAlertDialog(context,
          title: 'Operation Failed', content: '$e', defaultActionText: 'Ok');
    }
  }

  // Future<void> _adminCollection(
  //   BuildContext context,
  // ) async {
  //   try {
  //     QueryDocumentSnapshot<Map<String, dynamic>> queryDocumentSnapshot;
  //     await programsRef
  //         .doc(widget.programUID)
  //         .collection('programAdmins')
  //         .get()
  //         .then((querySnapshot) =>
  //             {queryDocumentSnapshot = querySnapshot.docs[0]});
  //     print(queryDocumentSnapshot);
  //   } on FirebaseException catch (e) {
  //     showAlertDialog(context,
  //         title: 'Operation Failed', content: '$e', defaultActionText: 'Ok');
  //   }
  // }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();
    return FutureBuilder<Object>(
        future: programsRef.doc(widget.programUID).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          Program program = Program.fromDocument(snapshot.data);

          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              backgroundColor: kMentorXPPrimary,
              elevation: 5,
              title: Image.asset(
                'assets/images/MentorXP.png',
                height: 100,
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Column(
                            children: [
                              program.programLogo == null ||
                                      program.programLogo.isEmpty ||
                                      program.programLogo == ""
                                  ? Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.transparent,
                                            width: 4),
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white,
                                      ),
                                      child: Image.asset(
                                        'assets/images/MXPDark.png',
                                        height: 120,
                                        width: 120,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 5,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white,
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: program.programLogo,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          height: 120.0,
                                          width: 120,
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
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                          'assets/images/MentorXP.png',
                                          height: 120,
                                          width: 120,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 20.0, bottom: 20.0),
                          child: Text(
                            'Edit Program Info',
                            style: TextStyle(
                              fontFamily: 'Work Sans',
                              fontSize: 25,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _buildTextField(
                            context,
                            _formKey1,
                            'programName',
                            'Name of Program',
                            Icon(Icons.edit),
                            program.programName,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _buildTextField(
                            context,
                            _formKey2,
                            'institutionName',
                            'Institution or College',
                            Icon(Icons.school),
                            program.institutionName,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _buildTextField(
                            context,
                            _formKey4,
                            'aboutProgram',
                            'Description of Program',
                            Icon(Icons.edit),
                            program.aboutProgram,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _buildTextField(
                            context,
                            _formKey6,
                            'programCode',
                            'Program Password',
                            Icon(Icons.key),
                            program.programCode,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20, left: 10.0, right: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RoundedButton(
                                title: 'Cancel',
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                buttonColor: Colors.white,
                                fontColor: kMentorXPSecondary,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                minWidth: 160,
                              ),
                              RoundedButton(
                                title: 'Save',
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                buttonColor: kMentorXPSecondary,
                                fontColor: Colors.white,
                                onPressed: () async {
                                  await _updateProgram(context);
                                },
                                minWidth: 160,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 100,
                      right: 100,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProgramCreationDetail(
                                loggedInUser: widget.loggedInUser,
                                programUID: widget.programUID,
                                programLogo: program.programLogo,
                              ),
                            ),
                          );
                        },
                        child: IconCircle(
                          height: 40.0,
                          width: 40.0,
                          iconSize: 30.0,
                          iconType: Icons.camera_alt,
                          circleColor: Colors.white,
                          iconColor: kMentorXPAccentDark,
                        ),
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
