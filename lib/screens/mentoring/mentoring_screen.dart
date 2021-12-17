import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/models/mentee_model.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/home_screen.dart';
import 'package:mentorx_mvp/screens/menu_bar/menu_bar.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/services/database.dart';

class MentoringScreen extends StatefulWidget {
  final myUser loggedInUser;
  static const String id = 'mentoring_screen';
  final Database database;

  const MentoringScreen({
    Key key,
    this.loggedInUser,
    this.database,
  }) : super(key: key);

  @override
  _MentoringScreenState createState() => _MentoringScreenState();
}

class _MentoringScreenState extends State<MentoringScreen> {
  bool aboutMeEditStatus = false;
  bool profilePhotoSelected = false;
  String aboutMeText;
  bool isLoading = false;
  List<Mentee> matches = [];

  @override
  void initState() {
    getMatchData();
    aboutMeEditStatus = false;
    super.initState();
  }

  dynamic matchData;

  Future<dynamic> getMatchData() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot snapshot =
        await mentorsRef.doc(loggedInUser.id).collection('userMentoring').get();
    setState(() {
      isLoading = false;
      matches = snapshot.docs.map((doc) => Mentee.fromDocument(doc)).toList();
    });
  }

  buildUserMentees() {
    if (isLoading) {
      return CircularProgressIndicator();
    }
    return Column(children: matches);
  }

  @override
  Widget build(BuildContext context) {
    // if (profileData == null) {
    //   return Center(
    //     child: CircularProgressIndicator(
    //       backgroundColor: kMentorXPrimary,
    //     ),
    //   );
    // }

    // if (profileData['images'] == null) {
    //   setState(() {
    //     profilePhotoStatus = false;
    //   });
    // } else {
    //   setState(() {
    //     profilePhotoStatus = true;
    //   });
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
        backgroundColor: kMentorXPrimary,
        elevation: 5,
        title: Text('MentoringScreen'),
      ),
      body: ListView(
        children: <Widget>[buildUserMentees()],
      ),
    );
  }
}
