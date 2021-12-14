import 'package:cloud_firestore/cloud_firestore.dart';

class myUser {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String major;
  final String yearInSchool;
  final int mentorSlots;
  final String aboutMe;
  final String mentorAbout;
  final String menteeAbout;

  myUser({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.major,
    this.yearInSchool,
    this.mentorSlots,
    this.aboutMe,
    this.mentorAbout,
    this.menteeAbout,
  });

  factory myUser.fromDocument(DocumentSnapshot doc) {
    return myUser(
      id: doc['id'],
      email: doc['Email Address'],
      firstName: doc['First Name'],
      lastName: doc['Last Name'],
      major: doc['Major'],
      yearInSchool: doc['Year in School'],
      mentorSlots: doc['Mentor Slots'],
      aboutMe: doc['About Me'],
      mentorAbout: doc['Mentoring About'],
      menteeAbout: doc['Mentee About'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'Email Address': email,
      'First Name': firstName,
      'Last Name': lastName,
      'Major': major,
      'Year in School': yearInSchool,
      'Mentor Slots': mentorSlots,
      'About Me': aboutMe,
      'Mentoring About': mentorAbout,
      'Mentee About': menteeAbout,
    };
  }
}
