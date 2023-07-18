import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mentorx_mvp/components/mentor_card.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/models/mentor_match_models/mentor_model.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/services/database.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../../components/profile_image_circle.dart';

final _firestore = FirebaseFirestore.instance;
final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');

class AvailableMentorsScreen extends StatefulWidget {
  final myUser loggedInUser;
  final String programUID;
  static const String id = 'available_mentors_screen';
  final Database database;

  AvailableMentorsScreen({
    this.loggedInUser,
    this.database,
    this.programUID,
  });

  @override
  _AvailableMentorsScreenState createState() => _AvailableMentorsScreenState();
}

class _AvailableMentorsScreenState extends State<AvailableMentorsScreen> {
  bool showSpinner = false;
  bool isLoading = true;
  int availableMentorCount = 0;
  List<Mentor> mentors = [];

  @override
  void initState() {
    super.initState();
  }

  buildMentorListContent(myUser loggedInUser) {
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
                  'Available Mentors',
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
                AvailableMentorsStream(
                  // searchString: searchString,
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
      // appBar: buildSearchField(),
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
      body: buildMentorListContent(widget.loggedInUser),
    );
  }
}

class AvailableMentorsStream extends StatelessWidget {
  AvailableMentorsStream({
    this.loggedInUser,
    this.programUID,
  });

  final String programUID;
  final myUser loggedInUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('institutions')
            .doc(programUID)
            .collection('mentors')
            .where('Mentor Slots', isGreaterThan: 0)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center();
          }

          final mentors = snapshot.data.docs;
          List<MentorCard> mentorBubbles = [];

          for (var mentor in mentors) {
            if (mentor.id == loggedInUser.id) {
              continue;
            }

            Mentor mentorModel = Mentor.fromDocument(mentor);

            final mentorBubble = MentorCard(
              loggedInUser: loggedInUser,
              mentorUID: mentorModel.id,
              programUID: programUID,
              mentorFname: mentorModel.fName,
              mentorLname: mentorModel.lName,
              mentorSlots: mentorModel.mentorSlots,
              mtrAtt1: mentorModel.mentorSkill1,
              mtrAtt2: mentorModel.mentorSkill2,
              mtrAtt3: mentorModel.mentorSkill3,
              mtrClass: mentorModel.mentorYearInSchool,
              xFactor: mentorModel.mentorExperience,
              previewStatus: false,
              imageContainer: Container(
                child: mentorModel.profilePicture == null ||
                        mentorModel.profilePicture.isEmpty ||
                        mentorModel.profilePicture == ""
                    ? ProfileImageCircle(
                        circleColor: Colors.grey,
                        iconSize: 45,
                        iconColor: Colors.white,
                        circleSize: 40,
                      )
                    : CircleAvatar(
                        radius: 40,
                        child: CachedNetworkImage(
                          imageUrl: mentorModel.profilePicture,
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
            mentorBubbles.add(mentorBubble);
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: Container(
              child: SingleChildScrollView(
                child: Column(
                  children: mentorBubbles,
                ),
              ),
            ),
          );
        });
  }
}
