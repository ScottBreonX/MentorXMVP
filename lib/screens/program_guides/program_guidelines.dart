import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/program_guides/program_guide_data/guidelines1.dart';
import 'package:mentorx_mvp/screens/program_guides/program_guide_data/guidelines2.dart';
import 'package:mentorx_mvp/screens/program_guides/program_guide_data/guidelinesComplete.dart';
import 'package:mentorx_mvp/screens/programs/program_launch/program_launch_screen.dart';

import '../../components/program_card.dart';
import '../../components/progress.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');

class ProgramGuidelines extends StatefulWidget {
  final myUser loggedInUser;
  final String programUID;

  const ProgramGuidelines({
    Key key,
    this.loggedInUser,
    this.programUID,
  }) : super(key: key);

  static const String id = 'program_guidelines_screen';

  @override
  _ProgramGuidelinesState createState() => _ProgramGuidelinesState();
}

class _ProgramGuidelinesState extends State<ProgramGuidelines> {
  @override
  void initState() {
    super.initState();
  }

  int currentIndex = 0;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
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
      body: Center(
        child: Stack(
          children: [ Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 30.0),
                child:
                Container(
                  height: MediaQuery.of(context).size.height*.70,
                  width: double.infinity,
                  child: CarouselSlider(
                    options: CarouselOptions(
                        height: double.infinity,
                        viewportFraction: 0.88,
                        enlargeCenterPage: true,
                        enlargeFactor: 0.2,
                        autoPlay: false,
                        enableInfiniteScroll: false,
                        onPageChanged: (index, reason) {
                          setState(() {
                            currentIndex = index;
                          });
                        }),
                    items: [
                      ProgramGuideCard(
                        titleText: 'Program Guidelines',
                        cardColor: Colors.white,
                        textColor: kMentorXPPrimary,
                        fileName: Guidelines1(
                          bodyTextColor: Colors.black54,
                        ),
                      ),
                      ProgramGuideCard(
                        titleText: 'Program Guidelines',
                        cardColor: Colors.white,
                        textColor: kMentorXPPrimary,
                        fileName: Guidelines2(
                          bodyTextColor: Colors.black54,
                        ),
                      ),


                      ProgramGuideCard(
                        titleText: 'Acknowledge Agreement',
                        cardColor: Colors.white,
                        textColor: kMentorXPPrimary,
                        fileName: GuidelinesComplete(
                          bodyTextColor: Colors.black54,
                        ),
                        swipeText: 'Return to Program',
                        selectButtons: true,
                        selectButton1: true,
                        button1Text: 'Agree to Guidelines',
                        onPressed1: () async {
                          setState(() {
                            print('loading');
                            isLoading = true;
                          });
                          await programsRef
                              .doc(widget.programUID)
                              .collection('userSubscribed')
                              .doc(widget.loggedInUser.id)
                              .update({"Guidelines Complete": true});
                          setState(() {
                            Navigator.pop(context);
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProgramLaunchScreen(
                                  programUID: widget.programUID,
                                  loggedInUser: widget.loggedInUser,
                                ),
                              ),
                              ModalRoute.withName('/'),
                            );
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < 3; i++)
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Container(
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                          color: currentIndex == i
                              ? kMentorXPAccentMed
                              : Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
            isLoading
                ? Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.white.withOpacity(0.5),
              child: circularProgress(Colors.white),
            )
                : Container(),
       ] ),
      ),
    );
  }
}
