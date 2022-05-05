import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../components/program_card.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');

class MentoringLaunchGuides extends StatefulWidget {
  const MentoringLaunchGuides({
    Key key,
  }) : super(key: key);

  static const String id = 'mentoring_launch_guides_screen';

  @override
  _MentoringLaunchGuidesState createState() => _MentoringLaunchGuidesState();
}

class _MentoringLaunchGuidesState extends State<MentoringLaunchGuides> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        title: Image.asset(
          'assets/images/MentorPinkWhite.png',
          height: 150,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 10.0,
                  bottom: 10.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10.0, top: 20),
                                child: Text(
                                  'Program Guides',
                                  style: Theme.of(context).textTheme.headline1,
                                ),
                              )
                            ],
                          ),
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                ProgramCard(
                                  programStartDate: 'This Week',
                                  programEndDate: '',
                                  programName: 'Resume 101',
                                ),
                                ProgramCard(
                                  programStartDate: 'Next Week',
                                  programEndDate: '',
                                  programName: 'Initial Chat',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
