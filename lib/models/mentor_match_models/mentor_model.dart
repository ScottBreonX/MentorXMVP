import 'package:cloud_firestore/cloud_firestore.dart';

class Mentor {
  final String id;
  final int mentorSlots;
  final String mentorBackground;
  final String mentorExperience;
  final String mentorOtherInfo;
  final String mentorYearInSchool;
  final String mentorFreeForm;
  final String lName;
  final String fName;
  final String profilePicture;

  Mentor(
      {this.mentorBackground,
      this.mentorExperience,
      this.mentorOtherInfo,
      this.mentorYearInSchool,
      this.mentorFreeForm,
      this.id,
      this.mentorSlots,
      this.fName,
      this.lName,
      this.profilePicture});

  factory Mentor.fromDocument(DocumentSnapshot doc) {
    return Mentor(
      id: doc.data().toString().contains('id') ? doc['id'] : '',
      mentorSlots: doc.data().toString().contains('mentorSlots')
          ? doc['mentorSlots']
          : 2,
      mentorFreeForm: doc.data().toString().contains('Mentor Free Form')
          ? doc['Mentor Free Form']
          : '',
      mentorBackground: doc.data().toString().contains('Mentor Background')
          ? doc['Mentor Background']
          : '',
      mentorExperience: doc.data().toString().contains('Mentor Experience')
          ? doc['Mentor Experience']
          : '',
      mentorOtherInfo: doc.data().toString().contains('Mentor Other Info')
          ? doc['Mentor Other Info']
          : '',
      mentorYearInSchool:
          doc.data().toString().contains('Mentor Year in School')
              ? doc['Mentor Year in School']
              : '',
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
      'Mentor Slots': mentorSlots,
      'Mentor Background': mentorBackground,
      'Mentor Experience': mentorExperience,
      'Mentor Other Info': mentorOtherInfo,
      'Mentor Year in School': mentorYearInSchool,
      'Mentor Free Form': mentorFreeForm,
      'First Name': fName,
      'Last Name': lName,
      'Profile Picture': profilePicture,
    };
  }
}
