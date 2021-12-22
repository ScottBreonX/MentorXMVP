import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/progress.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/authentication/welcome_screen.dart';
import 'package:mentorx_mvp/screens/profile/profile_screen.dart';
import 'package:mentorx_mvp/screens/programs/program_selection_screen.dart';
import 'package:mentorx_mvp/screens/selection_screen/selection_screen.dart';
import 'package:mentorx_mvp/services/auth.dart';
import 'package:provider/provider.dart';
import 'notifications/notifications_screen.dart';

myUser loggedInUser;
final usersRef = FirebaseFirestore.instance.collection('users');
final mentorsRef = FirebaseFirestore.instance.collection('mentors');
final mentoringRef = FirebaseFirestore.instance.collection('mentoring');
final programsRef = FirebaseFirestore.instance.collection('institutions');

class HomeScreen extends StatefulWidget {
  const HomeScreen({this.onSignOut, this.pageIndex});

  static const String id = 'home_screen';
  final VoidCallback onSignOut;
  final int pageIndex;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController pageController;
  int pageIndex;
  bool loggedIn = false;

  @override
  void initState() {
    pageController = PageController(initialPage: widget.pageIndex ?? 0);
    getCurrentUser();
    super.initState();
  }

  getCurrentUser() async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    loggedInUser = myUser.fromDocument(
        await usersRef.doc(auth.currentUser.uid).get().whenComplete(() {
      if (mounted) {
        setState(() {
          loggedIn = true;
        });
      }
    }));
    print(loggedInUser.firstName);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex ?? widget.pageIndex;
    });
  }

  onTap(int pageIndex) {
    pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 100),
      curve: Curves.linear,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loggedIn == false) {
      return circularProgressBlue();
    }

    return Scaffold(
      body: PageView(
        children: [
          SelectionScreen(loggedInUser: loggedInUser),
          Profile(
            loggedInUser: loggedInUser.id,
            profileId: loggedInUser.id,
          ),
          ProgramSelectionScreen(loggedInUser: loggedInUser),
          NotificationScreen(loggedInUser: loggedInUser),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: pageIndex ?? widget.pageIndex ?? 0,
        onTap: onTap,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home)),
          BottomNavigationBarItem(icon: Icon(Icons.person)),
          BottomNavigationBarItem(icon: Icon(Icons.people)),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_active)),
        ],
      ),
    );
  }
}
