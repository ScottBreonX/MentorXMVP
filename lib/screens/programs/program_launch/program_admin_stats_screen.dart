import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/models/user.dart';
import '../../../constants.dart';
import '../../../models/mentor_match_models/mentor_model.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');

class ProgramAdminStatsScreen extends StatefulWidget {
  final myUser loggedInUser;
  final String programUID;

  const ProgramAdminStatsScreen({
    Key key,
    this.loggedInUser,
    this.programUID,
  }) : super(key: key);

  static const String id = 'program_admin_stats_screen';

  @override
  _ProgramAdminStatsScreenState createState() =>
      _ProgramAdminStatsScreenState();
}

class _ProgramAdminStatsScreenState extends State<ProgramAdminStatsScreen> {
  @override
  void initState() {
    super.initState();
    _mentorQuery();
    _menteeQuery();
    _programUserQuery();
    _mentorSlotsQuery();
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

  _mentorSlotsQuery() async {
    List<int> mentorSlots = [];

    await programsRef
        .doc(widget.programUID)
        .collection('mentors')
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((mentor) {
        Mentor mentorModel = Mentor.fromDocument(mentor);
        mentorSlots.add(mentorModel.mentorSlots);
      });
    });

    setState(() {
      _mentorSlots = mentorSlots.fold(0, (p, c) => p + c);
    });
  }

  int _mentorCount;
  int _menteeCount;
  int _programUsers;
  int _unenrolledUsers;
  int _mentorSlots;
  double _mentorMenteeRatio;
  double _mentorSlotRatio;

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
    _mentorMenteeRatio = _menteeCount / _mentorCount;
    _mentorSlotRatio = _mentorSlots / _mentorCount;

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
                          _mentorSlotsQuery();
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
                        '$_mentorSlots',
                        'available mentor slots',
                        kMentorXPSecondary,
                      ),
                      VerticalDivider(
                        color: kMentorXPSecondary,
                        thickness: 2,
                      ),
                      statWidget(
                        '$_mentorSlotRatio',
                        'mentor slots per mentor',
                        kMentorXPSecondary,
                      ),
                      statWidget(
                        'XX',
                        'unmatched mentees',
                        kMentorXPSecondary,
                      ),
                      statWidget(
                        '${_mentorMenteeRatio.toStringAsFixed(1)}',
                        '# of mentees per mentor',
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
                        'XX',
                        'total available slots',
                        kMentorXPAccentDark,
                      ),
                      VerticalDivider(
                        color: kMentorXPAccentDark,
                        thickness: 2,
                      ),
                      statWidget(
                        'XX',
                        'unmatched mentees',
                        kMentorXPAccentDark,
                      ),
                      statWidget(
                        'XX',
                        'available slots per mentee',
                        kMentorXPAccentDark,
                      ),
                      statWidget(
                        'XX',
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
