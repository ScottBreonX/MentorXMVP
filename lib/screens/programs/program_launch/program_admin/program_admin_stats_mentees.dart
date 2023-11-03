import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../../../../components/mentor_card.dart';
import '../../../../components/profile_image_circle.dart';
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
            .orderBy("First Name")
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
          }
          if (!snapshot.hasData) {
            return Center();
          }

          final mentees = snapshot.data.docs;
          List<MentorCard> menteeBubbles = [];

          for (var mentee in mentees) {
            Mentee menteeModel = Mentee.fromDocument(mentee);

            final menteeBubble = MentorCard(
              loggedInUser: loggedInUser,
              mentorUID: menteeModel.id,
              programUID: programUID,
              mentorFname: menteeModel.fName,
              mentorLname: menteeModel.lName,
              mtrAtt1: menteeModel.menteeSkill1,
              mtrAtt2: menteeModel.menteeSkill2,
              mtrAtt3: menteeModel.menteeSkill3,
              mtrClass: menteeModel.menteeYearInSchool,
              xFactor: menteeModel.menteeExperience,
              previewStatus: false,
              imageContainer: Container(
                child: menteeModel.profilePicture == null ||
                        menteeModel.profilePicture.isEmpty ||
                        menteeModel.profilePicture == ""
                    ? ProfileImageCircle(
                        circleColor: Colors.grey,
                        iconSize: 45,
                        iconColor: Colors.white,
                        circleSize: 40,
                      )
                    : CircleAvatar(
                        radius: 40,
                        child: CachedNetworkImage(
                          imageUrl: menteeModel.profilePicture,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                      ),
              ),
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
