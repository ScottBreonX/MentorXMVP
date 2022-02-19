import 'package:flutter/material.dart';
import 'package:mentorx_mvp/screens/mentoring/mentor_confirmation.dart';
import 'package:mentorx_mvp/screens/profile/profile_screen.dart';

class MentorCard extends StatelessWidget {
  final String mentorUID;
  final int mentorSlots;
  final String mentorFname;
  final String mentorLname;
  final String mentorEmail;
  final String mentorImgUrl;
  final String mentorMajor;
  final String mentorYearInSchool;
  final bool profileOnly;

  MentorCard({
    this.mentorUID,
    this.mentorSlots,
    this.mentorFname,
    this.mentorLname,
    this.mentorEmail,
    this.mentorImgUrl,
    this.mentorMajor,
    this.mentorYearInSchool,
    this.profileOnly,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
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
                      padding: const EdgeInsets.all(15.0),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.28,
                          maxHeight: MediaQuery.of(context).size.width * 0.28,
                        ),
                        child: Image.asset(
                            mentorImgUrl != null
                                ? mentorImgUrl
                                : 'assets/images/UMichLogo.png',
                            fit: BoxFit.fitHeight),
                      ),
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                              child: Text(
                                '$mentorFname $mentorLname',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                              child: Text(
                                'Available Slots: $mentorSlots',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(15, 10, 0, 5),
                              child: Text(
                                '$mentorMajor - $mentorYearInSchool',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ]),
                  ]),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FloatingActionButton.extended(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Profile(profileId: mentorUID),
                            ),
                          ),
                          heroTag: null,
                          backgroundColor: Colors.blue,
                          label: Text(
                            'View Profile',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 25),
                        profileOnly
                            ? SizedBox(
                                height: 5,
                              )
                            : FloatingActionButton.extended(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MentorConfirm(
                                      mentorFname: mentorFname,
                                      mentorLname: mentorLname,
                                      mentorUID: mentorUID,
                                      mentorSlots: mentorSlots,
                                    ),
                                  ),
                                ),
                                heroTag: null,
                                label: Text(
                                  'Select Mentor',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
