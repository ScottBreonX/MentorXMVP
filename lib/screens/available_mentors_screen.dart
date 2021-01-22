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
          .collection('availableMentors')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: kMentorXTeal,
            ),
          );
        }

        final availableMentors = snapshot.data.docs;
        List<AvailableMentorBubble> availableMentorBubbles = [];

        for (var availableMentor in availableMentors) {
          final availableMentorData = availableMentor.data();

          final mentorUID = availableMentorData['UID'];
          final mentorSlots = availableMentorData['Available Slots'];
          final mentorFname = 'Scott';

          final availableMentorBubble = AvailableMentorBubble(
            mentorUID: mentorUID,
            mentorSlots: mentorSlots,
            mentorFname: mentorFname,
          );
          availableMentorBubbles.add(availableMentorBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 20.0,
            ),
            children: availableMentorBubbles,
          ),
        );
      },
    );
  }
}

class AvailableMentorBubble extends StatelessWidget {
  AvailableMentorBubble({this.mentorUID, this.mentorSlots, this.mentorFname});

  final String mentorUID;
  final int mentorSlots;
  final String mentorFname;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$mentorUID $mentorFname',
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
