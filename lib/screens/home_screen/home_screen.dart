import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/menu_bar/menu_bar.dart';
import 'package:mentorx_mvp/screens/profile/profile_screen.dart';
import 'package:mentorx_mvp/screens/programs/program_launch/program_enrollment_screen.dart';
import 'package:mentorx_mvp/screens/programs/program_selection_screen.dart';
import 'package:mentorx_mvp/screens/programs/program_type.dart';
import 'package:provider/provider.dart';
import '../../components/progress.dart';
import '../../services/auth.dart';
import '../launch_screen.dart';

final usersRef = FirebaseFirestore.instance.collection('users');

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

  bool profilePictureStatus = false;

  @override
  Widget build(BuildContext context) {
    if (loggedIn == false || loggedInUser == null) {
      return circularProgressBlue();
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

          return Scaffold(
            key: _scaffoldKey,
            drawer: Drawer(
              child: Container(
                child: drawerItems,
              ),
            ),
            appBar: AppBar(
              elevation: 5,
              title: Image.asset(
                'assets/images/MentorPinkWhite.png',
                height: 150,
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
                                MaterialPageRoute(
                                  builder: (context) =>
                                      LaunchScreen(pageIndex: 2),
                                ),
                              );
                            },
                            child: CircleAvatar(
                              radius: profilePictureStatus ? 43 : 40,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.white,
                                child: !profilePictureStatus
                                    ? CircleAvatar(
                                        radius: 38,
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
                                            CircularProgressIndicator(),
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
                            child: Stack(
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
                                            fontFamily: 'WorkSans',
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/MentorPink.png',
                                      width: 70,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Text(
                                        'Premium Member',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'WorkSans',
                                            color: kMentorXPrimary,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  top: 50,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 7.0, top: 2),
                                        child: Text(
                                          '${loggedInUser.email}',
                                          style: TextStyle(
                                            fontFamily: 'WorkSans',
                                            fontSize: 12,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
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
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ButtonCard(
                              buttonCardText: 'Edit Profile',
                              buttonCardIcon: Icons.edit,
                              buttonCardTextSize: 25,
                              buttonCardRadius: 20,
                              buttonCardIconSize: 40,
                              buttonCardIconColor: Colors.blue,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Profile(
                                      loggedInUser: loggedInUser.id,
                                      profileId: loggedInUser.id,
                                    ),
                                  ),
                                );
                              },
                            ),
                            ButtonCard(
                              buttonCardText: 'Enrolled Programs',
                              buttonCardIcon: Icons.people,
                              buttonCardTextSize: 25,
                              buttonCardRadius: 20,
                              buttonCardIconSize: 40,
                              buttonCardIconColor: Colors.blue,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProgramSelectionScreen(
                                      loggedInUser: loggedInUser,
                                    ),
                                  ),
                                );
                              },
                            ),
                            ButtonCard(
                              buttonCardText: 'Join a New Program',
                              buttonCardIcon: Icons.add,
                              buttonCardTextSize: 25,
                              buttonCardRadius: 20,
                              buttonCardIconSize: 40,
                              buttonCardIconColor: Colors.blue,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProgramTypeScreen(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
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

class HomeMenuButton extends StatelessWidget {
  const HomeMenuButton({
    @required this.buttonText,
    @required this.iconType,
    @required this.onPressed,
  });

  final IconData iconType;
  final String buttonText;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return RoundedButton(
      prefixIcon: Icon(
        iconType,
        color: Colors.blue,
      ),
      title: buttonText,
      buttonColor: Colors.white,
      fontColor: Colors.blue,
      fontSize: 20,
      onPressed: onPressed,
      minWidth: 200,
    );
  }
}
