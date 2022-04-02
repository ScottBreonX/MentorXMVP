import 'package:cloud_firestore/cloud_firestore.dart';

class Mentor {
  final String id;
  final String firstName;
  final String lastName;
  final String profilePic;
  final String major;
  final String yearInSchool;
  final int mentorSlots;
  final String mentorAbout;
  final String menteeAbout;
  final String mtrHobby1;
  final String mtrHobby2;
  final String mtrHobby3;
  final String mtrAtt1;
  final String mtrAtt2;
  final String mtrAtt3;
  final String xFactor;

  Mentor({
    this.id,
    this.firstName,
    this.lastName,
    this.profilePic,
    this.major,
    this.yearInSchool,
    this.mentorSlots,
    this.mentorAbout,
    this.menteeAbout,
    this.mtrHobby1,
    this.mtrHobby2,
    this.mtrHobby3,
    this.mtrAtt1,
    this.mtrAtt2,
    this.mtrAtt3,
    this.xFactor,
  });

  factory Mentor.fromDocument(DocumentSnapshot doc) {
    return Mentor(
      id: doc['id'],
      firstName: doc['First Name'],
      lastName: doc['Last Name'],
      profilePic: doc['Profile Picture'],
      major: doc['Major'],
      yearInSchool: doc['Year in School'],
      mentorSlots: doc['Mentor Slots'],
      mentorAbout: doc['Mentoring About'],
      menteeAbout: doc['Mentee About'],
      mtrHobby1: doc['Mtr Hobby 1'],
      mtrHobby2: doc['Mtr Hobby 2'],
      mtrHobby3: doc['Mtr Hobby 3'],
      mtrAtt1: doc['Mentor Attribute 1'],
      mtrAtt2: doc['Mentor Attribute 2'],
      mtrAtt3: doc['Mentor Attribute 3'],
      xFactor: doc['XFactor'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'First Name': firstName,
      'Last Name': lastName,
      'Profile Picture': profilePic,
      'Major': major,
      'Year in School': yearInSchool,
      'Mentor Slots': mentorSlots,
      'Mentoring About': mentorAbout,
      'Mentee About': menteeAbout,
      'Mtr Hobby 1': mtrHobby1,
      'Mtr Hobby 2': mtrHobby2,
      'Mtr Hobby 3': mtrHobby3,
      'Mentor Attribute 1': mtrAtt1,
      'Mentor Attribute 2': mtrAtt2,
      'Mentor Attribute 3': mtrAtt3,
      'XFactor': xFactor,
    };
  }
}
