import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/icon_circle.dart';
import 'package:mentorx_mvp/components/progress.dart';
import 'package:mentorx_mvp/screens/profile/sections/about_me_section.dart';
import 'package:mentorx_mvp/screens/menu_bar/menu_bar.dart';
import 'package:mentorx_mvp/components/profile_image_circle.dart';
import 'package:mentorx_mvp/screens/profile/sections/profile_mentee_section.dart';
import 'package:mentorx_mvp/screens/profile/sections/profile_mentor_section.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({@required this.profileData});
  final profileData;
  static String id = 'mentor_screen';

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  bool aboutMeEditStatus = false;

  @override
  Widget build(BuildContext context) {
    if (widget.profileData == null) {
      return circularProgress();
    }

    double circleSize = 55.0;

    final drawerItems = MentorXMenuList();
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Container(
          child: drawerItems,
        ),
      ),
      appBar: AppBar(
        elevation: 5,
        title: Text('My Profile'),
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
                          color: Theme.of(context).scaffoldBackgroundColor,
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
                      '${widget.profileData['First Name']} ${widget.profileData['Last Name']}',
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
                      '${widget.profileData['Year in School']}, ${widget.profileData['Major']}',
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
                child: AboutMeSection(),
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
                      'Mentoring Atttributes',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                  ),
                ],
              ),
              ProfileMentorSection(),
              ProfileMenteeSection(),
            ],
          ),
        ),
      ),
    );
  }
}
