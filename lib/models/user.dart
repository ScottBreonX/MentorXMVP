import 'package:cloud_firestore/cloud_firestore.dart';

class myUser {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String major;
  final String yearInSchool;
  final String aboutMe;
  final String workExperience;
  final String mentorAbout;
  final String menteeAbout;
  final String profilePicture;
  final String coverPhoto;

  myUser({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.major,
    this.yearInSchool,
    this.aboutMe,
    this.workExperience,
    this.mentorAbout,
    this.menteeAbout,
    this.profilePicture,
    this.coverPhoto,
  });

  factory myUser.fromDocument(DocumentSnapshot doc) {
    return myUser(
      id: doc['id'],
      email: doc['Email Address'],
      firstName: doc['First Name'],
      lastName: doc['Last Name'],
      major: doc['Major'],
      yearInSchool: doc['Year in School'],
      aboutMe: doc['About Me'],
      workExperience: doc['Work Experience'],
      mentorAbout: doc['Mentoring About'],
      menteeAbout: doc['Mentee About'],
      profilePicture: doc['Profile Picture'],
      coverPhoto: doc['Cover Photo'],
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
      'About Me': aboutMe,
      'Work Experience': workExperience,
      'Mentoring About': mentorAbout,
      'Mentee About': menteeAbout,
      'Profile Picture': profilePicture,
      'Cover Photo': coverPhoto,
    };
  }
}
