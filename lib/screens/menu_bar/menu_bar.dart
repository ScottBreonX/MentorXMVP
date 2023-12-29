import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/sign_out.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/authentication/landing_page.dart';
import 'package:mentorx_mvp/screens/chat/chat_gpt.dart';
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
                  color: Theme.of(context).iconTheme.color,
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
            color: Theme.of(context).iconTheme.color,
          ),
          title: Text(
            'Program Home',
            style: Theme.of(context).textTheme.displayMedium,
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
            color: Theme.of(context).iconTheme.color,
          ),
          title: Text(
            'My Profile',
            style: Theme.of(context).textTheme.displayMedium,
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
            color: Theme.of(context).iconTheme.color,
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
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ),
        // ListTile(
        //   leading: Icon(
        //     Icons.sunny,
        //     size: 30,
        //     color: Theme.of(context).iconTheme.color,
        //   ),
        //   onTap: () {
        //     showDialog(
        //       context: context,
        //       builder: (context) {
        //         return SimpleDialog(
        //           shape: RoundedRectangleBorder(
        //             borderRadius: BorderRadius.circular(20),
        //           ),
        //           title: Center(
        //             child: Padding(
        //               padding: const EdgeInsets.all(8.0),
        //               child: Text(
        //                 "Choose your app color theme",
        //                 textAlign: TextAlign.center,
        //                 style: Theme.of(context).textTheme.headlineMedium,
        //               ),
        //             ),
        //           ),
        //           children: <Widget>[
        //             Row(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               children: [
        //                 Padding(
        //                   padding: const EdgeInsets.all(8.0),
        //                   child: RoundedButton(
        //                     minWidth: 120,
        //                     title: "Dark Mode",
        //                     prefixIcon: Icon(
        //                       Icons.dark_mode,
        //                       color: Colors.white,
        //                     ),
        //                     buttonColor: kMentorXPPrimary,
        //                     fontColor: Colors.white,
        //                     fontWeight: FontWeight.w500,
        //                     fontSize: 15,
        //                     onPressed: () => MentorX.of(context).changeTheme(
        //                       AppTheme.darkTheme,
        //                     ),
        //                   ),
        //                 ),
        //                 Padding(
        //                   padding: const EdgeInsets.all(8.0),
        //                   child: RoundedButton(
        //                     minWidth: 120,
        //                     title: "Light Mode",
        //                     prefixIcon: Icon(
        //                       Icons.sunny,
        //                       color: kMentorXPPrimary,
        //                     ),
        //                     buttonColor: Colors.white,
        //                     fontColor: kMentorXPPrimary,
        //                     fontWeight: FontWeight.w500,
        //                     fontSize: 15,
        //                     onPressed: () => MentorX.of(context)
        //                         .changeTheme(AppTheme.lightTheme),
        //                   ),
        //                 )
        //               ],
        //             ),
        //           ],
        //         );
        //       },
        //     );
        //     // MentorX.of(context).changeTheme(AppTheme.darkTheme);
        //   },
        //   title: Text(
        //     'Change Theme',
        //     style: Theme.of(context).textTheme.displayMedium,
        //   ),
        // ),
        loggedInUser.canCreateProgram
            ? ListTile(
                leading: Icon(
                  Icons.create_new_folder_rounded,
                  color: Theme.of(context).iconTheme.color,
                ),
                title: Text(
                  'Create a Program',
                  style: Theme.of(context).textTheme.displayMedium,
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
        loggedInUser.canCreateProgram
            ? ListTile(
                leading: Icon(
                  Icons.blur_circular_sharp,
                  color: Theme.of(context).iconTheme.color,
                ),
                title: Text(
                  'ChatGPT Test',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatGPTScreen(
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
            color: Theme.of(context).iconTheme.color,
          ),
          title: Text(
            'Log Out',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          onTap: () {
            confirmSignOut(context);
          },
        ),
      ],
    );
  }
}
