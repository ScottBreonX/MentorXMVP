import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/icon_card.dart';
import 'package:mentorx_mvp/screens/mentoring/mentor_lauch_screen.dart';
import 'package:mentorx_mvp/screens/menu_bar/menu_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mentorx_mvp/services/auth.dart';
import 'package:mentorx_mvp/services/database.dart';
import 'package:provider/provider.dart';

User loggedInUser;

class ProgramSelectionScreen extends StatefulWidget {
  const ProgramSelectionScreen({
    Key key,
    this.database,
  }) : super(key: key);

  static const String id = 'program_selection_screen';
  final Database database;

  @override
  _ProgramSelectionScreenState createState() => _ProgramSelectionScreenState();
}

class _ProgramSelectionScreenState extends State<ProgramSelectionScreen> {
  @override
  void initState() {
    getCurrentUser();
    getProfileData();
    super.initState();
  }

  void getCurrentUser() {
    final auth = Provider.of<AuthBase>(context, listen: false);
    try {
      final user = auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  dynamic profileData;

  Future<dynamic> getProfileData() async {
    await FirebaseFirestore.instance
        .collection('users/${loggedInUser.uid}/profile')
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        if (mounted) {
          setState(() {
            profileData = result.data();
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // if (profileData == null) {
    //   return Center();
    // }

    final drawerItems = MentorXMenuList();
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Container(
          child: drawerItems,
        ),
      ),
      appBar: AppBar(
        elevation: 5,
        title: Text('Program Selection'),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Wrap(
                children: [
                  IconCard(
                    cardIcon: Icons.add,
                    cardColor: Theme.of(context).cardColor,
                    cardText: 'Join a Program',
                    borderWidth: 3,
                    onTap: () {},
                  ),
                  IconCard(
                    cardText: 'University of Michigan',
                    cardColor: Theme.of(context).cardColor,
                    imageAsset: Image.asset(
                      'assets/images/UMichLogo.png',
                      height: 60,
                    ),
                    onTap: () {
                      Navigator.popAndPushNamed(context, MentorLaunch.id);
                    },
                  ),
                  IconCard(
                    cardText: 'Finance Careers Mentorship',
                    cardColor: Theme.of(context).cardColor,
                    imageAsset: Image.asset(
                      'assets/images/MLogoBlue.png',
                      height: 60,
                    ),
                    onTap: () {
                      Navigator.popAndPushNamed(context, MentorLaunch.id);
                    },
                  ),
                  IconCard(
                    cardText: 'Consulting Careers Mentorship',
                    cardColor: Theme.of(context).cardColor,
                    imageAsset: Image.asset(
                      'assets/images/MLogoBlue.png',
                      height: 60,
                    ),
                    onTap: () {
                      Navigator.popAndPushNamed(context, MentorLaunch.id);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
