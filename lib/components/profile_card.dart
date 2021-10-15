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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
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
                            radius: 50,
                            backgroundImage: profilePhotoStatus
                                ? NetworkImage(profileData['images'])
                                : null,
                            child: profilePhotoStatus
                                ? null
                                : Icon(
                                    Icons.person,
                                    color: Colors.black54,
                                    size: 70,
                                  ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            height: 35.0,
                            width: 35.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.pink,
                            ),
                            child: GestureDetector(
                              onTap: () {},
                              child: Icon(
                                Icons.photo_camera,
                                color: Colors.white,
                                size: 25.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${profileData['First Name']}',
                    style: TextStyle(
                      fontSize: 30.0,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    '${profileData['Last Name']}',
                    style: TextStyle(
                      fontSize: 30.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 120,
                          child: Center(
                            child: Text(
                              '${profileData['Year in School']}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      height: 25,
                      width: 2,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 120,
                          child: Center(
                            child: Text(
                              '${profileData['Major']}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      height: 25,
                      width: 2,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 120,
                          child: Center(
                            child: Text(
                              '${profileData['Minor'] ?? '<blank>'}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
