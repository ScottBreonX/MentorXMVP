import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/models/program_list.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/program_creation/program_creation_detail.dart';
import 'package:mentorx_mvp/screens/programs/program_launch/program_launch_screen.dart';
import '../../../components/alert_dialog.dart';
import '../../../components/icon_circle.dart';
import '../../../components/progress.dart';
import '../../../components/rounded_button.dart';
import '../../../constants.dart';
import '../../../models/program.dart';

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

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 5.0, left: 5.0),
              child: Icon(Icons.public),
            ),
            Text("Public"),
          ],
        ),
        value: "Public",
        alignment: Alignment.center,
      ),
      DropdownMenuItem(
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 5.0, left: 5.0),
              child: Icon(Icons.lock),
            ),
            Text("Private"),
          ],
        ),
        value: "Private",
        alignment: Alignment.center,
      ),
    ];
    return menuItems;
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
        } else if (fieldName == 'enrollmentType') {
          programType = value;
        } else if (fieldName == 'aboutProgram') {
          aboutProgram = value;
        } else if (fieldName == 'programName') {
          programName = value;
        } else if (fieldName == 'programCode') {
          programCode = value;
        }
      },
      style: TextStyle(
        color: Colors.blue,
        fontSize: 15,
        fontWeight: FontWeight.w400,
      ),
      autocorrect: false,
      decoration: kTextFieldDecorationLight.copyWith(
        prefixIcon: _prefixIcon,
        labelText: '$labelText',
        alignLabelWithHint: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelStyle: TextStyle(color: Colors.grey.shade400),
        hintStyle: TextStyle(color: Colors.grey.shade400),
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 4.0),
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
        "enrollmentType": programType,
        "programName": programName,
        "programCode": programCode,
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProgramLaunchScreen(
                    programUID: widget.programUID,
                  )));
    } on FirebaseException catch (e) {
      showAlertDialog(context,
          title: 'Operation Failed', content: '$e', defaultActionText: 'Ok');
    }
  }

  Future<void> _adminCollection(
    BuildContext context,
  ) async {
    try {
      QueryDocumentSnapshot<Map<String, dynamic>> queryDocumentSnapshot;
      await programsRef
          .doc(widget.programUID)
          .collection('programAdmins')
          .get()
          .then((querySnapshot) =>
              {queryDocumentSnapshot = querySnapshot.docs[0]});
      print(queryDocumentSnapshot);
    } on FirebaseException catch (e) {
      showAlertDialog(context,
          title: 'Operation Failed', content: '$e', defaultActionText: 'Ok');
    }
  }

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
              elevation: 5,
              title: Image.asset(
                'assets/images/MentorPinkWhite.png',
                height: 150,
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
                                            color: Colors.blue, width: 4),
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white,
                                      ),
                                      child: Image.asset(
                                        'assets/images/MLogoPink.png',
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
                                          'assets/images/MLogoBlue.png',
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
                              fontWeight: FontWeight.bold,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 40, bottom: 40, left: 15.0, right: 20.0),
                              child: Text(
                                'Enrollment',
                                style: TextStyle(
                                  fontFamily: 'Work Sans',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black45,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                              child: Container(
                                width: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 2,
                                      offset: Offset(2, 3),
                                      color: Colors.grey[700],
                                    ),
                                  ],
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: DropdownButton(
                                    underline: Container(),
                                    isExpanded: true,
                                    dropdownColor: Colors.white,
                                    value: programType,
                                    style: TextStyle(
                                      fontFamily: 'Work Sans',
                                      fontSize: 20,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    onChanged: (String newValue) {
                                      setState(() {
                                        programType = newValue;
                                      });
                                    },
                                    items: dropdownItems,
                                  ),
                                ),
                              ),
                            ),
                          ],
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
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                buttonColor: Colors.white,
                                fontColor: Colors.pink,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                minWidth: 160,
                              ),
                              RoundedButton(
                                title: 'Save',
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                buttonColor: Colors.pink,
                                fontColor: Colors.white,
                                onPressed: () async {
                                  await _updateProgram(context);
                                  print('updated program');
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
                                programUID: program.id,
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
                          iconColor: Colors.blue,
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
