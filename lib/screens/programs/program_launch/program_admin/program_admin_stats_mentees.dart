import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mentorx_mvp/components/profile_card.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/models/mentor_match_models/mentor_model.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../../../../models/mentor_match_models/mentee_model.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');

class ProgramAdminStatsMenteesScreen extends StatefulWidget {
  final myUser loggedInUser;
  final String programUID;
  static const String id = 'program_admin_stats_mentees';

  ProgramAdminStatsMenteesScreen({
    this.loggedInUser,
    this.programUID,
  });

  @override
  _ProgramAdminStatsMenteesScreenState createState() =>
      _ProgramAdminStatsMenteesScreenState();
}

class _ProgramAdminStatsMenteesScreenState
    extends State<ProgramAdminStatsMenteesScreen> {
  bool showSpinner = false;
  bool isLoading = true;
  List<Mentor> mentors = [];

  @override
  void initState() {
    super.initState();
  }

  buildMenteeListContent(myUser loggedInUser) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Mentees Enrolled',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 35,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
                Divider(
                  indent: 30,
                  endIndent: 30,
                  color: Colors.black54,
                  thickness: 2,
                ),
                MenteeDetailStream(
                  loggedInUser: widget.loggedInUser,
                  programUID: widget.programUID,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
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
      body: buildMenteeListContent(widget.loggedInUser),
    );
  }
}

class MenteeDetailStream extends StatelessWidget {
  MenteeDetailStream({
    this.loggedInUser,
    this.programUID,
  });

  final String programUID;
  final myUser loggedInUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: programsRef
            .doc(programUID)
            .collection('mentees')
            // .orderBy("First Name")
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
          }
          if (!snapshot.hasData) {
            return Center();
          }

          final mentees = snapshot.data.docs;
          List<ProfileCard> menteeBubbles = [];

          for (var mentee in mentees) {
            Mentee menteeModel = Mentee.fromDocument(mentee);

            final menteeBubble = ProfileCard(
              profilePicture: menteeModel.profilePicture,
              user: mentee,
            );
            menteeBubbles.add(menteeBubble);
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: Container(
              child: SingleChildScrollView(
                child: Column(
                  children: menteeBubbles,
                ),
              ),
            ),
          );
        });
  }
}
