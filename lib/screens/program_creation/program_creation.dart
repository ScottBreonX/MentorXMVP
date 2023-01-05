import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/program_creation/program_creation_detail.dart';
import '../../components/alert_dialog.dart';
import '../../components/progress.dart';
import '../../constants.dart';
import '../../models/program.dart';
import '../../services/database.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');

class ProgramCreation extends StatefulWidget {
  final myUser loggedInUser;

  static const String id = 'program_creation';

  const ProgramCreation({
    this.loggedInUser,
  });

  @override
  _ProgramCreationState createState() => _ProgramCreationState();
}

class _ProgramCreationState extends State<ProgramCreation> {
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey4 = GlobalKey<FormState>();
  final _formKey6 = GlobalKey<FormState>();

  String programID;
  String institutionName;
  String type;
  String enrollmentType = 'Private';
  String aboutProgram;
  String headAdmin;
  String programName;
  String programCode;
  bool programIDExists = false;

  final TextEditingController _textController1 = TextEditingController();
  final TextEditingController _textController2 = TextEditingController();
  final TextEditingController _textController4 = TextEditingController();
  final TextEditingController _textController6 = TextEditingController();

  Future<void> _createProgram(BuildContext context) async {
    try {
      final database = FirestoreDatabase();
      await database
          .createProgram(
            Program(
              institutionName: institutionName,
              type: 'school',
              enrollmentType: enrollmentType,
              aboutProgram: aboutProgram,
              headAdmin:
                  '${widget.loggedInUser.firstName} ${widget.loggedInUser.lastName}',
              programName: programName,
              programCode: programCode,
              programLogo: '',
            ),
          )
          .then((value) => programID = value);
    } on FirebaseException catch (e) {
      showAlertDialog(context,
          title: 'Operation Failed', content: '$e', defaultActionText: 'Ok');
    }
  }

  Future<void> _updateProgram(
    BuildContext context,
  ) async {
    try {
      final database = FirestoreDatabase();
      await database.updateProgram(
        Program(
          institutionName: institutionName,
          type: 'school',
          enrollmentType: enrollmentType,
          aboutProgram: aboutProgram,
          headAdmin:
              '${widget.loggedInUser.firstName} ${widget.loggedInUser.lastName}',
          programName: programName,
          programCode: programCode,
          programLogo: '',
        ),
        programID,
      );
    } on FirebaseException catch (e) {
      showAlertDialog(context,
          title: 'Operation Failed', content: '$e', defaultActionText: 'Ok');
    }
  }

  Future<void> _updateProgramID(String programID) async {
    try {
      await FirebaseFirestore.instance
          .collection('institutions')
          .doc(programID)
          .update({"id": programID});
      await programsRef
          .doc(programID)
          .collection('programAdmins')
          .doc(widget.loggedInUser.id)
          .set({});
    } on FirebaseException catch (e) {
      showAlertDialog(context,
          title: 'Operation Failed', content: '$e', defaultActionText: 'Ok');
    }
  }

  @override
  void initState() {
    super.initState();
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

  TextField _buildTextField(BuildContext context, Key _key, String fieldName,
      String labelText, Icon _prefixIcon, TextEditingController _textEditor) {
    return TextField(
      key: _key,
      controller: _textEditor,
      textInputAction: TextInputAction.next,
      textAlign: TextAlign.left,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      onChanged: (value) {
        setState(() {});
        if (fieldName == 'institutionName') {
          institutionName = value;
        } else if (fieldName == 'enrollmentType') {
          enrollmentType = value;
        } else if (fieldName == 'aboutProgram') {
          aboutProgram = value;
        } else if (fieldName == 'programName') {
          programName = value;
        } else if (fieldName == 'programCode') {
          programCode = value;
        }
      },
      style: TextStyle(
        color: Colors.black54,
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

  bool isLoading = false;

  final StringValidator instituionNameValidator = NonEmptyStringValidator();
  final StringValidator enrollmentTypeValidator = NonEmptyStringValidator();
  final StringValidator aboutProgramValidator = NonEmptyStringValidator();
  final StringValidator programNameValidator = NonEmptyStringValidator();
  final StringValidator programCodeValidator = NonEmptyStringValidator();

  bool get canSubmit {
    return instituionNameValidator.isValid(institutionName) &&
        aboutProgramValidator.isValid(aboutProgram) &&
        programNameValidator.isValid(programName) &&
        programCodeValidator.isValid(programCode);
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                      child: Text(
                        'Create a Program',
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
                          _textController1),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _buildTextField(
                          context,
                          _formKey2,
                          'institutionName',
                          'Institution or College',
                          Icon(Icons.school),
                          _textController2),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _buildTextField(
                        context,
                        _formKey4,
                        'aboutProgram',
                        'Description of Program',
                        Icon(Icons.edit),
                        _textController4,
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
                              fontWeight: FontWeight.w500,
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
                                value: enrollmentType,
                                style: TextStyle(
                                  fontFamily: 'Work Sans',
                                  fontSize: 20,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500,
                                ),
                                onChanged: (String newValue) {
                                  setState(() {
                                    enrollmentType = newValue;
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
                        _textController6,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 40, left: 10.0, right: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RoundedButton(
                            title: 'Cancel',
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            buttonColor: Colors.white,
                            fontColor: Colors.pink,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            minWidth: 160,
                          ),
                          RoundedButton(
                            title: 'Next',
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            buttonColor: canSubmit ? Colors.pink : Colors.grey,
                            fontColor:
                                canSubmit ? Colors.white : Colors.grey.shade400,
                            onPressed: canSubmit
                                ? () async {
                                    programIDExists
                                        ? print(programID)
                                        : await _createProgram(context);
                                    await _updateProgram(context);
                                    await _updateProgramID(programID);
                                    setState(() {
                                      programIDExists = true;
                                    });
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProgramCreationDetail(
                                                loggedInUser:
                                                    widget.loggedInUser,
                                                programUID: programID),
                                      ),
                                    );
                                    // await _successScreen(context);
                                  }
                                : null,
                            minWidth: 160,
                          ),
                        ],
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

abstract class StringValidator {
  bool isValid(String value);
}

class NonEmptyStringValidator implements StringValidator {
  @override
  bool isValid(String value) {
    if (value == null) {
      value = '';
    }
    return value.isNotEmpty;
  }
}
