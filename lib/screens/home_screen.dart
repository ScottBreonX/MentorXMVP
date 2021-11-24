import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mentorx_mvp/screens/profile/profile_screen.dart';
import 'package:mentorx_mvp/screens/programs/program_selection_screen.dart';
import 'package:mentorx_mvp/screens/selection_screen/selection_screen.dart';
import 'package:mentorx_mvp/services/auth.dart';
import 'package:provider/provider.dart';
import 'notifications/notifications_screen.dart';

User loggedInUser;
final usersRef = FirebaseFirestore.instance.collection('users');
final mentorsRef = FirebaseFirestore.instance.collection('mentors');

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

  @override
  void initState() {
    pageController = PageController(initialPage: widget.pageIndex ?? 0);
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
    if (profileData == null) {
      return Center();
    }

    return Scaffold(
      body: PageView(
        children: [
          SelectionScreen(),
          MyProfile(),
          ProgramSelectionScreen(),
          NotificationScreen(),
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
