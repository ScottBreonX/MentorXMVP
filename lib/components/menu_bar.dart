import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/sign_out.dart';
import '../constants.dart';
import 'bottom_navigation_bar.dart';

class MentorXMenuHeader extends StatefulWidget {
  const MentorXMenuHeader(
      {@required this.fName, @required this.lName, @required this.email});
  final String fName;
  final String lName;
  final String email;

  @override
  _MentorXMenuHeaderState createState() => _MentorXMenuHeaderState();
}

class _MentorXMenuHeaderState extends State<MentorXMenuHeader> {
  @override
  Widget build(BuildContext context) {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            kMentorXTeal,
            kMentorXTeal,
          ],
        ),
      ),
      accountName: Text('${widget.fName} ${widget.lName}'),
      accountEmail: Text('${widget.email}'),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(
          Icons.person,
          color: kMentorXTeal,
          size: 42.0,
        ),
      ),
      otherAccountsPictures: [
        CircleAvatar(
          backgroundColor: Colors.white,
          child: Image.asset(
            'images/XLogo.png',
            height: 30,
          ),
        )
      ],
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
          leading: Icon(Icons.home),
          title: Text(
            'Home',
            style: TextStyle(color: Colors.grey, fontSize: 20),
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
          leading: Icon(Icons.person),
          title: Text(
            'My Profile',
            style: TextStyle(color: Colors.grey, fontSize: 20),
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
          leading: Icon(Icons.people),
          title: Text(
            'Mentoring',
            style: TextStyle(color: Colors.grey, fontSize: 20),
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
          leading: Icon(Icons.calendar_today),
          title: Text(
            'Events',
            style: TextStyle(color: Colors.grey, fontSize: 20),
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
          leading: Icon(Icons.settings),
          title: Text(
            'Settings',
            style: TextStyle(color: Colors.grey, fontSize: 20),
          ),
          onTap: () {},
        ),
        ListTile(
          title: const Text(
            '',
            style: TextStyle(color: Colors.grey),
          ),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.exit_to_app_rounded),
          title: Text(
            'Log Out',
            style: TextStyle(color: Colors.grey, fontSize: 20),
          ),
          onTap: () {
            confirmSignOut(context);
          },
        ),
      ],
    );
  }
}
