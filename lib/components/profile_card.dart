import 'package:flutter/material.dart';

import '../constants.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    Key key,
    @required this.profilePhotoStatus,
    @required this.profileData,
  }) : super(key: key);

  final bool profilePhotoStatus;
  final profileData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: kMentorXPrimary,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              blurRadius: 2,
              offset: Offset(2, 3),
              color: kMentorXBlack,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 2,
                                  offset: Offset(2, 3),
                                  color: kMentorXBlack,
                                ),
                              ],
                              borderRadius: BorderRadius.circular(60),
                            ),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 40,
                              backgroundImage: profilePhotoStatus
                                  ? NetworkImage(profileData['images'])
                                  : null,
                              child: profilePhotoStatus
                                  ? null
                                  : Icon(
                                      Icons.person,
                                      color: Colors.black54,
                                      size: 40,
                                    ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              height: 25.0,
                              width: 25.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.pink,
                              ),
                              child: GestureDetector(
                                onTap: () {},
                                child: Icon(
                                  Icons.photo_camera,
                                  color: Colors.white,
                                  size: 15.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${profileData['First Name']}',
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            '${profileData['Last Name']}',
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Row(
                          children: [
                            Center(
                              child: Text(
                                '${profileData['Year in School']}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 5.0, right: 5.0),
                              child: Container(
                                color: Colors.pink,
                                height: 20,
                                width: 2,
                              ),
                            ),
                            Center(
                              child: Text(
                                '${profileData['Major']}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 5.0, right: 5.0),
                              child: Container(
                                color: Colors.pink,
                                height: 20,
                                width: 2,
                              ),
                            ),
                            Center(
                              child: Text(
                                '${profileData['Minor'] ?? '<blank>'}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
