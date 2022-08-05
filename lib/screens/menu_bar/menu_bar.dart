import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/progress.dart';
import 'package:mentorx_mvp/components/sign_out.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/home_screen/home_screen.dart';
import 'package:mentorx_mvp/screens/launch_screen.dart';
import 'package:mentorx_mvp/screens/program_creation/program_creation.dart';
import 'package:mentorx_mvp/screens/programs/program_selection_screen.dart';
import 'package:mentorx_mvp/screens/programs/program_type.dart';
import '../profile/profile_screen.dart';

final usersRef = FirebaseFirestore.instance.collection('users');

class MentorXMenuHeader extends StatefulWidget {
  final myUser loggedInUser;

  MentorXMenuHeader({this.loggedInUser});

  @override
  _MentorXMenuHeaderState createState() => _MentorXMenuHeaderState();
}

class _MentorXMenuHeaderState extends State<MentorXMenuHeader> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  bool profilePictureStatus = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
        future: usersRef.doc(loggedInUser.id).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }

          if (loggedInUser.profilePicture != "") {
            profilePictureStatus = true;
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: UserAccountsDrawerHeader(
              key: _scaffoldKey,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              accountName:
                  Text('${loggedInUser.firstName} ${loggedInUser.lastName}'),
              accountEmail: Text('${loggedInUser.email}'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 34,
                  child: profilePictureStatus
                      ? CachedNetworkImage(
                          imageUrl: loggedInUser.profilePicture,
                          imageBuilder: (context, imageProvider) => Container(
                            width: 110.0,
                            height: 110.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                            ),
                          ),
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.white,
                          ),
                        )
                      : Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.white,
                        ),
                ),
              ),
              otherAccountsPictures: [
                CircleAvatar(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(
                      Icons.close,
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}

class MentorXMenuList extends StatelessWidget {
  final myUser loggedInUser;

  MentorXMenuList({
    this.loggedInUser,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        MentorXMenuHeader(loggedInUser: loggedInUser),
        ListTile(
          leading: Icon(
            Icons.home,
            color: Colors.white,
          ),
          title: Text(
            'Home',
            style: Theme.of(context).textTheme.headline2,
          ),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(
                loggedInUser: loggedInUser,
              ),
            ),
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.person,
            color: Colors.white,
          ),
          title: Text(
            'My Profile',
            style: Theme.of(context).textTheme.headline2,
          ),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Profile(
                loggedInUser: loggedInUser.id,
                profileId: loggedInUser.id,
              ),
            ),
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.groups,
            size: 30,
            color: Colors.white,
          ),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProgramSelectionScreen(
                loggedInUser: loggedInUser,
              ),
            ),
          ),
          title: Text(
            'Enrolled Programs',
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.add_circle_rounded,
            size: 30,
            color: Colors.white,
          ),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProgramTypeScreen(),
            ),
          ),
          title: Text(
            'Join New Program',
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
        loggedInUser.canCreateProgram
            ? ListTile(
                leading: Icon(
                  Icons.create_new_folder_rounded,
                  color: Colors.white,
                ),
                title: Text(
                  'Create a Program',
                  style: Theme.of(context).textTheme.headline2,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProgramCreation(
                        loggedInUser: loggedInUser,
                      ),
                    ),
                  );
                },
              )
            : Container(),
        ListTile(
          leading: Icon(
            Icons.exit_to_app_rounded,
            color: Colors.white,
          ),
          title: Text(
            'Log Out',
            style: Theme.of(context).textTheme.headline2,
          ),
          onTap: () {
            confirmSignOut(context);
          },
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Row(
            children: [
              Image.asset(
                'assets/images/MentorPinkWhite.png',
                height: 200,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
