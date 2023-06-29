import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/icon_card.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/mentoring/mentoring_launch/mentoring_launch_manage.dart';
import 'package:mentorx_mvp/screens/mentoring/mentoring_launch/mentoring_notes/mentoring_notes.dart';
import 'package:mentorx_mvp/screens/mentoring/mentoring_launch/mentoring_profile/mentoring_profile_cards.dart';
import 'package:mentorx_mvp/screens/program_guides/program_guides_launch.dart';
import '../../../components/progress.dart';
import '../../profile/profile_screen.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');

class MentoringLaunchScreen extends StatefulWidget {
  final myUser loggedInUser;
  final String mentorUID;
  final String programUID;
  final String matchID;

  const MentoringLaunchScreen({
    Key key,
    this.loggedInUser,
    this.mentorUID,
    this.programUID,
    this.matchID,
  }) : super(key: key);

  static const String id = 'mentoring_launch_screen';

  @override
  _MentoringLaunchScreenState createState() => _MentoringLaunchScreenState();
}

class _MentoringLaunchScreenState extends State<MentoringLaunchScreen> {
  bool isMentor = false;

  @override
  void initState() {
    checkIsMentor();
    super.initState();
  }

  checkIsMentor() async {
    DocumentSnapshot doc = await programsRef
        .doc(widget.programUID)
        .collection('mentors')
        .doc(widget.loggedInUser.id)
        .get();
    if (doc.exists) {
      setState(() {
        isMentor = true;
      });
    } else {
      setState(() {
        isMentor = false;
      });
    }
  }

  bool userProfilePic = false;
  bool mentorProfilePic = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: usersRef.doc(widget.loggedInUser.id).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          myUser user = myUser.fromDocument(snapshot.data);
          return StreamBuilder<Object>(
              stream: usersRef.doc(widget.mentorUID).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return circularProgress();
                }
                myUser mentor = myUser.fromDocument(snapshot.data);

                if (user.profilePicture == null || user.profilePicture == "") {
                  userProfilePic = false;
                } else {
                  userProfilePic = true;
                }
                if (mentor.profilePicture == null ||
                    mentor.profilePicture == "") {
                  mentorProfilePic = false;
                } else {
                  mentorProfilePic = true;
                }

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
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 50.0, left: 20, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: Text(
                                        'Mentor',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 25,
                                          fontWeight: FontWeight.w500,
                                          color: kMentorXPAccentDark,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Card(
                                        color: Colors.white,
                                        elevation: 10,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              GestureDetector(
                                                child: ImageCircle(
                                                  profilePicBool: isMentor
                                                      ? userProfilePic
                                                      : mentorProfilePic,
                                                  myUserRef:
                                                      isMentor ? user : mentor,
                                                ),
                                                onTap: () => Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        Profile(
                                                      profileId: isMentor
                                                          ? widget
                                                              .loggedInUser.id
                                                          : widget.mentorUID,
                                                      loggedInUser:
                                                          widget.loggedInUser,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0),
                                                child: Container(
                                                  width: 100,
                                                  child: Text(
                                                    isMentor
                                                        ? '${user.firstName}\n${user.lastName}'
                                                        : '${mentor.firstName}\n${mentor.lastName}',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black45,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: Text(
                                        'Mentee',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 25,
                                          fontWeight: FontWeight.w500,
                                          color: kMentorXPSecondary,
                                        ),
                                      ),
                                    ),
                                    Card(
                                      color: Colors.white,
                                      elevation: 10,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              child: ImageCircle(
                                                profilePicBool: isMentor
                                                    ? mentorProfilePic
                                                    : userProfilePic,
                                                myUserRef:
                                                    isMentor ? mentor : user,
                                              ),
                                              onTap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => Profile(
                                                    profileId: isMentor
                                                        ? widget.mentorUID
                                                        : widget
                                                            .loggedInUser.id,
                                                    loggedInUser:
                                                        widget.loggedInUser,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10.0),
                                              child: Container(
                                                width: 100,
                                                child: Text(
                                                  isMentor
                                                      ? '${mentor.firstName}\n${mentor.lastName}'
                                                      : '${user.firstName}\n${user.lastName}',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black45,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20),
                            child: Divider(
                              thickness: 2,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 20.0,
                              right: 20.0,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconCard(
                                      boxHeight: 140,
                                      boxWidth: 140,
                                      iconSize: 60,
                                      cardColor: Colors.white,
                                      cardIcon: Icons.note_rounded,
                                      cardIconColor: kMentorXPSecondary,
                                      cardText: 'Notes',
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                MentoringNotes(
                                              loggedInUser: widget.loggedInUser,
                                              matchID: widget.matchID,
                                              mentorUID: widget.mentorUID,
                                              programUID: widget.programUID,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    IconCard(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ProgramGuidesLaunchScreen(
                                              loggedInUser: widget.loggedInUser,
                                              matchID: widget.matchID,
                                              mentorUID: widget.mentorUID,
                                              programUID: widget.programUID,
                                            ),
                                            //     ProgramGuidesLaunchScreen(
                                            //   loggedInUser: widget.loggedInUser,
                                            //   matchID: widget.matchID,
                                            //   mentorUID: widget.mentorUID,
                                            //   programUID: widget.programUID,
                                            // ),
                                          ),
                                        );
                                      },
                                      boxHeight: 140,
                                      boxWidth: 140,
                                      iconSize: 60,
                                      cardColor: Colors.white,
                                      cardIcon: Icons.map,
                                      cardIconColor: kMentorXPSecondary,
                                      cardText: 'Program Guides',
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      IconCard(
                                        boxHeight: 140,
                                        boxWidth: 140,
                                        iconSize: 60,
                                        cardColor: Colors.white,
                                        cardIcon: Icons.people,
                                        cardIconColor: kMentorXPSecondary,
                                        cardText: 'Mentoring Cards',
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  MentoringProfileScreen(
                                                loggedInUser:
                                                    widget.loggedInUser,
                                                programUID: widget.programUID,
                                                mentorUID: widget.mentorUID,
                                                mentorStatus: isMentor,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      IconCard(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  MentoringLaunchManage(
                                                loggedInUser:
                                                    widget.loggedInUser,
                                                programUID: widget.programUID,
                                                mentorUser: mentor,
                                              ),
                                            ),
                                          );
                                        },
                                        boxHeight: 140,
                                        boxWidth: 140,
                                        iconSize: 60,
                                        cardColor: Colors.white,
                                        cardIcon: Icons.settings,
                                        cardIconColor: kMentorXPSecondary,
                                        cardText: 'Manage',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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

class ImageCircle extends StatelessWidget {
  const ImageCircle({
    Key key,
    @required this.profilePicBool,
    @required this.myUserRef,
  }) : super(key: key);

  final bool profilePicBool;
  final myUser myUserRef;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: profilePicBool ? 60 : 60,
      backgroundColor: Colors.white,
      child: CircleAvatar(
        radius: 72,
        backgroundColor: Colors.white,
        child: !profilePicBool
            ? CircleAvatar(
                radius: 72,
                backgroundColor: Colors.grey,
                child: Icon(
                  Icons.person,
                  size: 80,
                  color: Colors.white,
                ),
              )
            : CachedNetworkImage(
                imageUrl: myUserRef.profilePicture,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(
                  Icons.person,
                  size: 80,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
