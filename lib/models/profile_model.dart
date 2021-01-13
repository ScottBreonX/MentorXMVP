import 'package:flutter/foundation.dart';

class Profile {
  Profile({this.fName, this.lName, this.email, this.major});
  final String fName;
  final String lName;
  final String major;
  final String email;

  factory Profile.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String fName = data['First Name'];
    final String lName = data['Last Name'];
    final String major = data['Major'];
    final String email = data['Email Address'];
    return Profile(fName: fName, lName: lName, email: email, major: major);
  }

  Map<String, dynamic> toMap() {
    return {
      'First Name': fName,
      'Last Name': lName,
      'Major': major,
      'Email Address': email,
    };
  }
}
