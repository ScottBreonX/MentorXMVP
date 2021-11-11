import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/sign_out.dart';
import 'package:mentorx_mvp/screens/home_screen.dart';
import '../../constants.dart';

class MentorXMenuHeader extends StatefulWidget {
  const MentorXMenuHeader(
      {@required this.fName,
      @required this.lName,
      @required this.email,
      @required this.profilePicture});
  final String fName;
  final String lName;
  final String email;
  final String profilePicture;

  @override
  _MentorXMenuHeaderState createState() => _MentorXMenuHeaderState();
}

class _MentorXMenuHeaderState extends State<MentorXMenuHeader> {
  bool profilePictureStatus;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    if (widget.profilePicture == 'null') {
      profilePictureStatus = false;
    } else {
      profilePictureStatus = true;
    }

    Color accountCardTextColor = Colors.black54;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: UserAccountsDrawerHeader(
        key: _scaffoldKey,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        accountName: Text(
          '${widget.fName} ${widget.lName}',
          style: TextStyle(
            color: accountCardTextColor,
          ),
        ),
        accountEmail: Text(
          '${widget.email}',
          style: TextStyle(
            color: accountCardTextColor,
          ),
        ),
        currentAccountPicture: CircleAvatar(
          backgroundImage:
              profilePictureStatus ? NetworkImage(widget.profilePicture) : null,
          backgroundColor: kMentorXPrimary,
          child: profilePictureStatus
              ? null
              : Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 40.0,
                ),
        ),
        otherAccountsPictures: [
          CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0),
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Icon(
                Icons.close,
                color: accountCardTextColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}

Color iconColor = Colors.white;
Color iconText = Colors.white;

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
            color: iconColor,
          ),
          title: Text(
            'Home',
            style: TextStyle(color: iconText, fontSize: 20),
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
            color: iconColor,
          ),
          title: Text(
            'My Profile',
            style: TextStyle(color: iconText, fontSize: 20),
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
            color: iconColor,
          ),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LaunchScreen(pageIndex: 2),
            ),
          ),
          title: Text(
            'Mentoring',
            style: TextStyle(color: iconText, fontSize: 20),
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.settings,
            color: iconColor,
          ),
          title: Text(
            'Settings',
            style: TextStyle(color: iconText, fontSize: 20),
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
            color: iconColor,
          ),
          title: Text(
            'Log Out',
            style: TextStyle(color: iconText, fontSize: 20),
          ),
          onTap: () {
            confirmSignOut(context);
          },
        ),
      ],
    );
  }
}