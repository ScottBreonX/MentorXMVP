import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/icon_circle.dart';
import 'package:mentorx_mvp/components/progress.dart';
import 'package:mentorx_mvp/screens/home_screen.dart';
import 'package:mentorx_mvp/screens/menu_bar/menu_bar.dart';
import 'package:mentorx_mvp/components/profile_image_circle.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/profile/sections/about_me_section.dart';

final usersRef = FirebaseFirestore.instance.collection('users');

class Profile extends StatefulWidget {
  final String profileId;
  static String id = 'mentor_screen';

  Profile({@required this.profileId});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final String currentUserId = loggedInUser.id;
  bool aboutMeEditStatus = false;

  @override
  Widget build(BuildContext context) {
    if (widget.profileId == null) {
      return circularProgress();
    }

    double circleSize = 55.0;

    final drawerItems = MentorXMenuList();
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();

    return FutureBuilder<Object>(
        future: usersRef.doc(widget.profileId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          myUser user = myUser.fromDocument(snapshot.data);
          return Scaffold(
            key: _scaffoldKey,
            drawer: Drawer(
              child: Container(
                child: drawerItems,
              ),
            ),
            appBar: AppBar(
              elevation: 5,
              title: Text(user.id != loggedInUser.id
                  ? '${user.firstName}\'s Profile'
                  : 'My Profile'),
            ),
            body: SingleChildScrollView(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 120.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                width: 3,
                              ),
                            ),
                          ),
                          child: Image.asset(
                            'assets/images/MLogoBlue.png',
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 65.0),
                          child: Stack(
                            children: [
                              CircleAvatar(
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                radius: circleSize + 3,
                                child: ProfileImageCircle(
                                  iconSize: circleSize,
                                  circleSize: circleSize,
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 5,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Theme.of(context).backgroundColor,
                                  ),
                                  height: 30.0,
                                  width: 30.0,
                                  child: GestureDetector(
                                    onTap: () {},
                                    child: Icon(
                                      Icons.photo_camera,
                                      color: Theme.of(context).iconTheme.color,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 20,
                          right: 15,
                          child: GestureDetector(
                            onTap: () {},
                            child: IconCircle(
                              height: 30.0,
                              width: 30.0,
                              iconType: Icons.edit,
                              circleColor: Theme.of(context).backgroundColor,
                              iconColor: Theme.of(context).iconTheme.color,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 20,
                          right: 10,
                          child: IconCircle(
                            height: 30.0,
                            width: 30.0,
                            iconSize: 20.0,
                            iconType: Icons.edit,
                            circleColor: Theme.of(context).backgroundColor,
                            iconColor: Theme.of(context).iconTheme.color,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0, top: 5.0),
                          child: Text(
                            '${user.firstName} ${user.lastName}',
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, top: 5.0, bottom: 15.0),
                          child: Text(
                            '${user.yearInSchool}, ${user.major}',
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      thickness: 2,
                      color: Colors.white,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: AboutMeSection(
                        profileId: user.id,
                      ),
                    ),
                    const Divider(
                      thickness: 2,
                      color: Colors.white,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                          child: Text(
                            'Mentoring Attributes',
                            style: Theme.of(context).textTheme.headline3,
                          ),
                        ),
                      ],
                    ),
                    // ProfileMentorSection(),
                    // ProfileMenteeSection(),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
