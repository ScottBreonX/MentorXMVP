import 'package:flutter/foundation.dart';
import 'package:mentorx_mvp/models/user.dart';

class ProfileModel {
  ProfileModel({
    this.fName = '',
    this.lName = '',
    this.email = '',
    this.major = '',
    this.submitted = false,
    this.showSpinner = false,
  });
  final String fName;
  final String lName;
  final String major;
  final String email;
  final bool submitted;
  final bool showSpinner;

  factory ProfileModel.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String fName = data['First Name'];
    final String lName = data['Last Name'];
    final String major = data['Major'];
    final String email = data['Email Address'];
    return ProfileModel(fName: fName, lName: lName, email: email, major: major);
  }

  Map<String, dynamic> toMap() {
    return {
      'First Name': fName,
      'Last Name': lName,
      'Major': major,
      'Email Address': email,
    };
  }

  ProfileModel copyWith({
    String email,
    String fName,
    String lName,
    String major,
    bool submitted,
    bool showSpinner,
  }) {
    return ProfileModel(
      email: email ?? this.email,
      fName: fName ?? this.fName,
      lName: lName ?? this.lName,
      major: major ?? this.major,
      submitted: submitted ?? this.submitted,
      showSpinner: showSpinner ?? this.showSpinner,
    );
  }
}
