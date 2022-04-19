import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/icon_card.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/menu_bar/menu_bar.dart';
import '../../components/progress.dart';
import '../launch_screen.dart';

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
  @override
  void initState() {
    super.initState();
  }

  bool profilePictureStatus = false;

  @override
  Widget build(BuildContext context) {
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
                child: Padding(
                  padding: const EdgeInsets.only(top: 80.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
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
                                radius: profilePictureStatus ? 85 : 80,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 80,
                                  backgroundColor: Colors.white,
                                  child: !profilePictureStatus
                                      ? CircleAvatar(
                                          radius: 75,
                                          backgroundColor: Colors.blue,
                                          child: Icon(
                                            Icons.person,
                                            size: 90,
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
                                            size: 90,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Welcome Back, ${loggedInUser.firstName}',
                                style: Theme.of(context).textTheme.headline4,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        thickness: 4,
                        color: Colors.grey,
                        indent: 40,
                        endIndent: 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconCard(
                              cardText: 'My Profile',
                              cardTextColor: Colors.black54,
                              cardColor: Colors.white,
                              cardIcon: Icons.person,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        LaunchScreen(pageIndex: 2),
                                  ),
                                );
                              },
                            ),
                            IconCard(
                              cardText: 'Programs',
                              cardTextColor: Colors.black54,
                              cardColor: Colors.white,
                              cardIcon: Icons.people_alt,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        LaunchScreen(pageIndex: 1),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
