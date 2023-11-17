import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/mentoring/mentor_enrollment/mentor_enrollment_skills.dart';
import '../../../components/alert_dialog.dart';
import '../../../components/progress.dart';
import '../../../models/mentor_match_models/mentor_model.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');

class MentorEnrollmentBackgroundScreen extends StatefulWidget {
  final myUser loggedInUser;
  final String programUID;
  static const String id = 'mentor_enrollment_background_screen';

  const MentorEnrollmentBackgroundScreen({
    this.loggedInUser,
    this.programUID,
  });

  @override
  State<MentorEnrollmentBackgroundScreen> createState() =>
      _MentorEnrollmentBackgroundScreenState();
}

class _MentorEnrollmentBackgroundScreenState
    extends State<MentorEnrollmentBackgroundScreen> {
  Future<void> _updateMentorAttributes(BuildContext context, String programUID,
      String mentorExperienceText, String yearInSchoolText) async {
    setState(() {
      isLoading = true;
    });
    try {
      await programsRef
          .doc(widget.programUID)
          .collection('mentors')
          .doc(widget.loggedInUser.id)
          .update({
        "Mentor Experience": mentorExperienceText,
        "id": widget.loggedInUser.id,
        "First Name": widget.loggedInUser.firstName,
        "Last Name": widget.loggedInUser.lastName,
        "Profile Picture": widget.loggedInUser.profilePicture,
        "Mentor Year in School": yearInSchoolText,
      });
      setState(() {
        isLoading = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MentorEnrollmentSkillsScreen(
            loggedInUser: widget.loggedInUser,
            programUID: widget.programUID,
          ),
        ),
      );
    } on FirebaseException catch (e) {
      showAlertDialog(context,
          title: 'Operation Failed', content: '$e', defaultActionText: 'Ok');
    }
  }

  String mentorExperience;
  final _formKey2 = GlobalKey<FormState>();

  buildFreeFormField2({
    @required String hintString,
    @required IconData icon,
    @required int minLines,
    String currentFreeFormResponse,
  }) {
    return TextFormField(
      key: _formKey2,
      style: TextStyle(
        color: Colors.black54,
        fontFamily: 'Montserrat',
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
      autocorrect: true,
      initialValue: currentFreeFormResponse,
      onChanged: (value) => mentorExperience = value,
      textCapitalization: TextCapitalization.sentences,
      minLines: minLines,
      maxLines: minLines == null ? 1 : minLines + 1,
      decoration: InputDecoration(
        hintText: hintString,
        hintStyle: TextStyle(
            color: kMentorXPSecondary.withOpacity(
              0.3,
            ),
            fontSize: 20,
            fontFamily: 'Montserrat'),
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: Colors.black54,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: kMentorXPSecondary,
            width: 3.0,
          ),
        ),
        fillColor: Colors.white,
      ),
    );
  }

  List<String> items = [
    'Freshman',
    'Sophomore',
    'Junior',
    'Senior',
  ];

  String yearInSchool;
  bool yearInSchoolChanged = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
        future: programsRef
            .doc(widget.programUID)
            .collection('mentors')
            .doc(widget.loggedInUser.id)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress(Theme.of(context).primaryColor);
          }

          final mentor = snapshot.data;
          Mentor mentorSkills = Mentor.fromDocument(mentor);

          return Scaffold(
            appBar: AppBar(
              backgroundColor: kMentorXPPrimary,
              elevation: 5,
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
                Scrollbar(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 20.0, right: 20, top: 40),
                      child: Column(
                        children: [
                          Text(
                            'Mentor Enrollment',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 30,
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            'The following questions will help mentees select a mentor who best fits their needs.',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 20,
                              color: Colors.black54,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 20.0, bottom: 10),
                            child: Text(
                              'What experiences and skills could you share with prospective mentees?',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: kMentorXPSecondary,
                              ),
                            ),
                          ),
                          buildFreeFormField2(
                            hintString:
                                'Work experience, classes taken, internships...',
                            icon: Icons.key,
                            minLines: 5,
                            currentFreeFormResponse:
                                mentorSkills.mentorExperience,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 20.0, bottom: 10),
                            child: Column(
                              children: [
                                Text(
                                  'What year in school are you in this semester?',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: kMentorXPSecondary,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0, bottom: 10),
                                  child: dropDownSection(
                                    yearInSchoolOption: yearInSchool,
                                    inputFunction: (value) => setState(() {
                                      yearInSchool = value;
                                      yearInSchoolChanged = true;
                                    }),
                                    selectionChanged: yearInSchoolChanged,
                                    currentValue:
                                        mentorSkills.mentorYearInSchool,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RoundedButton(
                                title: '<-- Back',
                                buttonColor: Colors.white,
                                borderWidth: 2,
                                borderRadius: 20,
                                fontColor: kMentorXPSecondary,
                                fontWeight: FontWeight.w500,
                                minWidth: 150,
                                fontSize: 20,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              RoundedButton(
                                title: 'Next -->',
                                buttonColor: kMentorXPSecondary,
                                fontColor: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                borderRadius: 20,
                                minWidth: 150,
                                onPressed: () {
                                  _updateMentorAttributes(
                                    context,
                                    widget.programUID,
                                    mentorExperience ??
                                        mentorSkills.mentorExperience,
                                    yearInSchool ??
                                        mentorSkills.mentorYearInSchool,
                                  );
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                isLoading
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
            ),
          );
        });
  }

  DropdownButtonHideUnderline dropDownSection({
    String yearInSchoolOption,
    bool selectionChanged,
    String currentValue,
    final void Function(String) inputFunction,
  }) {
    return DropdownButtonHideUnderline(
      child: Column(
        children: [
          DropdownButton2(
            isExpanded: true,
            hint: Row(
              children: const [
                Expanded(
                  child: Text(
                    '<None Selected>',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            items: items
                .map((name) => DropdownMenuItem<String>(
                      value: name,
                      child: Row(
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontFamily: 'Montserrat',
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ))
                .toList(),
            value: selectionChanged ? yearInSchoolOption : currentValue,
            onChanged: inputFunction,
            icon: const Icon(
              Icons.arrow_drop_down_circle_rounded,
            ),
            iconSize: 30,
            iconEnabledColor: Colors.white,
            buttonHeight: 60,
            buttonPadding: const EdgeInsets.only(left: 14, right: 14),
            buttonDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white,
              ),
              color: (currentValue == null && yearInSchoolOption == null)
                  ? Colors.grey
                  : kMentorXPSecondary,
            ),
            buttonElevation: 4,
            itemHeight: 40,
            itemPadding: const EdgeInsets.only(left: 14, right: 14),
            dropdownMaxHeight: 200,
            dropdownOverButton: false,
            dropdownDecoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              border: Border.all(color: Colors.white),
              color: Colors.grey,
            ),
            dropdownElevation: 8,
            scrollbarRadius: const Radius.circular(50),
            scrollbarThickness: 15,
            scrollbarAlwaysShow: true,
            offset: const Offset(0, 13),
          ),
        ],
      ),
    );
  }
}
