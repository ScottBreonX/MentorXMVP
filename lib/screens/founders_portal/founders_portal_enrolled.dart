import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mentorx_mvp/components/profile_card.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

final usersRef = FirebaseFirestore.instance.collection('users');

class FoundersPortalEnrolledScreen extends StatefulWidget {
  final myUser loggedInUser;
  static const String id = 'founders_portal_enrolled';

  FoundersPortalEnrolledScreen({
    this.loggedInUser,
  });

  @override
  _FoundersPortalEnrolledScreenState createState() =>
      _FoundersPortalEnrolledScreenState();
}

class _FoundersPortalEnrolledScreenState
    extends State<FoundersPortalEnrolledScreen> {
  bool showSpinner = false;
  bool isLoading = true;

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
                  'Enrolled in a Program',
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
                EnrolledDetailStream(
                  loggedInUser: widget.loggedInUser,
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

class EnrolledDetailStream extends StatelessWidget {
  EnrolledDetailStream({
    this.loggedInUser,
  });

  final myUser loggedInUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: usersRef
            .where("Program", isNotEqualTo: "")
            .orderBy("Program")
            .orderBy("First Name")
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
          }
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
