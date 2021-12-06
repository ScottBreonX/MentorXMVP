import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String email;
  final String firstName;
  final String lastName;

  User({
    this.uid,
    this.email,
    this.firstName,
    this.lastName,
  });

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
        uid: doc['UID'],
        email: doc['Email Address'],
        firstName: doc['First Name'],
        lastName: doc['Last Name']);
  }
}
