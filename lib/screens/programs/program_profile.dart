import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/progress.dart';
import 'package:mentorx_mvp/models/program.dart';
import 'package:mentorx_mvp/screens/home_screen.dart';
import 'package:mentorx_mvp/screens/menu_bar/menu_bar.dart';

class ProgramProfile extends StatefulWidget {
  final loggedInUser;
  final String programId;
  static String id = 'program_screen';

  const ProgramProfile({
    this.programId,
    this.loggedInUser,
  });

  @override
  State<ProgramProfile> createState() => _ProgramProfileState();
}

class _ProgramProfileState extends State<ProgramProfile> {
  @override
  Widget build(BuildContext context) {
    final drawerItems = MentorXMenuList(loggedInUser: widget.loggedInUser);
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();

    return FutureBuilder<Object>(
        future: programsRef.doc(widget.programId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          Program program = Program.fromDocument(snapshot.data);
          return Scaffold(
            key: _scaffoldKey,
            drawer: Drawer(
              child: Container(
                child: drawerItems,
              ),
            ),
            appBar: AppBar(
              elevation: 5,
              title: Text('${program.programName}'),
            ),
            body: Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.attach_money_outlined,
                      size: 150,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                      child: Text(
                        '${program.institutionName}\'s \n ${program.programName} Mentorship Program',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                          color: Theme.of(context).textTheme.headline1.color,
                        ),
                      ),
                    ),
                    Divider(
                      thickness: 8,
                      color: Theme.of(context).dividerColor,
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Type of program',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color:
                                  Theme.of(context).textTheme.headline1.color,
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.grey,
                            ),
                            height: 45,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              child: Text(
                                '${program.enrollmentType.toUpperCase()}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline4
                                      .color,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'About this program',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color:
                                  Theme.of(context).textTheme.headline1.color,
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              child: Text(
                                '${program.aboutProgram}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline4
                                      .color,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        'Want to join?',
                        style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).textTheme.button.color),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context)
                            .buttonTheme
                            .colorScheme
                            .background,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
