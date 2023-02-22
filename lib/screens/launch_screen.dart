import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/progress.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/profile/profile_screen.dart';
import 'package:mentorx_mvp/services/auth.dart';
import 'package:provider/provider.dart';
import 'home_screen/home_screen.dart';

myUser loggedInUser;
final usersRef = FirebaseFirestore.instance.collection('users');
final mentorsRef = FirebaseFirestore.instance.collection('mentors');
final menteesRef = FirebaseFirestore.instance.collection('mentees');
final mentoringRef = FirebaseFirestore.instance.collection('mentoring');
final programsRef = FirebaseFirestore.instance.collection('institutions');

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({this.onSignOut, this.pageIndex});

  static const String id = 'launch_screen';
  final VoidCallback onSignOut;
  final int pageIndex;

  @override
  _LaunchScreenState createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
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
      duration: Duration(milliseconds: 50000),
      curve: Curves.bounceInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loggedIn == false || loggedInUser == null) {
      return circularProgressBlue();
    }

    return Scaffold(
      body: PageView(
        children: [
          HomeScreen(loggedInUser: loggedInUser),
          Profile(
            loggedInUser: loggedInUser,
            profileId: loggedInUser.id,
          ),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: pageIndex ?? widget.pageIndex ?? 0,
        onTap: onTap,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
            Icons.home,
            size: 40,
          )),
          BottomNavigationBarItem(
              icon: Icon(
            Icons.groups,
            size: 50,
          )),
          BottomNavigationBarItem(
              icon: Icon(
            Icons.person,
            size: 40,
          )),
        ],
      ),
    );
  }
}
