import 'package:cloud_firestore/cloud_firestore.dart';

class myUser {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String major;
  final String yearInSchool;
  final int mentorSlots;

  myUser(
      {this.id,
      this.email,
      this.firstName,
      this.lastName,
      this.major,
      this.yearInSchool,
      this.mentorSlots});

  factory myUser.fromDocument(DocumentSnapshot doc) {
    return myUser(
      id: doc['id'],
      email: doc['Email Address'],
      firstName: doc['First Name'],
      lastName: doc['Last Name'],
      major: doc['Major'],
      yearInSchool: doc['Year in School'],
      mentorSlots: doc['Mentor Slots'],
    );
  }
}
