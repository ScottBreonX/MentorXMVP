import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mentorx_mvp/services/database.dart';

User loggedInUser;

class ViewProfile extends StatefulWidget {
  const ViewProfile({
    Key key,
    this.database,
    this.uid,
    this.viewProfileUID,
  }) : super(key: key);

  static const String id = 'view_profile_screen';
  final Database database;
  final String uid;
  final String viewProfileUID;

  @override
  _ViewProfileState createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    getCurrentUser();
    getProfileData();
    print('${widget.viewProfileUID}');
    super.initState();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  dynamic profileData;

  Future<dynamic> getProfileData() async {
    await FirebaseFirestore.instance
        .collection('users/${widget.viewProfileUID}/profile')
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        setState(() {
          profileData = result.data();
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    bool profilePhotoStatus;

    if (profileData == null) {
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: kMentorXPrimary,
        ),
      );
    }

    if (profileData['images'] == null) {
      setState(() {
        profilePhotoStatus = false;
      });
    } else {
      setState(() {
        profilePhotoStatus = true;
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMentorXPrimary,
        title: Text('Mentoring'),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              height: 300,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.blueGrey.shade800,
                    Colors.blueGrey.shade900,
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
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
                                    color: kMentorXPrimary,
                                    size: 50,
                                  ),
                          ),
                        ),
                      ],
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
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 120,
                          child: Center(
                            child: Text(
                              '${profileData['Year in School']}',
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          height: 50,
                          width: 2,
                        ),
                        SizedBox(
                          width: 120,
                          child: Center(
                            child: Text(
                              '${profileData['Major']}',
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          height: 50,
                          width: 2,
                        ),
                        SizedBox(
                          width: 120,
                          child: Center(
                            child: Text(
                              '${profileData['Major']}',
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                child: Container(
                  child: SizedBox(
                    height: double.infinity,
                    child: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'About Me',
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, right: 10.0),
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  '${profileData['About Me']}',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: Row(
                            children: [
                              Text(
                                'Top Skills',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 5,
                                      offset: Offset(2, 3),
                                      color: Colors.grey,
                                      spreadRadius: 1,
                                    )
                                  ],
                                ),
                                child: CircleAvatar(
                                  backgroundColor: Colors.blueGrey.shade600,
                                  radius: 50,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 45,
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.blueGrey.shade600,
                                      size: 50,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 5,
                                      offset: Offset(2, 3),
                                      color: Colors.grey,
                                      spreadRadius: 1,
                                    )
                                  ],
                                ),
                                child: CircleAvatar(
                                  backgroundColor: Colors.blueGrey.shade600,
                                  radius: 50,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 45,
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.blueGrey.shade600,
                                      size: 50,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 5,
                                      offset: Offset(2, 3),
                                      color: Colors.grey,
                                      spreadRadius: 1,
                                    )
                                  ],
                                ),
                                child: CircleAvatar(
                                  backgroundColor: Colors.blueGrey.shade600,
                                  radius: 50,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 45,
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.blueGrey.shade600,
                                      size: 50,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Row(
                            children: [
                              Text(
                                'Hobbies / Activities',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 5,
                                      offset: Offset(2, 3),
                                      color: Colors.grey,
                                      spreadRadius: 1,
                                    )
                                  ],
                                ),
                                child: CircleAvatar(
                                  backgroundColor: Colors.blueGrey.shade600,
                                  radius: 50,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 45,
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.blueGrey.shade600,
                                      size: 50,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 5,
                                      offset: Offset(2, 3),
                                      color: Colors.grey,
                                      spreadRadius: 1,
                                    )
                                  ],
                                ),
                                child: CircleAvatar(
                                  backgroundColor: Colors.blueGrey.shade600,
                                  radius: 50,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 45,
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.blueGrey.shade600,
                                      size: 50,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 5,
                                      offset: Offset(2, 3),
                                      color: Colors.grey,
                                      spreadRadius: 1,
                                    )
                                  ],
                                ),
                                child: CircleAvatar(
                                  backgroundColor: Colors.blueGrey.shade600,
                                  radius: 50,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 45,
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.blueGrey.shade600,
                                      size: 50,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Row(
                            children: [
                              Text(
                                'Motivations',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black54,
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 5,
                                      offset: Offset(2, 3),
                                      color: Colors.grey,
                                      spreadRadius: 1,
                                    )
                                  ],
                                ),
                                child: CircleAvatar(
                                  backgroundColor: Colors.blueGrey.shade600,
                                  radius: 50,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 45,
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.blueGrey.shade600,
                                      size: 50,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 5,
                                      offset: Offset(2, 3),
                                      color: Colors.grey,
                                      spreadRadius: 1,
                                    )
                                  ],
                                ),
                                child: CircleAvatar(
                                  backgroundColor: Colors.blueGrey.shade600,
                                  radius: 50,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 45,
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.blueGrey.shade600,
                                      size: 50,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 5,
                                      offset: Offset(2, 3),
                                      color: Colors.grey,
                                      spreadRadius: 1,
                                    )
                                  ],
                                ),
                                child: CircleAvatar(
                                  backgroundColor: Colors.blueGrey.shade600,
                                  radius: 50,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 45,
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.blueGrey.shade600,
                                      size: 50,
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
              ),
            )
          ],
        ),
      ),
    );
  }
}
