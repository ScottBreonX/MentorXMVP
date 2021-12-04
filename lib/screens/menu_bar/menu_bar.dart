import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/sign_out.dart';
import 'package:mentorx_mvp/screens/home_screen.dart';

class MentorXMenuHeader extends StatefulWidget {
  const MentorXMenuHeader({@required this.profileData});

  final profileData;

  @override
  _MentorXMenuHeaderState createState() => _MentorXMenuHeaderState();
}

class _MentorXMenuHeaderState extends State<MentorXMenuHeader> {
  bool profilePictureStatus;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final String fName = '${widget.profileData['First Name']}';
    final String lName = '${widget.profileData['Last Name']}';
    final String email = '${widget.profileData['Email Address']}';
    final String profilePicture = '${widget.profileData['images']}';

    if (profilePicture == 'null') {
      profilePictureStatus = false;
    } else {
      profilePictureStatus = true;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: UserAccountsDrawerHeader(
        key: _scaffoldKey,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        accountName: Text(
          '$fName $lName',
          style: TextStyle(),
        ),
        accountEmail: Text(
          '$email',
          style: TextStyle(),
        ),
        currentAccountPicture: CircleAvatar(
          backgroundImage:
              profilePictureStatus ? NetworkImage(profilePicture) : null,
          child: profilePictureStatus
              ? null
              : Icon(
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
  }
}

class MentorXMenuList extends StatelessWidget {
  const MentorXMenuList({
    @required this.drawerHeader,
  });

  final MentorXMenuHeader drawerHeader;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        drawerHeader,
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
              builder: (context) => LaunchScreen(pageIndex: 0),
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
              builder: (context) => LaunchScreen(pageIndex: 1),
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
              builder: (context) => LaunchScreen(pageIndex: 2),
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
