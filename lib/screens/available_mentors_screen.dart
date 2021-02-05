import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/sign_out.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../constants.dart';

User loggedInUser;
final _firestore = FirebaseFirestore.instance;

class AvailableMentors extends StatefulWidget {
  static const String id = 'available_mentors_screen';
  @override
  _AvailableMentorsScreenState createState() => _AvailableMentorsScreenState();
}

class _AvailableMentorsScreenState extends State<AvailableMentors> {
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
        backgroundColor: kMentorXTeal,
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
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: kMentorXTeal,
            ),
          );
        }

        final mentors = snapshot.data.docs;
        List<MentorBubble> mentorBubbles = [];

        for (var mentor in mentors) {
          final mentorData = mentor.data();

          final mentorUID = mentorData['UID'];
          final mentorSlots = mentorData['Available Slots'];
          final mentorFname = mentorData['First Name'];
          final mentorLname = mentorData['Last Name'];
          final mentorEmail = mentorData['Email Address'];

          final mentorBubble = MentorBubble(
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
            reverse: true,
            padding: EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 20.0,
            ),
            children: mentorBubbles,
          ),
        );
      },
    );
  }
}

class MentorBubble extends StatelessWidget {
  MentorBubble(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$mentorFname $mentorLname',
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
          Material(
            borderRadius: BorderRadius.circular(30.0),
            elevation: 5.0,
            color: kMentorXTeal,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 20.0,
              ),
              child: Text(
                '$mentorSlots',
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
