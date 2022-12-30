import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/sign_out.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/home_screen/home_screen.dart';
import 'package:mentorx_mvp/screens/program_creation/program_creation.dart';
import 'package:mentorx_mvp/screens/programs/program_selection_screen.dart';
import 'package:mentorx_mvp/screens/programs/program_type.dart';
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
            Image.asset(
              'assets/images/MentorXP.png',
              width: 200,
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
      ],
    );
  }
}
