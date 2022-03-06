import 'package:flutter/material.dart';
import 'package:mentorx_mvp/screens/mentoring/mentor_confirmation.dart';
import 'package:mentorx_mvp/screens/profile/profile_screen.dart';

class MentorCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Profile(profileId: mentorUID),
        ),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.94,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 20, 20, 10),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.20,
                            maxHeight: MediaQuery.of(context).size.width * 0.20,
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
                              child: Text(
                                '$mentorFname $mentorLname'.toUpperCase(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                            Text(
                              'Available Slots: $mentorSlots',
                              style: TextStyle(
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '$mtrAtt1',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      '$mtrAtt2',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      '$mtrAtt3',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                profileOnly
                                    ? SizedBox(height: 5)
                                    : OutlinedButton(
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
                                        child: Text(
                                          'Select Mentor',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                          ),
                                        ),
                                        style: OutlinedButton.styleFrom(
                                          side: BorderSide(
                                              width: 2.0, color: Colors.grey),
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                      ),
                              ],
                            ),
                          ]),
                    ]),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 25,
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                      ),
                    ),
                    child: Text(
                      '$xFactor',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
