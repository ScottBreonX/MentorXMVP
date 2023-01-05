import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/icon_circle_single.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/menu_bar/menu_bar.dart';
import 'package:mentorx_mvp/screens/profile/profile_screen.dart';
import 'package:mentorx_mvp/screens/programs/program_type.dart';
import 'package:provider/provider.dart';
import '../../components/progress.dart';
import '../../models/program_list.dart';
import '../../services/auth.dart';
import '../launch_screen.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');

class HomeScreen extends StatefulWidget {
  final myUser loggedInUser;

  const HomeScreen({
    Key key,
    this.loggedInUser,
  }) : super(key: key);

  static const String id = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool loggedIn = false;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  getCurrentUser() async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    loggedInUser = myUser.fromDocument(
        await usersRef.doc(auth.currentUser.uid).get().whenComplete(() {
      if (mounted) {
        setState(() {
          loggedIn = true;
        });
      }
    }));
  }

  bool isLoading = false;
  bool hasPrograms = false;
  List<ProgramList> programs = [];

  Future<dynamic> getProgramData() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot snapshot = await usersRef
        .doc(widget.loggedInUser.id)
        .collection('enrolledPrograms')
        .get();
    if (snapshot.docs.isNotEmpty) {
      setState(() {
        isLoading = false;
        hasPrograms = true;
        programs =
            snapshot.docs.map((doc) => ProgramList.fromDocument(doc)).toList();
      });
    }
  }

  buildEnrolledPrograms() {
    String userID = loggedInUser.id;
    String collectionPath = 'enrolledPrograms';
    isLoading = true;
    QuerySnapshot _snapshot;
    return FutureBuilder(
      future: usersRef.doc(userID).collection(collectionPath).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        } else {
          _snapshot = snapshot.data;
          if (_snapshot.size > 0) {
            programs = _snapshot.docs
                .map((doc) => ProgramList.fromDocument(doc))
                .toList();
            return Wrap(
              children: programs,
            );
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 25),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Wrap(
                      children: [
                        Text(
                          'You have not enrolled in any programs yet',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'WorkSans',
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        }
      },
    );
  }

  bool profilePictureStatus = false;

  @override
  Widget build(BuildContext context) {
    if (loggedIn == false || loggedInUser == null) {
      return circularProgress();
    }

    final drawerItems = MentorXMenuList(loggedInUser: loggedInUser);
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();

    return FutureBuilder<Object>(
        future: usersRef.doc(loggedInUser.id).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }

          if (loggedInUser.profilePicture != "") {
            profilePictureStatus = true;
          }

          if (loggedInUser.profilePicture.isEmpty ||
              loggedInUser.profilePicture == null ||
              loggedInUser.profilePicture == "") {
            profilePictureStatus = false;
          } else {
            profilePictureStatus = true;
          }

          pageTransition(Widget page, double offSetLow, double offSetHigh) {
            return PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 300),
              pageBuilder: (context, animation, secondaryAnimation) => page,
              transitionsBuilder:
                  (context, animation, secondaryAnimation, page) {
                var begin = Offset.fromDirection(offSetLow, offSetHigh);
                var end = Offset.zero;
                var curve = Curves.ease;

                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));
                return SlideTransition(
                  position: animation.drive(tween),
                  child: page,
                );
              },
            );
          }

          return Scaffold(
            key: _scaffoldKey,
            drawer: Drawer(
              child: Container(
                color: kMentorXPPrimary,
                child: drawerItems,
              ),
            ),
            appBar: AppBar(
              elevation: 5,
              backgroundColor: Color.fromRGBO(38, 70, 83, 1),
              centerTitle: true,
              title: Image.asset(
                'assets/images/MentorXP.png',
                height: 100,
              ),
            ),
            body: SingleChildScrollView(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 30.0, right: 10, bottom: 10, top: 30),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                pageTransition(
                                  Profile(
                                    loggedInUser: loggedInUser.id,
                                    profileId: loggedInUser.id,
                                  ),
                                  1.5,
                                  1.0,
                                ),
                              );
                            },
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 45,
                                backgroundColor: Colors.white,
                                child: !profilePictureStatus
                                    ? CircleAvatar(
                                        radius: 50,
                                        backgroundColor: Colors.grey,
                                        child: Icon(
                                          Icons.person,
                                          size: 40,
                                          color: Colors.white,
                                        ),
                                      )
                                    : CachedNetworkImage(
                                        imageUrl: loggedInUser.profilePicture,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          width: 190,
                                          height: 190,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        placeholder: (context, url) =>
                                            Container(),
                                        errorWidget: (context, url, error) =>
                                            Icon(
                                          Icons.person,
                                          size: 60,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(right: 8.0, top: 20.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: Container(
                                        width: 200,
                                        child: Text(
                                          '${loggedInUser.firstName} ${loggedInUser.lastName}',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 7.0,
                                        top: 2,
                                      ),
                                      child: Text(
                                        '${loggedInUser.email}',
                                        style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 15,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      thickness: 2,
                      color: Colors.grey,
                      indent: 20,
                      endIndent: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          pageTransition(
                                            Profile(
                                              loggedInUser: loggedInUser.id,
                                              profileId: loggedInUser.id,
                                            ),
                                            1.5,
                                            1.0,
                                          ),
                                        );
                                      },
                                      child: IconCircleSingle(
                                        cardHeight:
                                            MediaQuery.of(context).size.width *
                                                .80 /
                                                3,
                                        cardWidth:
                                            MediaQuery.of(context).size.width *
                                                .80 /
                                                3,
                                        cardIcon: Icons.person,
                                        cardIconSize: 50,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Text(
                                        'My',
                                        style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: kMentorXPSecondary,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'Profile',
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: kMentorXPSecondary,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          pageTransition(
                                            ProgramTypeScreen(),
                                            0,
                                            1.0,
                                          ),
                                        );
                                      },
                                      child: IconCircleSingle(
                                        cardHeight:
                                            MediaQuery.of(context).size.width *
                                                .80 /
                                                3,
                                        cardWidth:
                                            MediaQuery.of(context).size.width *
                                                .80 /
                                                3,
                                        cardIcon: Icons.add,
                                        cardIconSize: 50,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Text(
                                        'Join a',
                                        style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: kMentorXPSecondary,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'Program',
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: kMentorXPSecondary,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    IconCircleSingle(
                                      cardHeight:
                                          MediaQuery.of(context).size.width *
                                              .80 /
                                              3,
                                      cardWidth:
                                          MediaQuery.of(context).size.width *
                                              .80 /
                                              3,
                                      cardIcon: Icons.psychology,
                                      cardIconSize: 50,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            'Knowledge',
                                            style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              color: kMentorXPSecondary,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            'Center',
                                            style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              color: kMentorXPSecondary,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 5.0, right: 5.0, top: 20, bottom: 10),
                            child: Divider(
                              thickness: 2,
                              color: Colors.grey,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Text(
                              'Enrolled Programs',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 25,
                                fontWeight: FontWeight.w500,
                                color: kMentorXPSecondary,
                              ),
                            ),
                          ),
                          buildEnrolledPrograms(),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
