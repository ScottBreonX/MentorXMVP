import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/menu_bar/menu_bar.dart';
import 'package:mentorx_mvp/screens/programs/program_type.dart';
import 'package:mentorx_mvp/services/database.dart';
import '../../components/progress.dart';
import '../../components/rounded_button.dart';
import '../../models/program_list.dart';

myUser loggedInUser;

class ProgramSelectionScreen extends StatefulWidget {
  final myUser loggedInUser;
  static const String id = 'program_selection_screen';
  final Database database;

  const ProgramSelectionScreen({
    this.loggedInUser,
    this.database,
  });

  @override
  _ProgramSelectionScreenState createState() => _ProgramSelectionScreenState();
}

class _ProgramSelectionScreenState extends State<ProgramSelectionScreen> {
  @override
  void initState() {
    super.initState();
  }

  bool isLoading = false;
  bool hasPrograms = false;
  List<ProgramList> programs = [];

  Future<dynamic> getProgramData() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot snapshot = await usersRef
        .doc(widget.loggedInUser.id)
        .collection('enrolledPrograms')
        .get();
    if (snapshot.docs.isNotEmpty) {
      setState(() {
        isLoading = false;
        hasPrograms = true;
        programs =
            snapshot.docs.map((doc) => ProgramList.fromDocument(doc)).toList();
      });
    }
  }

  buildEnrolledPrograms() {
    String userID = widget.loggedInUser.id;
    String collectionPath = 'enrolledPrograms';
    isLoading = true;
    QuerySnapshot _snapshot;
    return FutureBuilder(
      future: usersRef.doc(userID).collection(collectionPath).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        } else {
          _snapshot = snapshot.data;
          if (_snapshot.size > 0) {
            programs = _snapshot.docs
                .map((doc) => ProgramList.fromDocument(doc))
                .toList();
            return Wrap(
              children: programs,
            );
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 25),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Wrap(
                      children: [
                        Text(
                          'You have not enrolled in any programs yet',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'WorkSans',
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final drawerItems = MentorXMenuList(loggedInUser: widget.loggedInUser);
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
        title: Image.asset(
          'assets/images/MentorPinkWhite.png',
          height: 150,
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: RoundedButton(
                  title: 'Join a new program',
                  buttonColor: Colors.pink,
                  fontColor: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProgramTypeScreen(
                          loggedInUser: widget.loggedInUser,
                        ),
                      ),
                    );
                  },
                  minWidth: 300,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 100.0, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Icon(
                        Icons.check_circle,
                        size: 40,
                        color: Colors.blue,
                      ),
                    ),
                    Text(
                      'Enrolled Programs',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'WorkSans',
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 4,
                indent: 40,
                endIndent: 40,
                color: Colors.black45,
              ),
              buildEnrolledPrograms(),
            ],
          ),
        ),
      ),
    );
  }
}
