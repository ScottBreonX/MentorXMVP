import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/models/user.dart';
import '../../../../components/mentor_card.dart';
import '../../../../components/profile_image_circle.dart';
import '../../../../components/progress.dart';
import '../../../../models/mentor_match_models/mentee_model.dart';
import '../../../../models/mentor_match_models/mentor_model.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');

class MentoringProfileScreen extends StatefulWidget {
  final myUser loggedInUser;
  final String programUID;
  final String mentorUID;
  final bool mentorStatus;
  static const String id = 'mentoring_profile_cards_screen';

  const MentoringProfileScreen({
    this.loggedInUser,
    this.programUID,
    this.mentorUID,
    this.mentorStatus,
  });

  @override
  State<MentoringProfileScreen> createState() => _MentoringProfileScreenState();
}

class _MentoringProfileScreenState extends State<MentoringProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
        future: programsRef
            .doc(widget.programUID)
            .collection('mentors')
            .doc(
                widget.mentorStatus ? widget.loggedInUser.id : widget.mentorUID)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress(Theme.of(context).primaryColor);
          }
          final mentor = snapshot.data;
          Mentor mentorSkills = Mentor.fromDocument(mentor);
          return FutureBuilder<Object>(
              future: programsRef
                  .doc(widget.programUID)
                  .collection('mentees')
                  .doc(widget.mentorStatus
                      ? widget.mentorUID
                      : widget.loggedInUser.id)
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return circularProgress(Theme.of(context).primaryColor);
                }

                final mentee = snapshot.data;
                Mentee menteeSkills = Mentee.fromDocument(mentee);

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
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20, top: 20, bottom: 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  'Mentor',
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontFamily: 'Montserrat',
                                    color: kMentorXPAccentDark,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          MentorCard(
                            mentorUID: widget.loggedInUser.id,
                            mentorFname: mentorSkills.fName,
                            mentorLname: mentorSkills.lName,
                            mtrAtt1: mentorSkills.mentorSkill1,
                            mtrAtt2: mentorSkills.mentorSkill2,
                            mtrAtt3: mentorSkills.mentorSkill3,
                            mtrClass: mentorSkills.mentorYearInSchool,
                            xFactor: mentorSkills.mentorExperience,
                            menteePreview: true,
                            previewStatus: true,
                            imageContainer: Container(
                              child: mentorSkills.profilePicture == null ||
                                      mentorSkills.profilePicture.isEmpty ||
                                      mentorSkills.profilePicture == ""
                                  ? ProfileImageCircle(
                                      circleColor: Colors.grey,
                                      iconSize: 45,
                                      iconColor: Colors.white,
                                      circleSize: 40,
                                    )
                                  : CircleAvatar(
                                      radius: 40,
                                      child: CachedNetworkImage(
                                        imageUrl: mentorSkills.profilePicture,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
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
                                        errorWidget: (context, url, error) =>
                                            Icon(
                                          Icons.person,
                                          size: 50,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 20, left: 10.0),
                                child: Text(
                                  'Mentee',
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontFamily: 'Montserrat',
                                    color: kMentorXPSecondary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          MentorCard(
                            mentorUID: widget.loggedInUser.id,
                            mentorFname: menteeSkills.fName,
                            mentorLname: menteeSkills.lName,
                            mtrAtt1: menteeSkills.menteeSkill1,
                            mtrAtt2: menteeSkills.menteeSkill2,
                            mtrAtt3: menteeSkills.menteeSkill3,
                            mtrClass: menteeSkills.menteeYearInSchool,
                            xFactor: menteeSkills.menteeExperience,
                            menteePreview: true,
                            previewStatus: true,
                            imageContainer: Container(
                              child: menteeSkills.profilePicture == null ||
                                      menteeSkills.profilePicture.isEmpty ||
                                      menteeSkills.profilePicture == ""
                                  ? ProfileImageCircle(
                                      circleColor: Colors.grey,
                                      iconSize: 45,
                                      iconColor: Colors.white,
                                      circleSize: 40,
                                    )
                                  : CircleAvatar(
                                      radius: 40,
                                      child: CachedNetworkImage(
                                        imageUrl: menteeSkills.profilePicture,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
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
                                        errorWidget: (context, url, error) =>
                                            Icon(
                                          Icons.person,
                                          size: 50,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        });
  }
}
