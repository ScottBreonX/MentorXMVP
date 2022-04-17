import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/icon_card.dart';
import 'package:mentorx_mvp/components/progress.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:mentorx_mvp/models/profile_model.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/launch_screen.dart';
import 'package:mentorx_mvp/screens/mentoring/mentee_signup_screen.dart';
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

  buildUserConnections() {
    isLoading = true;
    QuerySnapshot _snapshot;
    return FutureBuilder(
      future: isMentor
          ? mentorsRef.doc(loggedInUser.id).collection('userMentees').get()
          : menteesRef.doc(loggedInUser.id).collection('userMentors').get(),
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
                      isMentor
                          ? 'You do not have any mentees yet. You will be notified when you do!'
                          : 'You do not have a mentor yet. You will be notified when you do!',
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
                  boxShadowColor:
                      mentorSelected ? Colors.grey[700] : Colors.white,
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
                  boxShadowColor:
                      menteeSelected ? Colors.grey[700] : Colors.white,
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
                                builder: (context) => MentorSignupScreen(),
                              )
                            : MaterialPageRoute(
                                builder: (context) => MenteeSignupScreen(),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeData.light().scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 5,
        title: Image.asset(
          'assets/images/MentorPinkWhite.png',
          height: 150,
        ),
      ),
      body:
          // (isMentee | isMentor) ? buildUserConnections() :
          buildRoleSelection(),
    );
  }
}
