import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/program_values_card.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/program_guides/program_guide_intros/introductions/program_guides_intros.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');

class ProgramGuideInfo extends StatefulWidget {
  final myUser loggedInUser;
  final String programUID;
  final String mentorUID;
  final String matchID;

  const ProgramGuideInfo(
      {Key key,
      this.loggedInUser,
      this.programUID,
      this.mentorUID,
      this.matchID})
      : super(key: key);

  static const String id = 'program_guide_info';

  @override
  _ProgramGuideInfoState createState() => _ProgramGuideInfoState();
}

class _ProgramGuideInfoState extends State<ProgramGuideInfo> {
  @override
  void initState() {
    super.initState();
  }

  @override
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
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                'Welcome to',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: 'Montserrat',
                  color: kMentorXPPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              'MentorUp Program Guides',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontFamily: 'Montserrat',
                color: kMentorXPPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 30.0, bottom: 40, left: 15, right: 15),
              child: Column(
                children: [
                  Text(
                    'The purpose of a mentorship program is to provide an opportunity for individuals to receive guidance and support from experienced professionals in their field or industry. The program aims to promote personal and professional development, career advancement, and knowledge-sharing.',
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Some of the key benefits of a mentorship program include:',
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ProgramValuesCard(
                    titleText: 'Career Development',
                    bodyText:
                        'A mentorship program can provide mentees with guidance on career choices, job search strategies, and career advancement opportunities. Mentors can also provide advice on building skills, networking, and professional development.',
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ProgramValuesCard(
                    titleText: 'Knowledge Sharing',
                    bodyText:
                        'A mentorship program provides a platform for experienced professionals to share their knowledge and expertise with mentees. Mentors can offer insights and best practices in a specific field or industry, helping mentees to build their skills and knowledge.',
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ProgramValuesCard(
                    titleText: 'Increased Confidence',
                    bodyText:
                        'Through regular meetings and interactions with their mentor, mentees can gain increased confidence in their abilities and decisions. Mentors can offer constructive feedback and encouragement, helping mentees to overcome challenges and stay motivated.',
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ProgramValuesCard(
                    titleText: 'Networking opportunities',
                    bodyText:
                        'A mentorship program can provide mentees with valuable networking opportunities, allowing them to connect with other professionals in their field or industry.',
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ProgramValuesCard(
                    titleText: 'Personal Growth',
                    bodyText:
                        'A mentorship program can help mentees to develop personally as well as professionally, by offering guidance on work-life balance, personal development, and goal-setting.',
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        // width: 200,
                        child: RoundedButton(
                          title: 'Ready for 1st Meeting -->',
                          textAlignment: MainAxisAlignment.center,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          buttonColor: kMentorXPSecondary,
                          fontColor: Colors.white,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProgramGuidesIntrosScreen(
                                  loggedInUser: widget.loggedInUser,
                                  matchID: widget.matchID,
                                  mentorUID: widget.mentorUID,
                                  programUID: widget.programUID,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }
}
