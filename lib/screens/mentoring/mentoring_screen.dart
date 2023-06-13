import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/icon_card.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/models/enrollment_model.dart';
import 'package:mentorx_mvp/screens/launch_screen.dart';
import 'package:mentorx_mvp/screens/mentoring/mentee_enrollment/mentee_enrollment_skills.dart';
import 'package:mentorx_mvp/screens/mentoring/mentor_enrollment/mentor_enrollment_background.dart';
import '../../components/alert_dialog.dart';
import '../../components/progress.dart';
import '../../models/mentoring_model.dart';
import '../../models/user.dart';
import '../programs/program_launch/program_enrollment_screen.dart';

final programsRef = FirebaseFirestore.instance.collection('institutions');

class MentoringScreen extends StatefulWidget {
  static const String id = 'mentoring_screen';
  final String programUID;
  final myUser loggedInUser;

  const MentoringScreen({Key key, this.programUID, this.loggedInUser})
      : super(key: key);

  @override
  _MentoringScreenState createState() => _MentoringScreenState();
}

class _MentoringScreenState extends State<MentoringScreen> {
  bool profilePhotoSelected = false;
  String roleChoice;
  bool isLoading = false;
  bool hasMentees = false;
  bool mentorSelected = false;
  bool menteeSelected = false;
  bool isMentor = false;
  bool isMentee = false;
  String enrollmentStatus;
  List<Mentee> matches = [];

  @override
  void initState() {
    super.initState();
  }

  Future<dynamic> getMatchData() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot snapshot = await mentorsRef
        .doc(widget.loggedInUser.id)
        .collection('userMentoring')
        .get();
    if (snapshot.docs.isNotEmpty) {
      setState(() {
        isLoading = false;
        hasMentees = true;
        matches = snapshot.docs.map((doc) => Mentee.fromDocument(doc)).toList();
      });
    }
  }

  setChoice(String selectedChoice) {
    roleChoice = selectedChoice;
    if (roleChoice == 'mentee') {
      setState(() {
        mentorSelected = false;
        menteeSelected = true;
      });
    } else if (roleChoice == 'mentor') {
      setState(() {
        mentorSelected = true;
        menteeSelected = false;
      });
    }
  }

  buildRoleSelection() {
    return FutureBuilder<Object>(
        future: programsRef
            .doc(widget.programUID)
            .collection('userSubscribed')
            .doc(widget.loggedInUser.id)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }

          EnrollmentModel enrollmentModel =
              EnrollmentModel.fromDocument(snapshot.data);

          if (roleChoice == null) {
            if (enrollmentModel.enrollmentStatus != null ||
                enrollmentModel.enrollmentStatus != '') {
              if (enrollmentModel.enrollmentStatus == "mentor") {
                mentorSelected = true;
                menteeSelected = false;
              } else if (enrollmentModel.enrollmentStatus == "mentee") {
                menteeSelected = true;
                mentorSelected = false;
              }
            }
          }

          return Padding(
            padding: const EdgeInsets.only(left: 40.0, right: 40.0, top: 100),
            child: Column(
              children: [
                Text(
                  'Select your role in the program',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40.0, bottom: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconCard(
                        cardIcon: Icons.group,
                        cardIconColor:
                            mentorSelected ? Colors.white : Colors.grey[400],
                        boxHeight: MediaQuery.of(context).size.width * 0.33,
                        boxWidth: MediaQuery.of(context).size.width * 0.33,
                        cardColor:
                            mentorSelected ? kMentorXPSecondary : Colors.grey,
                        cardText: 'Mentor',
                        cardTextColor:
                            mentorSelected ? Colors.white : Colors.grey[400],
                        boxShadowColor: mentorSelected
                            ? Colors.grey[700]
                            : Colors.grey.withOpacity(0),
                        textSize: 20,
                        onTap: () => setChoice('mentor'),
                      ),
                      IconCard(
                        cardIcon: Icons.school,
                        cardIconColor:
                            menteeSelected ? Colors.white : Colors.grey[400],
                        boxHeight: MediaQuery.of(context).size.width * 0.33,
                        boxWidth: MediaQuery.of(context).size.width * 0.33,
                        cardColor:
                            menteeSelected ? kMentorXPSecondary : Colors.grey,
                        boxShadowColor: menteeSelected
                            ? Colors.grey[800]
                            : Colors.grey.withOpacity(0),
                        cardText: 'Mentee',
                        cardTextColor:
                            menteeSelected ? Colors.white : Colors.grey[400],
                        textSize: 20,
                        onTap: () => setChoice('mentee'),
                      ),
                    ],
                  ),
                ),
                ButtonCard(
                  buttonCardText: 'Continue',
                  buttonCardHeight: 70,
                  buttonCardTextSize: 20,
                  buttonCardRadius: 20,
                  buttonCardColor: menteeSelected || mentorSelected
                      ? kMentorXPSecondary
                      : Colors.grey,
                  buttonCardTextColor: menteeSelected || mentorSelected
                      ? Colors.white
                      : Colors.grey.shade600,
                  cardAlignment: MainAxisAlignment.center,
                  cardIconBool: Container(),
                  onPressed: () => (menteeSelected | mentorSelected)
                      ? mentorSelected
                          ? _createMentor(
                              context, widget.programUID, widget.loggedInUser)
                          : createMentee(
                              context, widget.programUID, widget.loggedInUser)
                      : {},
                ),
                ButtonCard(
                  buttonCardHeight: 70,
                  buttonCardText: 'Cancel',
                  buttonCardTextSize: 20,
                  buttonCardRadius: 20,
                  buttonCardColor: Colors.white,
                  buttonCardTextColor: kMentorXPSecondary,
                  cardAlignment: MainAxisAlignment.center,
                  cardIconBool: Container(),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        backgroundColor: kMentorXPPrimary,
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
      body: buildRoleSelection(),
    );
  }
}

Future<void> createMentee(
    BuildContext context, String programUID, myUser loggedInUser) async {
  try {
    await programsRef
        .doc(programUID)
        .collection('userSubscribed')
        .doc(loggedInUser.id)
        .update({
      "enrollmentStatus": 'mentee',
    });
    await programsRef
        .doc(programUID)
        .collection('mentees')
        .doc(loggedInUser.id)
        .get()
        .then((docSnapshot) => !docSnapshot.exists
            ? {
                programsRef
                    .doc(programUID)
                    .collection('mentees')
                    .doc(loggedInUser.id)
                    .set({})
              }
            : {});

    await programsRef
        .doc(programUID)
        .collection('mentors')
        .doc(loggedInUser.id)
        .delete();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MenteeEnrollmentSkillsScreen(
          loggedInUser: loggedInUser,
          programUID: programUID,
        ),
      ),
    );
  } on FirebaseException catch (e) {
    showAlertDialog(context,
        title: 'Operation Failed', content: '$e', defaultActionText: 'Ok');
  }
}

Future<void> _createMentor(
    BuildContext context, String programUID, myUser loggedInUser) async {
  try {
    await programsRef
        .doc(programUID)
        .collection('userSubscribed')
        .doc(loggedInUser.id)
        .update({
      "enrollmentStatus": 'mentor',
    });
    await programsRef
        .doc(programUID)
        .collection('mentors')
        .doc(loggedInUser.id)
        .get()
        .then(
          (docSnapshot) => !docSnapshot.exists
              ? {
                  programsRef
                      .doc(programUID)
                      .collection('mentors')
                      .doc(loggedInUser.id)
                      .set({})
                }
              : {},
        );

    await programsRef
        .doc(programUID)
        .collection('mentees')
        .doc(loggedInUser.id)
        .delete();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MentorEnrollmentSkillsScreen(
          loggedInUser: loggedInUser,
          programUID: programUID,
        ),
      ),
    );
  } on FirebaseException catch (e) {
    showAlertDialog(context,
        title: 'Operation Failed', content: '$e', defaultActionText: 'Ok');
  }
}
