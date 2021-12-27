import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/icon_card.dart';
import 'package:mentorx_mvp/components/progress.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:mentorx_mvp/models/mentee_model.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/launch_screen.dart';
import 'package:mentorx_mvp/screens/mentoring/mentor_signup_screen.dart';
import 'package:mentorx_mvp/services/database.dart';

class MentoringScreen extends StatefulWidget {
  final myUser loggedInUser;
  static const String id = 'mentoring_screen';
  final Database database;

  const MentoringScreen({
    Key key,
    this.loggedInUser,
    this.database,
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
  List<Mentee> matches = [];

  @override
  void initState() {
    getMentorStatus();
    super.initState();
  }

  getMentorStatus() {
    setState(() {
      loggedInUser.mentor ? isMentor = true : isMentor = false;
      loggedInUser.mentee ? isMentee = true : isMentee = false;
    });
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

  buildUserMentees() {
    isLoading = true;
    QuerySnapshot _snapshot;
    return FutureBuilder(
      future: mentorsRef.doc(loggedInUser.id).collection('userMentoring').get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        } else {
          _snapshot = snapshot.data;
          if (_snapshot.size > 0) {
            matches =
                _snapshot.docs.map((doc) => Mentee.fromDocument(doc)).toList();
            return ListView(
              children: <Widget>[Column(children: matches)],
            );
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 25),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 75,
                    ),
                    Text(
                      'You do not have any mentees yet. You will be notified when you do!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.headline1.color,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        }
      },
    );
  }

  buildRoleSelection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Select your role in the program',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline1,
        ),
        SizedBox(height: 50),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconCard(
              cardIcon: Icons.group,
              boxHeight: MediaQuery.of(context).size.width * 0.33,
              boxWidth: MediaQuery.of(context).size.width * 0.33,
              cardColor: mentorSelected
                  ? Colors.grey[400]
                  : Theme.of(context).cardColor,
              borderColor: mentorSelected
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).buttonTheme.colorScheme.primary,
              borderWidth: 5,
              cardText: 'Be a Mentor',
              textSize: 15,
              onTap: () => setChoice('mentor'),
            ),
            IconCard(
              cardIcon: Icons.school,
              boxHeight: MediaQuery.of(context).size.width * 0.33,
              boxWidth: MediaQuery.of(context).size.width * 0.33,
              cardColor: menteeSelected
                  ? Colors.grey[400]
                  : Theme.of(context).cardColor,
              borderColor: menteeSelected
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).buttonTheme.colorScheme.primary,
              borderWidth: 5,
              cardText: 'Be a Mentee',
              textSize: 15,
              onTap: () => setChoice('mentee'),
            ),
          ],
        ),
        RoundedButton(
          title: 'Continue',
          fontSize: 24,
          fontColor: Theme.of(context).textTheme.button.color,
          buttonColor: Theme.of(context).colorScheme.primary,
          minWidth: MediaQuery.of(context).size.width * 0.5,
          onPressed: () => (menteeSelected | mentorSelected)
              ? {
                  Navigator.push(
                    context,
                    mentorSelected
                        ? MaterialPageRoute(
                            builder: (context) => MentorSignupScreen(),
                          )
                        : MaterialPageRoute(
                            builder: (context) => MentorSignupScreen(),
                          ),
                  )
                }
              : {},
        ),
        TextButton(
          onPressed: () => {Navigator.pop(context)},
          child: Text(
            'Cancel',
            style: TextStyle(
              fontSize: 24,
              decoration: TextDecoration.underline,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeData.light().scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 5,
        title: Text('Mentoring Screen'),
      ),
      body: (isMentee | isMentor) ? buildUserMentees() : buildRoleSelection(),
    );
  }
}
