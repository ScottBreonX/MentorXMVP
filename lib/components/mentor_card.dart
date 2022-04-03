import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/profile_image_circle.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:mentorx_mvp/screens/mentoring/mentor_confirmation.dart';
import 'package:mentorx_mvp/screens/profile/profile_screen.dart';

class MentorCard extends StatefulWidget {
  final String mentorUID;
  final int mentorSlots;
  final String mentorFname;
  final String mentorLname;
  final String mentorImgUrl;
  final String mentorMajor;
  final String mentorYearInSchool;
  final String mtrAtt1;
  final String mtrAtt2;
  final String mtrAtt3;
  final String xFactor;
  final bool profileOnly;

  MentorCard({
    this.mentorUID,
    this.mentorSlots,
    this.mentorFname,
    this.mentorLname,
    this.mentorImgUrl,
    this.mentorMajor,
    this.mentorYearInSchool,
    this.mtrAtt1,
    this.mtrAtt2,
    this.mtrAtt3,
    this.xFactor,
    this.profileOnly,
  });

  @override
  State<MentorCard> createState() => _MentorCardState();
}

class _MentorCardState extends State<MentorCard> {
  bool expandStatus = false;

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
                          child: widget.mentorImgUrl != ""
                              ? CircleAvatar(
                                  radius: 40,
                                  child: CachedNetworkImage(
                                    imageUrl: widget.mentorImgUrl,
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) => Icon(
                                      Icons.person,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                  ),
                                )
                              : ProfileImageCircle(
                                  circleColor: Colors.blue,
                                  iconSize: 45,
                                  iconColor: Colors.white,
                                  circleSize: 40,
                                ),
                        ),
                      ),
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Text(
                                '${widget.mentorFname} ${widget.mentorLname}',
                                style: TextStyle(
                                  fontFamily: 'WorkSans',
                                  fontSize: 25,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                'Available Slots: ',
                                style: TextStyle(
                                  fontFamily: 'WorkSans',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54,
                                ),
                              ),
                              Text(
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
                            Container(
                              width: 110,
                              child: RoundedButton(
                                title: '${widget.mtrAtt1}',
                                buttonColor: Colors.grey.shade50,
                                fontSize: 10,
                                minWidth: 110,
                                borderRadius: 15,
                                fontColor: Colors.black54,
                                fontWeight: FontWeight.bold,
                                onPressed: () {},
                              ),
                            ),
                            Container(
                              width: 110,
                              child: RoundedButton(
                                title: '${widget.mtrAtt2}',
                                buttonColor: Colors.grey.shade50,
                                fontSize: 10,
                                minWidth: 110,
                                borderRadius: 15,
                                fontColor: Colors.black54,
                                fontWeight: FontWeight.bold,
                                onPressed: () {},
                              ),
                            ),
                            Container(
                              width: 110,
                              child: RoundedButton(
                                title: '${widget.mtrAtt3}',
                                buttonColor: Colors.grey.shade50,
                                fontSize: 10,
                                minWidth: 110,
                                borderRadius: 15,
                                fontColor: Colors.black54,
                                fontWeight: FontWeight.bold,
                                onPressed: () {},
                              ),
                            )
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
                                    mentorFname: widget.mentorFname,
                                    mentorLname: widget.mentorLname,
                                    mentorUID: widget.mentorUID,
                                    mentorSlots: widget.mentorSlots,
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
                                  mainAxisAlignment: MainAxisAlignment.center,
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
