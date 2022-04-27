import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:mentorx_mvp/screens/mentoring/mentor_confirmation.dart';
import 'package:mentorx_mvp/screens/profile/profile_screen.dart';
import 'package:mentorx_mvp/screens/programs/program_launch/program_launch_screen.dart';
import '../screens/authentication/landing_page.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');

class MentorCard extends StatefulWidget {
  final String mentorUID;
  final int mentorSlots;
  final String mentorFname;
  final String mentorLname;
  final Container imageContainer;
  final String mentorMajor;
  final String mentorYearInSchool;
  final String mtrAtt1;
  final String mtrAtt2;
  final String mtrAtt3;
  final String xFactor;
  final bool profileOnly;
  final String programUID;
  final Container moreInfoExpand;
  final Divider dividerExpand;

  MentorCard(
      {this.mentorUID,
      this.mentorSlots,
      this.mentorFname,
      this.mentorLname,
      this.imageContainer,
      this.mentorMajor,
      this.mentorYearInSchool,
      this.mtrAtt1,
      this.mtrAtt2,
      this.mtrAtt3,
      this.xFactor,
      this.profileOnly,
      this.programUID,
      this.moreInfoExpand,
      this.dividerExpand});

  @override
  State<MentorCard> createState() => _MentorCardState();
}

class _MentorCardState extends State<MentorCard> {
  bool expandStatus = false;

  _confirmRemoveMentor(parentContext, programUID) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Center(
              child: Text(
                'Confirm Removing Mentor',
                style: TextStyle(
                  fontFamily: 'Work Sans',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.pink,
                ),
              ),
            ),
            children: <Widget>[
              SimpleDialogOption(
                padding: EdgeInsets.only(left: 10, right: 10, bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 250,
                      child: Column(
                        children: [
                          Text(
                            'Are you sure you want to remove this mentor?',
                            style: TextStyle(
                              fontFamily: 'WorkSans',
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black45,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SimpleDialogOption(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: RoundedButton(
                      title: 'Yes',
                      buttonColor: Colors.pink,
                      fontColor: Colors.white,
                      minWidth: 120,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      onPressed: () =>
                          _removeMentor(widget.mentorUID, widget.programUID),
                    ),
                  ),
                  SimpleDialogOption(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: RoundedButton(
                      title: 'Cancel',
                      buttonColor: Colors.pink,
                      fontColor: Colors.white,
                      minWidth: 120,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 10.0, right: 10.0, top: 0.0),
                child: Text(
                  'You will lose all related mentoring information',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'WorkSans',
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          );
        });
  }

  _removeMentor(programUID, matchUID) {
    programsRef
        .doc(programUID)
        .collection('userSubscribed')
        .doc(loggedInUser.id)
        .collection('matchedMentors')
        .doc(matchUID)
        .delete();
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProgramLaunchScreen(
          programUID: programUID,
        ),
      ),
    );
  }

  mentorAttributeIconOne() {
    String mentoringAttribute = widget.mtrAtt1;
    Icon attributeIcon;

    (mentoringAttribute == "finance")
        ? attributeIcon = Icon(
            Icons.monetization_on,
            size: 50,
            color: Colors.green.shade300,
          )
        : (mentoringAttribute == "coding")
            ? attributeIcon = Icon(
                FontAwesomeIcons.code,
                size: 50,
                color: Colors.red.shade300,
              )
            : (mentoringAttribute == "analytics")
                ? attributeIcon = Icon(
                    Icons.numbers,
                    size: 50,
                    color: Colors.purple.shade300,
                  )
                : (mentoringAttribute == "presenting")
                    ? attributeIcon = Icon(
                        FontAwesomeIcons.chalkboardTeacher,
                        size: 50,
                        color: Colors.blue.shade300,
                      )
                    : (mentoringAttribute == "communication")
                        ? attributeIcon = Icon(
                            Icons.podcasts_rounded,
                            size: 50,
                            color: Colors.deepOrange.shade300,
                          )
                        : (mentoringAttribute == "networking")
                            ? attributeIcon = Icon(
                                Icons.people,
                                size: 50,
                                color: Colors.teal.shade300,
                              )
                            : attributeIcon = Icon(
                                Icons.swipe_up_alt_rounded,
                                size: 50,
                                color: Colors.pink.shade300,
                              );
    return attributeIcon;
  }

  mentorAttributeIconTwo() {
    String mentoringAttribute = widget.mtrAtt2;
    Icon attributeIcon;

    (mentoringAttribute == "finance")
        ? attributeIcon = Icon(
            Icons.monetization_on,
            size: 50,
            color: Colors.green.shade300,
          )
        : (mentoringAttribute == "coding")
            ? attributeIcon = Icon(
                FontAwesomeIcons.code,
                size: 50,
                color: Colors.red.shade300,
              )
            : (mentoringAttribute == "analytics")
                ? attributeIcon = Icon(
                    Icons.numbers,
                    size: 50,
                    color: Colors.purple.shade300,
                  )
                : (mentoringAttribute == "presenting")
                    ? attributeIcon = Icon(
                        FontAwesomeIcons.chalkboardTeacher,
                        size: 50,
                        color: Colors.blue.shade300,
                      )
                    : (mentoringAttribute == "communication")
                        ? attributeIcon = Icon(
                            Icons.podcasts_rounded,
                            size: 50,
                            color: Colors.deepOrange.shade300,
                          )
                        : (mentoringAttribute == "networking")
                            ? attributeIcon = Icon(
                                Icons.people,
                                size: 50,
                                color: Colors.teal.shade300,
                              )
                            : attributeIcon = Icon(
                                Icons.swipe_up_alt_rounded,
                                size: 50,
                                color: Colors.pink.shade300,
                              );
    return attributeIcon;
  }

  mentorAttributeIconThree() {
    String mentoringAttribute = widget.mtrAtt3;
    Icon attributeIcon;

    (mentoringAttribute == "finance")
        ? attributeIcon = Icon(
            Icons.monetization_on,
            size: 50,
            color: Colors.green.shade300,
          )
        : (mentoringAttribute == "coding")
            ? attributeIcon = Icon(
                FontAwesomeIcons.code,
                size: 50,
                color: Colors.red.shade300,
              )
            : (mentoringAttribute == "analytics")
                ? attributeIcon = Icon(
                    Icons.numbers,
                    size: 50,
                    color: Colors.purple.shade300,
                  )
                : (mentoringAttribute == "presenting")
                    ? attributeIcon = Icon(
                        FontAwesomeIcons.chalkboardTeacher,
                        size: 50,
                        color: Colors.blue.shade300,
                      )
                    : (mentoringAttribute == "communication")
                        ? attributeIcon = Icon(
                            Icons.podcasts_rounded,
                            size: 50,
                            color: Colors.deepOrange.shade300,
                          )
                        : (mentoringAttribute == "networking")
                            ? attributeIcon = Icon(
                                Icons.people,
                                size: 50,
                                color: Colors.teal.shade300,
                              )
                            : attributeIcon = Icon(
                                Icons.swipe_up_alt_rounded,
                                size: 50,
                                color: Colors.pink.shade300,
                              );
    return attributeIcon;
  }

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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.60,
                              child: Text(
                                '${widget.mentorFname} ${widget.mentorLname}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                  fontFamily: 'WorkSans',
                                  fontSize: 23,
                                  fontWeight: FontWeight.w600,
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
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black54,
                                      ),
                                    ),
                              widget.mentorSlots == null
                                  ? Container()
                                  : Text(
                                      '${widget.mentorSlots}',
                                      style: TextStyle(
                                        fontFamily: 'WorkSans',
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.blue,
                                      ),
                                    ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Row(
                              children: [
                                Text(
                                  'Year in School: ',
                                  style: TextStyle(
                                    fontFamily: 'WorkSans',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black54,
                                  ),
                                ),
                                Text(
                                  '${widget.mentorYearInSchool}',
                                  style: TextStyle(
                                    fontFamily: 'WorkSans',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                'Major: ',
                                style: TextStyle(
                                  fontFamily: 'WorkSans',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54,
                                ),
                              ),
                              Container(
                                width: 200,
                                child: Text(
                                  '${widget.mentorMajor}',
                                  style: TextStyle(
                                    fontFamily: 'WorkSans',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue,
                                  ),
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
                                "Top 3 Mentoring Skills",
                                style: TextStyle(
                                  fontFamily: 'WorkSans',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
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
                              padding: const EdgeInsets.only(
                                  top: 10.0, bottom: 10.0),
                              child: Container(
                                width: 110,
                                child: Column(
                                  children: [
                                    mentorAttributeIconOne(),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Text(
                                        '${widget.mtrAtt1}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'WorkSans',
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, bottom: 10.0),
                              child: Container(
                                width: 110,
                                child: Column(
                                  children: [
                                    mentorAttributeIconTwo(),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Text(
                                        '${widget.mtrAtt2}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'WorkSans',
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, bottom: 10.0),
                              child: Container(
                                width: 110,
                                child: Column(
                                  children: [
                                    mentorAttributeIconThree(),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Text(
                                        '${widget.mtrAtt3}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'WorkSans',
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
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
                                  fontWeight: FontWeight.bold,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            RoundedButton(
                              title: 'Select Mentor',
                              buttonColor: Colors.pink,
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
                                    mentorMajor: widget.mentorMajor,
                                    mentorYearInSchool:
                                        widget.mentorYearInSchool,
                                    mtrAtt1: widget.mtrAtt1,
                                    mtrAtt2: widget.mtrAtt2,
                                    mtrAtt3: widget.mtrAtt3,
                                    xFactor: widget.xFactor,
                                    mentorPicContainer: widget.imageContainer,
                                    mentorSlots: widget.mentorSlots,
                                    programUID: widget.programUID,
                                  ),
                                ),
                              ),
                            ),
                            RoundedButton(
                              title: 'View Profile',
                              borderRadius: 15,
                              minWidth: 150,
                              buttonColor: Colors.white,
                              fontColor: Colors.pink,
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Profile(profileId: widget.mentorUID),
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
                                            fontWeight: FontWeight.bold,
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
                                          child: Icon(Icons.add_circle),
                                        ),
                                        Text(
                                          'More Info',
                                          style: TextStyle(
                                            fontFamily: 'WorkSans',
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
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
}
