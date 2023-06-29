import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/programs/program_launch/program_launch_screen.dart';
import '../../../components/alert_dialog.dart';
import '../../../components/mentor_card.dart';
import '../../../components/profile_image_circle.dart';
import '../../../components/progress.dart';
import '../../../models/mentor_match_models/mentee_model.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');

class MenteeEnrollmentReview extends StatefulWidget {
  final myUser loggedInUser;
  final String programUID;
  static const String id = 'mentee_enrollment_review_screen';

  const MenteeEnrollmentReview({
    this.loggedInUser,
    this.programUID,
  });

  @override
  State<MenteeEnrollmentReview> createState() => _MenteeEnrollmentReviewState();
}

class _MenteeEnrollmentReviewState extends State<MenteeEnrollmentReview> {
  Future<void> _updateMenteeFreeForm(
      BuildContext context, String programUID) async {
    try {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProgramLaunchScreen(
            loggedInUser: widget.loggedInUser,
            programUID: widget.programUID,
          ),
        ),
      );
    } on FirebaseException catch (e) {
      showAlertDialog(context,
          title: 'Operation Failed', content: '$e', defaultActionText: 'Ok');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
        future: usersRef.doc(widget.loggedInUser.id).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          final user = snapshot.data;
          myUser userProfile = myUser.fromDocument(user);
          return FutureBuilder<Object>(
              future: programsRef
                  .doc(widget.programUID)
                  .collection('mentees')
                  .doc(widget.loggedInUser.id)
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return circularProgress();
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
                      padding:
                          const EdgeInsets.only(left: 20.0, right: 20, top: 40),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Text(
                              'Review your Mentee profile card',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 30,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          MentorCard(
                            mentorUID: widget.loggedInUser.id,
                            mentorFname: userProfile.firstName,
                            mentorLname: userProfile.lastName,
                            mtrAtt1: menteeSkills.menteeSkill1,
                            mtrAtt2: menteeSkills.menteeSkill2,
                            mtrAtt3: menteeSkills.menteeSkill3,
                            mtrClass: menteeSkills.menteeYearInSchool,
                            xFactor: menteeSkills.menteeExperience,
                            menteePreview: true,
                            previewStatus: true,
                            imageContainer: Container(
                              child: userProfile.profilePicture == null ||
                                      userProfile.profilePicture.isEmpty ||
                                      userProfile.profilePicture == ""
                                  ? ProfileImageCircle(
                                      circleColor: Colors.grey,
                                      iconSize: 45,
                                      iconColor: Colors.white,
                                      circleSize: 40,
                                    )
                                  : CircleAvatar(
                                      radius: 40,
                                      child: CachedNetworkImage(
                                        imageUrl: userProfile.profilePicture,
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
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RoundedButton(
                                title: '<-- Back',
                                buttonColor: Colors.white,
                                borderWidth: 2,
                                borderRadius: 20,
                                fontColor: kMentorXPSecondary,
                                fontWeight: FontWeight.w500,
                                minWidth: 150,
                                fontSize: 20,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              RoundedButton(
                                title: 'Save',
                                buttonColor: kMentorXPSecondary,
                                fontColor: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                borderRadius: 20,
                                minWidth: 150,
                                onPressed: () {
                                  _updateMenteeFreeForm(
                                    context,
                                    widget.programUID,
                                  );
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              });
        });
  }
}
