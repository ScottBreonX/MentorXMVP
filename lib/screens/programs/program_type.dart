import 'package:flutter/material.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/screens/authentication/landing_page.dart';
import 'package:mentorx_mvp/screens/programs/available_programs.dart';

class ProgramTypeScreen extends StatefulWidget {
  static const String id = 'program_type_screen';

  @override
  _ProgramTypeScreenState createState() => _ProgramTypeScreenState();
}

class _ProgramTypeScreenState extends State<ProgramTypeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMentorXPPrimary,
        elevation: 5,
        title: Image.asset(
          'assets/images/MentorXP.png',
          height: 100,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 25, 0, 10),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: Column(
                children: [
                  Text(
                    'Program Type',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.black45,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 30.0,
                      right: 30.0,
                      top: 10,
                      bottom: 20,
                    ),
                    child: Divider(
                      thickness: 3,
                      endIndent: 15,
                      indent: 15,
                      color: Colors.grey,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, bottom: 5.0),
                        child: GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AvailableProgramsScreen(
                                loggedInUser: loggedInUser,
                                programType: 'school',
                              ),
                            ),
                          ),
                          child: Container(
                            height: 100,
                            width: 350,
                            child: Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Icon(
                                      Icons.school,
                                      size: 40,
                                      color: kMentorXPPrimary,
                                    ),
                                  ),
                                  Text(
                                    'University Programs',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black45,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AvailableProgramsScreen(
                            loggedInUser: loggedInUser,
                            programType: 'mentorX',
                          ),
                        ),
                      ),
                      child: Container(
                        width: 350,
                        height: 100,
                        child: Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 140.0, top: 0.0),
                                child: Text(
                                  'Programs',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black45,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 363,
              right: 150,
              left: 0,
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AvailableProgramsScreen(
                      loggedInUser: loggedInUser,
                      programType: 'mentorX',
                    ),
                  ),
                ),
                child: Image.asset(
                  'assets/images/MentorXPDark.png',
                  height: 110,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
