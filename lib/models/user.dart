import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String fname;
  final String lname;
  final String email;
  final String photoUrl;
  final String bio;

  User({
    this.id,
    this.fname,
    this.lname,
    this.email,
    this.photoUrl,
    this.bio,
  });

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      id: doc['id'],
      fname: doc['fname'],
      lname: doc['lname'],
      email: doc['email'],
      photoUrl: doc['photoUrl'],
      bio: doc['bio'],
    );
  }
}
