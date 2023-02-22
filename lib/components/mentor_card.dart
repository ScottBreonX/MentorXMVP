import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/screens/mentoring/mentor_confirmation.dart';
import 'package:mentorx_mvp/screens/profile/profile_screen.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');

class MentorCard extends StatefulWidget {
  final String mentorUID;
  final int mentorSlots;
  final String mentorFname;
  final String mentorLname;
  final Container imageContainer;
  final String mtrAtt1;
  final String mtrAtt2;
  final String mtrAtt3;
  final String xFactor;
  final String mtrHobby1;
  final String mtrHobby2;
  final String mtrHobby3;
  final bool profileOnly;
  final String programUID;
  final Container moreInfoExpand;
  final Divider dividerExpand;
  final bool previewStatus;

  MentorCard({
    this.mentorUID,
    this.mentorSlots,
    this.mentorFname,
    this.mentorLname,
    this.imageContainer,
    this.mtrAtt1,
    this.mtrAtt2,
    this.mtrAtt3,
    this.xFactor,
    this.profileOnly,
    this.programUID,
    this.moreInfoExpand,
    this.dividerExpand,
    this.previewStatus = false,
    this.mtrHobby1,
    this.mtrHobby2,
    this.mtrHobby3,
  });

  @override
  State<MentorCard> createState() => _MentorCardState();
}

class _MentorCardState extends State<MentorCard> {
  bool expandStatus = false;

  Map<String, IconData> skillMap = {
    'Coding': Icons.code,
    'Analytics': Icons.numbers,
    'Presenting': Icons.co_present,
    'Communication': Icons.podcasts_rounded,
    'Finance': Icons.monetization_on,
    'Networking': Icons.people,
    'Managing up': Icons.swipe_up_alt_rounded,
    'Crafts': Icons.format_paint,
    'Drawing': Icons.draw,
    'Painting': Icons.picture_as_pdf,
    'Robotics': Icons.military_tech,
    'Sports': Icons.sports,
    'Travel': Icons.travel_explore,
    'Video Games': Icons.gamepad,
    'Volunteering': Icons.help,
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.94,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 10,
          child: Column(
            children: [
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10.0,
                        top: 10,
                        right: 10,
                      ),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Profile(profileId: widget.mentorUID),
                          ),
                        ),
                        child: CircleAvatar(
                          backgroundColor: Colors.grey,
                          radius: 42,
                          child: widget.imageContainer ?? Container(),
                        ),
                      ),
                    ),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 35.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.60,
                              child: Text(
                                '${widget.mentorFname} ${widget.mentorLname}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  fontFamily: 'WorkSans',
                                  fontSize: 25,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              widget.mentorSlots == null
                                  ? Container()
                                  : Text(
                                      'Available Slots: ',
                                      style: TextStyle(
                                        fontFamily: 'WorkSans',
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black54,
                                      ),
                                    ),
                              widget.mentorSlots == null
                                  ? Container()
                                  : Text(
                                      '${widget.mentorSlots}',
                                      style: TextStyle(
                                        fontFamily: 'WorkSans',
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: kMentorXPAccentDark,
                                      ),
                                    ),
                            ],
                          ),
                        ]),
                  ]),
              expandStatus
                  ? Column(
                      children: [
                        Divider(
                          indent: 10,
                          endIndent: 10,
                          color: Colors.grey.shade300,
                          thickness: 1,
                        ),
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10.0, top: 5),
                              child: Text(
                                "Why I'd be a great mentor:",
                                style: TextStyle(
                                  fontFamily: 'WorkSans',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
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
                                  maxLines: 3,
                                  style: TextStyle(
                                    fontFamily: 'WorkSans',
                                    fontSize: 15,
                                    color: Colors.black45,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          indent: 10,
                          endIndent: 10,
                          color: Colors.grey.shade300,
                          thickness: 1,
                        ),
                        buildSkillsSection(
                          'My Mentoring Focus',
                          kMentorXPAccentDark,
                          skillMap['${widget.mtrAtt1}'],
                          skillMap['${widget.mtrAtt2}'],
                          skillMap['${widget.mtrAtt3}'],
                          widget.mtrAtt1 ?? '',
                          widget.mtrAtt2 ?? '',
                          widget.mtrAtt3 ?? '',
                        ),
                        Divider(
                          indent: 10,
                          endIndent: 10,
                          color: Colors.grey.shade300,
                          thickness: 1,
                        ),
                        buildSkillsSection(
                          'My Hobbies',
                          kMentorXPAccentDark,
                          skillMap['${widget.mtrHobby1}'],
                          skillMap['${widget.mtrHobby2}'],
                          skillMap['${widget.mtrHobby3}'],
                          widget.mtrHobby1 ?? '',
                          widget.mtrHobby2 ?? '',
                          widget.mtrHobby3 ?? '',
                        ),
                        widget.previewStatus
                            ? Container()
                            : Divider(
                                indent: 10,
                                endIndent: 10,
                                color: Colors.grey.shade300,
                                thickness: 1,
                              ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            widget.previewStatus
                                ? Container()
                                : RoundedButton(
                                    title: 'Select Mentor',
                                    buttonColor: kMentorXPAccentDark,
                                    borderRadius: 15,
                                    minWidth: 150,
                                    fontColor: Colors.white,
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MentorConfirm(
                                          mentorUID: widget.mentorUID,
                                          mentorFname: widget.mentorFname,
                                          mentorLname: widget.mentorLname,
                                          mtrAtt1: widget.mtrAtt1,
                                          mtrAtt2: widget.mtrAtt2,
                                          mtrAtt3: widget.mtrAtt3,
                                          xFactor: widget.xFactor,
                                          mentorPicContainer:
                                              widget.imageContainer,
                                          mentorSlots: widget.mentorSlots,
                                          programUID: widget.programUID,
                                        ),
                                      ),
                                    ),
                                  ),
                            widget.previewStatus
                                ? Container()
                                : RoundedButton(
                                    title: 'View Profile',
                                    borderRadius: 15,
                                    minWidth: 150,
                                    buttonColor: Colors.grey,
                                    fontColor: Colors.white,
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Profile(
                                            profileId: widget.mentorUID),
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
                              child: Divider(
                                indent: 10,
                                endIndent: 10,
                                color: Colors.grey.shade300,
                                thickness: 1,
                              ),
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
                                            color: Colors.black45,
                                          ),
                                        ),
                                        Text(
                                          'Minimize Info',
                                          style: TextStyle(
                                            fontFamily: 'WorkSans',
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black45,
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
                          padding: const EdgeInsets.only(top: 10.0, bottom: 5),
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
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Text(
                                          'More Info',
                                          style: TextStyle(
                                            fontFamily: 'WorkSans',
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey,
                                          ),
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
                style: TextStyle(
                  fontFamily: 'WorkSans',
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
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
                        style: TextStyle(
                          fontFamily: 'WorkSans',
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
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
                        style: TextStyle(
                          fontFamily: 'WorkSans',
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
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
                        style: TextStyle(
                          fontFamily: 'WorkSans',
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
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
