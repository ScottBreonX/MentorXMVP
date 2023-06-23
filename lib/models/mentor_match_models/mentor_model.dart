import 'package:cloud_firestore/cloud_firestore.dart';

class Mentor {
  final String id;
  final String mentorBackground;
  final String mentorExperience;
  final String mentorOtherInfo;
  final String mentorYearInSchool;
  final String mentorSkill1;
  final String mentorSkill2;
  final String mentorSkill3;
  final int mentorSlots;
  final bool acknowledgeTerms;
  final String mentorFreeForm;
  final String lName;
  final String fName;
  final String profilePicture;

  Mentor({
    this.mentorBackground,
    this.mentorExperience,
    this.mentorOtherInfo,
    this.mentorYearInSchool,
    this.mentorFreeForm,
    this.id,
    this.mentorSlots,
    this.acknowledgeTerms,
    this.fName,
    this.lName,
    this.profilePicture,
    this.mentorSkill1,
    this.mentorSkill2,
    this.mentorSkill3,
  });

  factory Mentor.fromDocument(DocumentSnapshot doc) {
    return Mentor(
      id: doc.data().toString().contains('id') ? doc['id'] : '',
      mentorSlots: doc.data().toString().contains('Mentor Slots')
          ? doc['Mentor Slots']
          : 2,
      acknowledgeTerms: doc.data().toString().contains('Acknowledge Terms')
          ? doc['Acknowledge Terms']
          : false,
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
              : null,
      fName:
          doc.data().toString().contains('First Name') ? doc['First Name'] : '',
      lName:
          doc.data().toString().contains('Last Name') ? doc['Last Name'] : '',
      profilePicture: doc.data().toString().contains('Profile Picture')
          ? doc['Profile Picture']
          : '',
      mentorSkill1: doc.data().toString().contains('Mentor Skill 1')
          ? doc['Mentor Skill 1']
          : null,
      mentorSkill2: doc.data().toString().contains('Mentor Skill 2')
          ? doc['Mentor Skill 2']
          : null,
      mentorSkill3: doc.data().toString().contains('Mentor Skill 3')
          ? doc['Mentor Skill 3']
          : null,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'Mentor Slots': mentorSlots,
      'Acknowledge Terms': acknowledgeTerms,
      'Mentor Background': mentorBackground,
      'Mentor Experience': mentorExperience,
      'Mentor Other Info': mentorOtherInfo,
      'Mentor Year in School': mentorYearInSchool,
      'Mentor Free Form': mentorFreeForm,
      'First Name': fName,
      'Last Name': lName,
      'Profile Picture': profilePicture,
      'Mentor Skill 1': mentorSkill1,
      'Mentor Skill 2': mentorSkill2,
      'Mentor Skill 3': mentorSkill3
    };
  }
}
