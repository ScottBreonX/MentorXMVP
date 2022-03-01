import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/icon_card.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/launch_screen.dart';
import 'package:mentorx_mvp/screens/mentoring/available_mentors.dart';
import 'package:mentorx_mvp/screens/mentoring/mentoring_screen.dart';
import 'package:mentorx_mvp/services/database.dart';

class OldMentorLaunchScreen extends StatefulWidget {
  final myUser loggedInUser;

  OldMentorLaunchScreen({
    this.database,
    this.loggedInUser,
  });

  static const String id = 'old_mentor_launch_screen';
  final Database database;

  @override
  _OldMentorLaunchScreenState createState() => _OldMentorLaunchScreenState();
}

class _OldMentorLaunchScreenState extends State<OldMentorLaunchScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        title: Text('Mentoring'),
      ),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      child: Image.asset(
                        'assets/images/UMichLogo.png',
                        height: 200,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Center(
                      child: Text(
                        'University of Michigan',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline1,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Center(
                          child: Text(
                            'Mentorship Program',
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Divider(),
            Column(
              children: [
                Wrap(
                  children: [
                    Container(
                      child: IconCard(
                        cardText: 'Mentoring',
                        cardColor: Theme.of(context).cardColor,
                        cardIcon: Icons.group,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MentoringScreen(),
                          ),
                        ),
                      ),
                    ),
                    IconCard(
                      cardText: 'News Feed',
                      cardColor: Theme.of(context).cardColor,
                      cardIcon: Icons.article_outlined,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LaunchScreen(pageIndex: 0),
                        ),
                      ),
                    ),
                    IconCard(
                      cardText: 'Calendar',
                      cardColor: Theme.of(context).cardColor,
                      cardIcon: Icons.date_range,
                      onTap: () {},
                    ),
                    IconCard(
                      cardText: 'Program Info',
                      cardColor: Theme.of(context).cardColor,
                      cardIcon: Icons.info_outline,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AvailableMentorsScreen(
                            loggedInUser: widget.loggedInUser,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 80.0),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
