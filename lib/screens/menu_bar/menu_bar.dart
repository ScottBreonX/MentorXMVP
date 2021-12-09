import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/progress.dart';
import 'package:mentorx_mvp/components/sign_out.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/home_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: usersRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          final profileData =
              snapshot.data.docs.map((doc) => Text(doc['First Name']));
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
                child: Icon(
                  Icons.person,
                  size: 40.0,
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

  MentorXMenuList({this.loggedInUser});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        MentorXMenuHeader(loggedInUser: loggedInUser),
        ListTile(
          leading: Icon(
            Icons.home,
          ),
          title: Text(
            'Home',
            style: Theme.of(context).textTheme.headline2,
          ),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(pageIndex: 0),
            ),
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.person,
          ),
          title: Text(
            'My Profile',
            style: Theme.of(context).textTheme.headline2,
          ),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(pageIndex: 1),
            ),
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.people,
          ),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(pageIndex: 2),
            ),
          ),
          title: Text(
            'Mentoring',
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.settings,
          ),
          title: Text(
            'Settings',
            style: Theme.of(context).textTheme.headline2,
          ),
          onTap: () {},
        ),
        ListTile(
          title: const Text(
            '',
            style: TextStyle(),
          ),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(
            Icons.exit_to_app_rounded,
          ),
          title: Text(
            'Log Out',
            style: Theme.of(context).textTheme.headline2,
          ),
          onTap: () {
            confirmSignOut(context);
          },
        ),
      ],
    );
  }
}
