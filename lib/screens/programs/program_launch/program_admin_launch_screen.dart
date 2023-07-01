import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/models/user.dart';
import '../../../constants.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');

class ProgramAdminLaunchScreen extends StatefulWidget {
  final myUser loggedInUser;
  final String programUID;

  const ProgramAdminLaunchScreen({
    Key key,
    this.loggedInUser,
    this.programUID,
  }) : super(key: key);

  static const String id = 'program_admin_launch_screen';

  @override
  _ProgramAdminLaunchScreenState createState() =>
      _ProgramAdminLaunchScreenState();
}

class _ProgramAdminLaunchScreenState extends State<ProgramAdminLaunchScreen> {
  @override
  void initState() {
    super.initState();
    _mentorQuery();
    _menteeQuery();
    _programUserQuery();
  }

  _mentorQuery() async {
    var query = programsRef.doc(widget.programUID).collection("mentors");
    var snapshot = await query.get();
    setState(() {
      _mentorCount = snapshot.size;
    });
  }

  _menteeQuery() async {
    var query = programsRef.doc(widget.programUID).collection("mentees");
    var snapshot = await query.get();
    setState(() {
      _menteeCount = snapshot.size;
    });
  }

  _programUserQuery() async {
    var query = programsRef.doc(widget.programUID).collection("userSubscribed");
    var snapshot = await query.get();
    setState(() {
      _programUsers = snapshot.size;
    });
  }

  int _mentorCount;
  int _menteeCount;
  int _programUsers;
  int _unenrolledUsers;
  int _mentorMenteeRatio;

  @override
  Widget build(BuildContext context) {
    if (_programUsers == null || _mentorCount == null || _menteeCount == null) {
      return Center(
        child: CircularProgressIndicator(
          color: kMentorXPAccentDark,
        ),
      );
    }
    _unenrolledUsers = _programUsers - _mentorCount - _menteeCount;
    _mentorMenteeRatio = _mentorCount ~/ _menteeCount;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMentorXPPrimary,
        elevation: 5,
        title: Image.asset(
          'assets/images/MentorXP.png',
          height: 35,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 40.0, bottom: 40),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bar_chart,
                      color: kMentorXPAccentDark,
                      size: 50,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Program Stats',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 2,
                color: Colors.grey,
                indent: 10,
                endIndent: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 10.0, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Enrollment Stats',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 20,
                        color: kMentorXPPrimary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _programUserQuery();
                          _menteeQuery();
                          _mentorQuery();
                        });
                      },
                      child: Icon(
                        Icons.refresh,
                        color: kMentorXPPrimary,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 20, right: 10),
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      statWidget(
                        '$_programUsers',
                        'total # of users',
                        kMentorXPPrimary,
                      ),
                      VerticalDivider(
                        color: kMentorXPPrimary,
                        thickness: 2,
                      ),
                      statWidget(
                        '$_menteeCount',
                        '# of mentees',
                        kMentorXPPrimary,
                      ),
                      statWidget(
                        '$_mentorCount',
                        '# of mentors',
                        kMentorXPPrimary,
                      ),
                      statWidget(
                        '$_unenrolledUsers',
                        'not enrolled',
                        kMentorXPPrimary,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Divider(
                thickness: 1,
                color: Colors.grey.shade400,
                endIndent: 10,
                indent: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 10.0, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Mentor Stats',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 20,
                          color: kMentorXPSecondary),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _mentorQuery();
                        });
                      },
                      child: Icon(
                        Icons.refresh,
                        color: kMentorXPSecondary,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 20, right: 10),
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      statWidget(
                        '$_mentorCount',
                        'total # of mentors',
                        kMentorXPSecondary,
                      ),
                      VerticalDivider(
                        color: kMentorXPSecondary,
                        thickness: 2,
                      ),
                      statWidget(
                        '$_mentorMenteeRatio',
                        '# of mentees per mentor',
                        kMentorXPSecondary,
                      ),
                      statWidget(
                        '4',
                        'total mentor slots',
                        kMentorXPSecondary,
                      ),
                      statWidget(
                        '2.4',
                        'total mentor slots per mentor',
                        kMentorXPSecondary,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Divider(
                thickness: 1,
                color: Colors.grey.shade400,
                endIndent: 10,
                indent: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 10.0, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Mentoring Availability Stats',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 20,
                        color: kMentorXPAccentDark,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _mentorQuery();
                        });
                      },
                      child: Icon(
                        Icons.refresh,
                        color: kMentorXPAccentDark,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 20, right: 10),
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      statWidget(
                        '10',
                        'total available slots',
                        kMentorXPAccentDark,
                      ),
                      VerticalDivider(
                        color: kMentorXPAccentDark,
                        thickness: 2,
                      ),
                      statWidget(
                        '22.4',
                        'unmatched mentees',
                        kMentorXPAccentDark,
                      ),
                      statWidget(
                        '4',
                        'available slots per mentee',
                        kMentorXPAccentDark,
                      ),
                      statWidget(
                        '2',
                        'available slots per unmatched',
                        kMentorXPAccentDark,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container statWidget(
    String statNumber,
    String statDescription,
    Color boxColor,
  ) {
    return Container(
      width: 95,
      height: 100,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(3, 3),
            blurRadius: 4,
          ),
        ],
        border: Border.all(
          color: boxColor,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(
          20,
        ),
      ),
      child: Column(
        children: [
          Text(
            '$statNumber',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: boxColor,
            ),
          ),
          Text(
            '$statDescription',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.black45,
            ),
          ),
        ],
      ),
    );
  }
}
