import 'package:cloud_firestore/cloud_firestore.dart';

class Mentee {
  final String id;
  final String menteeSkill1;
  final String menteeSkill2;
  final String menteeSkill3;
  final String menteeBackground;
  final String menteeExperience;
  final String menteeYearInSchool;
  final String fName;
  final String lName;
  final String profilePicture;

  Mentee({
    this.fName,
    this.lName,
    this.profilePicture,
    this.menteeYearInSchool,
    this.menteeBackground,
    this.menteeExperience,
    this.id,
    this.menteeSkill1,
    this.menteeSkill2,
    this.menteeSkill3,
  });

  factory Mentee.fromDocument(DocumentSnapshot doc) {
    return Mentee(
      id: doc.data().toString().contains('id') ? doc['id'] : '',
      menteeSkill1: doc.data().toString().contains('Mentee Skill 1')
          ? doc['Mentee Skill 1']
          : null,
      menteeSkill2: doc.data().toString().contains('Mentee Skill 2')
          ? doc['Mentee Skill 2']
          : null,
      menteeSkill3: doc.data().toString().contains('Mentee Skill 3')
          ? doc['Mentee Skill 3']
          : null,
      menteeBackground: doc.data().toString().contains('Mentee Background')
          ? doc['Mentee Background']
          : '',
      menteeExperience: doc.data().toString().contains('Mentee Experience')
          ? doc['Mentee Experience']
          : '',
      menteeYearInSchool: doc.data().toString().contains('Year in School')
          ? doc['Year in School']
          : null,
      fName:
          doc.data().toString().contains('First Name') ? doc['First Name'] : '',
      lName:
          doc.data().toString().contains('Last Name') ? doc['Last Name'] : '',
      profilePicture: doc.data().toString().contains('Profile Picture')
          ? doc['Profile Picture']
          : '',
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'Mentee Skill 1': menteeSkill1,
      'Mentee Skill 2': menteeSkill2,
      'Mentee Skill 3': menteeSkill3,
      'Mentee Background': menteeBackground,
      'Mentee Experience': menteeExperience,
      'Year in School': menteeYearInSchool,
      'First Name': fName,
      'Last Name': lName,
      'Profile Picture': profilePicture,
    };
  }
}
