import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/founders_portal/founders_portal_users.dart';
import '../../../../constants.dart';
import '../../components/progress.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');

class FoundersPortalScreen extends StatefulWidget {
  final myUser loggedInUser;

  const FoundersPortalScreen({
    Key key,
    this.loggedInUser,
  }) : super(key: key);

  static const String id = 'founders_portal_screen';

  @override
  _FoundersPortalScreenState createState() => _FoundersPortalScreenState();
}

class _FoundersPortalScreenState extends State<FoundersPortalScreen> {
  @override
  void initState() {
    _userQuery();
    super.initState();
  }

  _userQuery() async {
    updatingData = true;

    var snapshot1 = await usersRef.get();
    var snapshot2 = await usersRef.where("Program", isNotEqualTo: "").get();
    var snapshot3 =
        await usersRef.where("Profile Picture", isNotEqualTo: "").get();
    updatingData = false;

    setState(() {
      _userCount = snapshot1.size;
      _numberEnrolled = snapshot2.size;
      _profilePicCount = snapshot3.size;
      _percentEnrolled =
          int.parse(((_numberEnrolled / _userCount) * 100).toStringAsFixed(0));
      _profilePicPercent =
          int.parse(((_profilePicCount / _userCount) * 100).toStringAsFixed(0));
    });
  }

  int _userCount;
  int _numberEnrolled;
  int _percentEnrolled;
  int _profilePicCount;
  int _profilePicPercent;
  double _statFontSize = 30;
  bool updatingData = false;

  @override
  Widget build(BuildContext context) {
    return updatingData
        ? circularProgress(Theme.of(context).primaryColor)
        : Scaffold(
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
                            Icons.admin_panel_settings,
                            color: kMentorXPAccentDark,
                            size: 50,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Founders Portal',
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
                      padding:
                          const EdgeInsets.only(top: 20, left: 10.0, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'User Stats',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 20,
                              color: kMentorXPPrimary,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {});
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
                      padding:
                          const EdgeInsets.only(left: 10.0, top: 20, right: 10),
                      child: IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        FoundersPortalUsersScreen(
                                      loggedInUser: widget.loggedInUser,
                                    ),
                                  ),
                                );
                              },
                              child: statWidget(
                                '$_userCount',
                                'total # of users',
                                kMentorXPPrimary,
                                _statFontSize,
                              ),
                            ),
                            VerticalDivider(
                              color: kMentorXPPrimary,
                              thickness: 2,
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: statWidget(
                                '$_percentEnrolled%',
                                '% enrolled',
                                kMentorXPPrimary,
                                _statFontSize,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: statWidget(
                                '$_profilePicPercent%',
                                '% with profile picture',
                                kMentorXPPrimary,
                                _statFontSize,
                              ),
                            ),
                            statWidget(
                              '',
                              '% with profile info',
                              kMentorXPPrimary,
                              _statFontSize,
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
                      padding:
                          const EdgeInsets.only(top: 20, left: 10.0, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Program Stats',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 20,
                                color: kMentorXPSecondary),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10.0, top: 20, right: 10),
                      child: IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            statWidget(
                              '',
                              '# of programs created',
                              kMentorXPSecondary,
                              _statFontSize,
                            ),
                            VerticalDivider(
                              color: kMentorXPSecondary,
                              thickness: 2,
                            ),
                            statWidget(
                              '',
                              'total enrolled',
                              kMentorXPSecondary,
                              _statFontSize,
                            ),
                            statWidget(
                              '',
                              '# of matches',
                              kMentorXPSecondary,
                              _statFontSize,
                            ),
                            statWidget(
                              "-",
                              'TBD',
                              kMentorXPSecondary,
                              _statFontSize,
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
    double numberFontSize,
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
              fontSize: numberFontSize ?? 40,
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
