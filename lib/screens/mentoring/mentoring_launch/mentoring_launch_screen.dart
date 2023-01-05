import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/icon_card.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/mentoring/mentoring_launch/mentoring_launch_manage.dart';
import 'package:mentorx_mvp/screens/mentoring/mentoring_launch/mentoring_notes/mentoring_notes.dart';
import '../../../components/progress.dart';
import '../../launch_screen.dart';
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
  @override
  void initState() {
    super.initState();
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
                    title: Image.asset(
                      'assets/images/MentorXP.png',
                      height: 100,
                    ),
                  ),
                  body: SingleChildScrollView(
                    child: Container(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 50.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    GestureDetector(
                                      child: ImageCircle(
                                        profilePicBool: userProfilePic,
                                        myUserRef: user,
                                      ),
                                      onTap: () {},
                                    ),
                                    Container(
                                      width: 200,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 10.0),
                                        child: Text(
                                          '${user.firstName} ${user.lastName}',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black45,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                      child: ImageCircle(
                                        profilePicBool: mentorProfilePic,
                                        myUserRef: mentor,
                                      ),
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              Profile(profileId: mentor.id),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Container(
                                        width: 200,
                                        child: Text(
                                          '${mentor.firstName} ${mentor.lastName}',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black45,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    )
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                        builder: (context) => MentoringNotes(
                                          loggedInUser: loggedInUser,
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
                                            MentoringLaunchManage(
                                          loggedInUser: loggedInUser,
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
      radius: profilePicBool ? 75 : 70,
      backgroundColor: Colors.white,
      child: CircleAvatar(
        radius: 72,
        backgroundColor: Colors.white,
        child: !profilePicBool
            ? CircleAvatar(
                radius: 72,
                backgroundColor: Colors.blue,
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
