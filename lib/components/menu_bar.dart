import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/sign_out.dart';
import '../constants.dart';
import '../bottom_navigation_bar.dart';

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

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: UserAccountsDrawerHeader(
        key: _scaffoldKey,
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.10),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: kMentorXBlack,
                offset: Offset(1, 2),
                blurRadius: 2,
              )
            ]),
        accountName: Text(
          '${widget.fName} ${widget.lName}',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        accountEmail: Text(
          '${widget.email}',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        currentAccountPicture: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(60),
              color: Colors.white.withOpacity(0.05),
              boxShadow: [
                BoxShadow(
                  color: kMentorXBlack,
                  offset: Offset(2, 3),
                  blurRadius: 2,
                ),
              ]),
          child: CircleAvatar(
            backgroundImage: profilePictureStatus
                ? NetworkImage(widget.profilePicture)
                : null,
            backgroundColor: Colors.white.withOpacity(0.05),
            child: profilePictureStatus
                ? null
                : Icon(
                    Icons.person,
                    color: kMentorXPrimary,
                    size: 42.0,
                  ),
          ),
        ),
        otherAccountsPictures: [
          CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0),
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Icon(
                Icons.close,
                color: kMentorXPrimary,
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
            color: Colors.white,
          ),
          title: Text(
            'Home',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => XBottomNavigationBar(
                pageIndex: 0,
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
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => XBottomNavigationBar(
                pageIndex: 3,
              ),
            ),
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.people,
            color: Colors.white,
          ),
          title: Text(
            'Mentoring',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => XBottomNavigationBar(
                pageIndex: 2,
              ),
            ),
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.calendar_today,
            color: Colors.white,
          ),
          title: Text(
            'Events',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => XBottomNavigationBar(
                  pageIndex: 1,
                ),
              ),
            );
          },
        ),
        ListTile(
          leading: Icon(
            Icons.settings,
            color: Colors.white,
          ),
          title: Text(
            'Settings',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onTap: () {},
        ),
        ListTile(
          title: const Text(
            '',
            style: TextStyle(color: Colors.white),
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
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onTap: () {
            confirmSignOut(context);
          },
        ),
      ],
    );
  }
}
