import 'package:cloud_firestore/cloud_firestore.dart';

class myUser {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String aboutMe;
  final String workExperience;
  final String program;
  final String profilePicture;
  final String coverPhoto;
  final bool canCreateProgram;
  final bool welcomeMessage;

  myUser({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.aboutMe,
    this.workExperience,
    this.program,
    this.profilePicture,
    this.coverPhoto,
    this.canCreateProgram,
    this.welcomeMessage,
  });

  factory myUser.fromDocument(DocumentSnapshot doc) {
    return myUser(
      id: doc['id'],
      email: doc['Email Address'],
      firstName: doc['First Name'],
      lastName: doc['Last Name'],
      aboutMe: doc['About Me'],
      workExperience: doc['Work Experience'],
      program: doc['Program'],
      profilePicture: doc['Profile Picture'],
      coverPhoto: doc['Cover Photo'],
      canCreateProgram: doc['Can Create Program'],
      welcomeMessage: doc['Welcome Message'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'Email Address': email,
      'First Name': firstName,
      'Last Name': lastName,
      'About Me': aboutMe,
      'Work Experience': workExperience,
      'Program': program,
      'Profile Picture': profilePicture,
      'Cover Photo': coverPhoto,
      'Can Create Program': canCreateProgram,
      'Welcome Message': welcomeMessage,
    };
  }
}
