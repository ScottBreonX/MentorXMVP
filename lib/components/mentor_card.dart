import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/screens/mentoring/mentor_confirmation.dart';
import 'package:mentorx_mvp/screens/profile/profile_screen.dart';

import '../models/user.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');

class MentorCard extends StatefulWidget {
  final myUser loggedInUser;
  final String mentorUID;
  final String mentorFname;
  final String mentorLname;
  final Container imageContainer;
  final String mtrAtt1;
  final String mtrAtt2;
  final String mtrAtt3;
  final String xFactor;
  final String mtrClass;
  final bool profileOnly;
  final String programUID;
  final Container moreInfoExpand;
  final Divider dividerExpand;
  final bool previewStatus;
  final bool menteePreview;
  final int mentorSlots;

  MentorCard({
    this.loggedInUser,
    this.mentorUID,
    this.mentorFname,
    this.mentorLname,
    this.imageContainer,
    this.mtrAtt1,
    this.mtrAtt2,
    this.mtrAtt3,
    this.mtrClass,
    this.xFactor,
    this.profileOnly,
    this.programUID,
    this.moreInfoExpand,
    this.dividerExpand,
    this.previewStatus = false,
    this.menteePreview = false,
    this.mentorSlots,
  });

  @override
  State<MentorCard> createState() => _MentorCardState();
}

class _MentorCardState extends State<MentorCard> {
  bool expandStatus = false;

  Map<String, IconData> skillMap = {
    'Career Exploration': Icons.business,
    'Communication': Icons.emoji_people,
    'Internships': Icons.work,
    'Interview Prep': Icons.people_alt_outlined,
    'Major Exploration': Icons.school,
    'Resumes': Icons.note,
    'Skill Development': Icons.leaderboard,
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.94,
        child: Card(
          color: expandStatus ? kMentorXPPrimary : Colors.grey.shade300,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 10,
          child: Column(
            children: [
              Row(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10.0,
                    top: 0,
                    right: 10,
                  ),
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Profile(
                          profileId: widget.mentorUID,
                          loggedInUser: widget.loggedInUser,
                        ),
                      ),
                    ),
                    child: CircleAvatar(
                      backgroundColor: Theme.of(context).cardColor,
                      radius: 42,
                      child: widget.imageContainer ?? Container(),
                    ),
                  ),
                ),
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            '${widget.mentorFname} ${widget.mentorLname}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                .copyWith(
                                  color: expandStatus
                                      ? Colors.white
                                      : Colors.black54,
                                ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0, left: 2),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Row(
                            children: [
                              Text(
                                'Class: ',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    .copyWith(
                                      color: expandStatus
                                          ? Colors.white
                                          : Colors.black54,
                                    ),
                              ),
                              Text(
                                '${widget.mtrClass}',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    .copyWith(color: kMentorXPSecondary),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 5.0,
                                    right: 15.0,
                                    left: 5.0,
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(
                                        skillMap['${widget.mtrAtt1}'],
                                        color: expandStatus
                                            ? Colors.white
                                            : kMentorXPSecondary,
                                        size: 30,
                                      ),
                                      Text(
                                        '${widget.mtrAtt1 ?? ''}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            .copyWith(
                                              fontSize: 8,
                                              color: expandStatus
                                                  ? Colors.white
                                                  : Colors.black54,
                                            ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 5.0,
                                    right: 15.0,
                                    left: 15.0,
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(
                                        skillMap['${widget.mtrAtt2}'],
                                        color: expandStatus
                                            ? Colors.white
                                            : kMentorXPSecondary,
                                        size: 30,
                                      ),
                                      Text(
                                        '${widget.mtrAtt2 ?? ''}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            .copyWith(
                                              fontSize: 8,
                                              color: expandStatus
                                                  ? Colors.white
                                                  : Colors.black54,
                                            ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 5.0,
                                    right: 10.0,
                                    left: 15.0,
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(
                                        skillMap['${widget.mtrAtt3}'],
                                        color: expandStatus
                                            ? Colors.white
                                            : kMentorXPSecondary,
                                        size: 30,
                                      ),
                                      Text(
                                        '${widget.mtrAtt3 ?? ''}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            .copyWith(
                                              fontSize: 8,
                                              color: expandStatus
                                                  ? Colors.white
                                                  : Colors.black54,
                                            ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ]),
              ]),
              expandStatus
                  ? Column(
                      children: [
                        Divider(
                          indent: 10,
                          endIndent: 10,
                          color: Colors.grey.shade400,
                          thickness: 1,
                        ),
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10.0, top: 5),
                              child: Text(
                                widget.menteePreview
                                    ? "What I'm looking for in a mentor:"
                                    : "Experience I offer as a mentor:",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    .copyWith(
                                      color: Colors.white,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, top: 5.0, bottom: 10.0),
                              child: Container(
                                width: 330,
                                child: Text(
                                  '${widget.xFactor}',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 4,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      .copyWith(
                                        color: Colors.white,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          indent: 10,
                          endIndent: 10,
                          color: Colors.grey.shade400,
                          thickness: 1,
                        ),
                        buildSkillsSection(
                          widget.menteePreview
                              ? 'Skills I am looking to develop'
                              : 'My Mentoring Focus',
                          Colors.white,
                          skillMap['${widget.mtrAtt1}'],
                          skillMap['${widget.mtrAtt2}'],
                          skillMap['${widget.mtrAtt3}'],
                          widget.mtrAtt1 ?? '',
                          widget.mtrAtt2 ?? '',
                          widget.mtrAtt3 ?? '',
                        ),
                        widget.previewStatus
                            ? Container()
                            : Divider(
                                indent: 10,
                                endIndent: 10,
                                color: Colors.grey.shade400,
                                thickness: 1,
                              ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            widget.previewStatus
                                ? Container()
                                : RoundedButton(
                                    title: 'View Profile',
                                    borderRadius: 20,
                                    minWidth: 150,
                                    fontSize: 15,
                                    buttonColor: kMentorXPSecondary,
                                    fontColor: Colors.white,
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Profile(
                                          profileId: widget.mentorUID,
                                          loggedInUser: widget.loggedInUser,
                                        ),
                                      ),
                                    ),
                                  ),
                            widget.previewStatus
                                ? Container()
                                : RoundedButton(
                                    title: 'Select Mentor',
                                    buttonColor: kMentorXPAccentDark,
                                    borderRadius: 20,
                                    fontSize: 15,
                                    minWidth: 150,
                                    fontColor: Colors.white,
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MentorConfirm(
                                          loggedInUser: widget.loggedInUser,
                                          mentorUID: widget.mentorUID,
                                          mentorFname: widget.mentorFname,
                                          mentorLname: widget.mentorLname,
                                          mtrAtt1: widget.mtrAtt1,
                                          mtrAtt2: widget.mtrAtt2,
                                          mtrAtt3: widget.mtrAtt3,
                                          xFactor: widget.xFactor,
                                          mtrClass: widget.mtrClass,
                                          mentorSlots: widget.mentorSlots,
                                          mentorPicContainer:
                                              widget.imageContainer,
                                          programUID: widget.programUID,
                                        ),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                        Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10.0, bottom: 5),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 5.0),
                                          child: Icon(
                                            Icons.remove_circle,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          'Minimize Info',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall
                                              .copyWith(
                                                color: Colors.white,
                                              ),
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      setState(() {
                                        expandStatus = false;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0, bottom: 5),
                          child: widget.dividerExpand ??
                              Divider(
                                indent: 10,
                                endIndent: 10,
                                color: Colors.grey.shade300,
                                thickness: 1,
                              ),
                        ),
                        widget.moreInfoExpand ??
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 5.0),
                                          child: Icon(
                                            Icons.add_circle,
                                            color: Theme.of(context)
                                                .textTheme
                                                .headlineSmall
                                                .color,
                                          ),
                                        ),
                                        Text(
                                          'More Info',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall,
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      setState(() {
                                        expandStatus = true;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Column buildSkillsSection(
    String titleText,
    Color iconColor,
    IconData iconOne,
    IconData iconTwo,
    IconData iconThree,
    skillOneText,
    skillTwoText,
    skillThreeText,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 5),
              child: Text(
                titleText,
                style: Theme.of(context).textTheme.headlineSmall.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Container(
                width: 110,
                child: Column(
                  children: [
                    Icon(
                      iconOne,
                      color: iconColor,
                      size: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        skillOneText,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            .copyWith(fontSize: 10, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Container(
                width: 110,
                child: Column(
                  children: [
                    Icon(
                      iconTwo,
                      color: iconColor,
                      size: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        skillTwoText,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            .copyWith(fontSize: 10, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Container(
                width: 110,
                child: Column(
                  children: [
                    Icon(
                      iconThree,
                      color: iconColor,
                      size: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        skillThreeText,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            .copyWith(fontSize: 10, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
