import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/icon_card.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:mentorx_mvp/models/enrollment_model.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/launch_screen.dart';
import 'package:mentorx_mvp/screens/mentoring/mentee_signup_screen.dart';
import 'package:mentorx_mvp/screens/mentoring/mentor_signup_screen.dart';
import 'package:mentorx_mvp/services/database.dart';

import '../../components/progress.dart';
import '../../models/mentoring_model.dart';

final programsRef = FirebaseFirestore.instance.collection('institutions');

class MentoringScreen extends StatefulWidget {
  final myUser loggedInUser;
  static const String id = 'mentoring_screen';
  final Database database;
  final String programUID;

  const MentoringScreen({
    Key key,
    this.loggedInUser,
    this.database,
    this.programUID,
  }) : super(key: key);

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
    QuerySnapshot snapshot =
        await mentorsRef.doc(loggedInUser.id).collection('userMentoring').get();
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
            .doc(loggedInUser.id)
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
                    fontFamily: 'WorkSans',
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
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
                        cardColor: mentorSelected ? Colors.blue : Colors.grey,
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
                        cardColor: menteeSelected ? Colors.blue : Colors.grey,
                        boxShadowColor: menteeSelected
                            ? Colors.grey[700]
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
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: RoundedButton(
                    title: 'Continue',
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    fontColor: Theme.of(context).textTheme.button.color,
                    buttonColor: Colors.blue,
                    minWidth: MediaQuery.of(context).size.width * 0.7,
                    onPressed: () => (menteeSelected | mentorSelected)
                        ? {
                            Navigator.push(
                              context,
                              mentorSelected
                                  ? MaterialPageRoute(
                                      builder: (context) => MentorSignupScreen(
                                        programUID: widget.programUID,
                                      ),
                                    )
                                  : MaterialPageRoute(
                                      builder: (context) => MenteeSignupScreen(
                                        programUID: widget.programUID,
                                      ),
                                    ),
                            )
                          }
                        : {},
                  ),
                ),
                RoundedButton(
                  onPressed: () => {Navigator.pop(context)},
                  buttonColor: Colors.white,
                  fontColor: Colors.blue,
                  minWidth: MediaQuery.of(context).size.width * .7,
                  fontSize: 24,
                  title: 'Cancel',
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
        title: Image.asset(
          'assets/images/MentorPinkWhite.png',
          height: 150,
        ),
      ),
      body: buildRoleSelection(),
    );
  }
}
