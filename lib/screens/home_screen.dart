import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/progress.dart';
import 'package:mentorx_mvp/models/user.dart';
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
  bool loggedIn = true;

  @override
  void initState() {
    pageController = PageController(initialPage: widget.pageIndex ?? 0);
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser() async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    try {
      final user = auth.currentUser;
      if (user != null) {
        DocumentSnapshot doc = await usersRef.doc(user.uid).get();
        loggedInUser = myUser.fromDocument(doc);
      }
    } catch (e) {
      print(e);
    }
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
    pageController.jumpToPage(
      pageIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loggedInUser == null) {
      return circularProgress();
    }

    return Scaffold(
      body: PageView(
        children: [
          SelectionScreen(loggedInUser: loggedInUser),
          Profile(
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
