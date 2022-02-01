import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/progress.dart';
import 'package:mentorx_mvp/components/sign_out.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/launch_screen.dart';

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
    return FutureBuilder<Object>(
        future: usersRef.doc(loggedInUser.id).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
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
            color: Colors.white,
          ),
          title: Text(
            'Home',
            style: Theme.of(context).textTheme.headline2,
          ),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LaunchScreen(pageIndex: 0),
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
              builder: (context) => LaunchScreen(pageIndex: 2),
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
              builder: (context) => LaunchScreen(pageIndex: 1),
            ),
          ),
          title: Text(
            'Programs',
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.settings,
            color: Colors.white,
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
      ],
    );
  }
}
