import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mentorx_mvp/components/profile_card.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/models/mentor_match_models/mentor_model.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');

class ProgramAdminStatsDetailScreen extends StatefulWidget {
  final myUser loggedInUser;
  final String programUID;
  static const String id = 'program_admin_stats_detail';

  ProgramAdminStatsDetailScreen({
    this.loggedInUser,
    this.programUID,
  });

  @override
  _ProgramAdminStatsDetailScreenState createState() =>
      _ProgramAdminStatsDetailScreenState();
}

class _ProgramAdminStatsDetailScreenState
    extends State<ProgramAdminStatsDetailScreen> {
  bool showSpinner = false;
  bool isLoading = true;
  List<Mentor> mentors = [];

  @override
  void initState() {
    super.initState();
  }

  buildUserListContent(myUser loggedInUser) {
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
                  'Users Enrolled',
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
                UserDetailStream(
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
      body: buildUserListContent(widget.loggedInUser),
    );
  }
}

class UserDetailStream extends StatelessWidget {
  UserDetailStream({
    this.loggedInUser,
    this.programUID,
  });

  final String programUID;
  final myUser loggedInUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: usersRef.where("Program", isEqualTo: programUID).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center();
          }

          final users = snapshot.data.docs;
          List<ProfileCard> userBubbles = [];

          for (var user in users) {
            myUser userModel = myUser.fromDocument(user);

            final userBubble = ProfileCard(
              profilePicture: userModel.profilePicture,
              user: userModel,
            );
            userBubbles.add(userBubble);
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: Container(
              child: SingleChildScrollView(
                child: Column(
                  children: userBubbles,
                ),
              ),
            ),
          );
        });
  }
}
