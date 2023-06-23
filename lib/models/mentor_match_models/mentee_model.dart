import 'package:cloud_firestore/cloud_firestore.dart';

class Mentee {
  final String id;
  final String mentorSkill1;
  final String mentorSkill2;
  final String mentorSkill3;
  final String menteeFreeForm;

  Mentee({
    this.id,
    this.mentorSkill1,
    this.mentorSkill2,
    this.mentorSkill3,
    this.menteeFreeForm,
  });

  factory Mentee.fromDocument(DocumentSnapshot doc) {
    return Mentee(
      id: doc.data().toString().contains('id') ? doc['id'] : '',
      mentorSkill1: doc.data().toString().contains('Mentee Skill 1')
          ? doc['Mentee Skill 1']
          : null,
      mentorSkill2: doc.data().toString().contains('Mentee Skill 2')
          ? doc['Mentee Skill 2']
          : null,
      mentorSkill3: doc.data().toString().contains('Mentee Skill 3')
          ? doc['Mentee Skill 3']
          : null,
      menteeFreeForm: doc.data().toString().contains('Mentee Free Form')
          ? doc['Mentee Free Form']
          : null,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'Mentee Skill 1': mentorSkill1,
      'Mentee Skill 2': mentorSkill2,
      'Mentee Skill 3': mentorSkill3,
      'Mentee Free Form': menteeFreeForm,
    };
  }
}
