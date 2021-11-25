import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/alert_dialog.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:mentorx_mvp/components/sign_out.dart';
import 'package:mentorx_mvp/models/mentoring_model.dart';
import 'package:mentorx_mvp/screens/mentoring/mentoring_screen.dart';
import 'package:mentorx_mvp/services/database.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../../constants.dart';

User loggedInUser;
final _firestore = FirebaseFirestore.instance;

class AvailableMentorsScreenOld extends StatefulWidget {
  static const String id = 'available_mentors_screen_old';
  @override
  _AvailableMentorsScreenState createState() => _AvailableMentorsScreenState();
}

class _AvailableMentorsScreenState extends State<AvailableMentorsScreenOld> {
  final messageTextController = TextEditingController();
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  String messageText;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    getProfileData();
  }

  @override
  void dispose() {
    messageTextController.dispose();
    super.dispose();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  dynamic profileData;

  Future<dynamic> getProfileData() async {
    await FirebaseFirestore.instance
        .collection('users/${loggedInUser.uid}/profile')
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        setState(() {
          profileData = result.data();
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              confirmSignOut(context);
            },
          ),
        ],
        title: Text(
          'Available Mentors',
          style: TextStyle(fontSize: 15),
        ),
        backgroundColor: kMentorXPrimary,
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AvailableMentorsStream(),
            ],
          ),
        ),
      ),
    );
  }
}

class AvailableMentorsStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('mentoring')
          .doc('UniversityOfFlorida')
          .collection('mentors')
          .where('UID', isNotEqualTo: loggedInUser.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: kMentorXPrimary,
            ),
          );
        }

        final mentors = snapshot.data.docs
            .where((mentorData) => mentorData['Available Slots'] >= 1);

        List<MentorCardOld> mentorBubbles = [];

        for (var mentor in mentors) {
          final DocumentSnapshot mentorData = mentor;

          final mentorUID = mentorData['UID'];
          final mentorSlots = mentorData['Available Slots'];
          final mentorFname = mentorData['First Name'];
          final mentorLname = mentorData['Last Name'];
          final mentorEmail = mentorData['Email Address'];

          final mentorBubble = MentorCardOld(
            mentorUID: mentorUID,
            mentorSlots: mentorSlots,
            mentorFname: mentorFname,
            mentorLname: mentorLname,
            mentorEmail: mentorEmail,
          );
          mentorBubbles.add(mentorBubble);
        }
        return Expanded(
          child: ListView(
              padding: EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 10.0,
              ),
              children: mentorBubbles),
        );
      },
    );
  }
}

class MentorCardOld extends StatelessWidget {
  Future<void> _confirmMentorSelection(String mentorUID, BuildContext context,
      String mentorFName, String mentorLName) async {
    final didRequestMentor = await showAlertDialog(
      context,
      title: "Selection Confirmation",
      content: "Confirm selection of $mentorFname $mentorLname as Mentor?",
      defaultActionText: "Yes",
      cancelActionText: "No",
    );
    if (didRequestMentor == true) {
      _createMentorMatch(mentorUID);
    }
  }

  Future<void> _createMentorMatch(String mentorUID) async {
    try {
      final database =
          FirestoreDatabase(uid: loggedInUser.uid, mentorUID: mentorUID);
      await database.createMentorMatch(
        MentorMatchModel(
          menteeUID: loggedInUser.uid,
          mentorUID: mentorUID,
        ),
        mentorUID,
      );
      await database.createMatchID(
        MatchIDModel(
          mentorUID: mentorUID,
        ),
      );
      await FirebaseFirestore.instance
          .collection('mentoring')
          .doc('UniversityOfFlorida')
          .collection('mentors')
          .doc(mentorUID)
          .update({'Available Slots': mentorSlots - 1});
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  MentorCardOld(
      {this.mentorUID,
      this.mentorSlots,
      this.mentorFname,
      this.mentorLname,
      this.mentorEmail});

  final String mentorUID;
  final int mentorSlots;
  final String mentorFname;
  final String mentorLname;
  final String mentorEmail;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 250,
            child: Material(
              borderRadius: BorderRadius.circular(10.0),
              elevation: 5.0,
              color: Colors.grey,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 20.0,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$mentorFname $mentorLname',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Available Slots: $mentorSlots',
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RoundedButton(
                          title: 'View Profile',
                          buttonColor: kMentorXPrimary,
                          borderRadius: 10.0,
                          fontColor: Colors.white,
                          minWidth: 200,
                          onPressed: () {},
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RoundedButton(
                          title: 'Select Mentor',
                          buttonColor: kMentorXPrimary,
                          borderRadius: 10.0,
                          fontColor: Colors.white,
                          minWidth: 200,
                          onPressed: () async {
                            await _confirmMentorSelection(
                                mentorUID, context, mentorFname, mentorLname);
                            Navigator.pushNamed(context, MentoringScreen.id);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
