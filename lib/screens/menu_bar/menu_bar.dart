import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/sign_out.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/authentication/landing_page.dart';
import 'package:mentorx_mvp/screens/program_creation/program_creation.dart';
import 'package:mentorx_mvp/screens/programs/available_programs.dart';
import '../profile/profile_screen.dart';

final usersRef = FirebaseFirestore.instance.collection('users');

class MentorXMenuList extends StatelessWidget {
  final myUser loggedInUser;

  MentorXMenuList({
    this.loggedInUser,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Image.asset(
                'assets/images/MentorXP.png',
                width: 150,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 20),
              child: GestureDetector(
                child: Icon(
                  Icons.close_outlined,
                  size: 20,
                  color: Colors.white,
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
        SizedBox(
          height: 40,
        ),
        ListTile(
          leading: Icon(
            Icons.home,
            color: Colors.white,
          ),
          title: Text(
            'Program Home',
            style: TextStyle(
              fontFamily: 'Montserrat',
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LandingPage(),
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
            style: TextStyle(
              fontFamily: 'Montserrat',
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Profile(
                loggedInUser: loggedInUser,
                profileId: loggedInUser.id,
              ),
            ),
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
              builder: (context) => AvailableProgramsScreen(
                loggedInUser: loggedInUser,
              ),
            ),
          ),
          title: Text(
            'Join New Program',
            style: TextStyle(
              fontFamily: 'Montserrat',
              color: Colors.white,
              fontSize: 20,
            ),
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
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                    fontSize: 20,
                  ),
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
            style: TextStyle(
              fontFamily: 'Montserrat',
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          onTap: () {
            confirmSignOut(context);
          },
        ),
      ],
    );
  }
}
