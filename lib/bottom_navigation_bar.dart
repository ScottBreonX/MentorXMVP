import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/screens/enrollment/enrollment_start_screen.dart';
import 'package:mentorx_mvp/screens/events/events_screen.dart';
import 'package:mentorx_mvp/screens/launch_screen.dart';
import 'package:mentorx_mvp/screens/profile/profile_screen.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

class XBottomNavigationBar extends StatefulWidget {
  const XBottomNavigationBar({@required this.pageIndex});
  final int pageIndex;
  static const String id = 'bottom_navigation_bar';

  @override
  _XBottomNavigationBarState createState() => new _XBottomNavigationBarState();
}

class _XBottomNavigationBarState extends State<XBottomNavigationBar> {
  PageController _pageController;

  List<Widget> tabPages = [
    LaunchScreen(),
    EventsScreen(),
    EnrollmentStartScreen(),
    MyProfile(),
  ];

  int pageIndex;

  void getPageIndex() {
    if (widget.pageIndex != null) {
      pageIndex = widget.pageIndex;
    } else {
      pageIndex = 0;
    }
  }

  @override
  void initState() {
    super.initState();
    getPageIndex();
    _pageController = PageController(initialPage: pageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (pageIndex < 4) {
      pageIndex = pageIndex;
    } else {
      pageIndex = pageIndex - 1;
    }

    return Scaffold(
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.reactCircle,
        activeColor: kMentorXPrimary,
        initialActiveIndex: pageIndex,
        color: kMentorXPrimary,
        onTap: onTabTapped,
        backgroundColor: kMentorXDark,
        top: -30,
        curveSize: 100,
        elevation: 5,
        items: [
          TabItem(
            icon: Icons.home,
            title: 'Home',
          ),
          TabItem(icon: Icons.calendar_today, title: 'Events'),
          TabItem(icon: Icons.people, title: 'Mentoring'),
          TabItem(icon: Icons.person, title: 'Profile'),
        ],
      ),
      body: PageView(
        children: tabPages,
        onPageChanged: onPageChanged,
        controller: _pageController,
      ),
    );
  }

  void onPageChanged(int page) {
    setState(() {
      this.pageIndex = page;
    });
  }

  void onTabTapped(pageIndex) {
    this._pageController.jumpToPage(pageIndex);
  }
}
