import 'package:cloud_firestore/cloud_firestore.dart';

class Mentee {
  final String id;
  final String menteeSkill1;
  final String menteeSkill2;
  final String menteeSkill3;
  final String menteeFreeForm;

  Mentee({
    this.id,
    this.menteeSkill1,
    this.menteeSkill2,
    this.menteeSkill3,
    this.menteeFreeForm,
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
      menteeFreeForm: doc.data().toString().contains('Mentee Free Form')
          ? doc['Mentee Free Form']
          : null,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'Mentee Skill 1': menteeSkill1,
      'Mentee Skill 2': menteeSkill2,
      'Mentee Skill 3': menteeSkill3,
      'Mentee Free Form': menteeFreeForm,
    };
  }
}
