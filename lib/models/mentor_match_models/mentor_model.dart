import 'package:cloud_firestore/cloud_firestore.dart';

class Mentor {
  final String id;
  final int mentorSlots;
  final String mentorSkill1;
  final String mentorSkill2;
  final String mentorSkill3;
  final String mentorHobby1;
  final String mentorHobby2;
  final String mentorHobby3;
  final String mentorFreeForm;

  Mentor({
    this.mentorSkill1,
    this.mentorSkill2,
    this.mentorSkill3,
    this.mentorHobby1,
    this.mentorHobby2,
    this.mentorHobby3,
    this.mentorFreeForm,
    this.id,
    this.mentorSlots,
  });

  factory Mentor.fromDocument(DocumentSnapshot doc) {
    return Mentor(
      id: doc.data().toString().contains('id') ? doc['id'] : '',
      mentorSlots: doc.data().toString().contains('mentorSlots')
          ? doc['mentorSlots']
          : 2,
      mentorSkill1: doc.data().toString().contains('Mentor Skill 1')
          ? doc['Mentor Skill 1']
          : null,
      mentorSkill2: doc.data().toString().contains('Mentor Skill 2')
          ? doc['Mentor Skill 2']
          : null,
      mentorSkill3: doc.data().toString().contains('Mentor Skill 3')
          ? doc['Mentor Skill 3']
          : null,
      mentorHobby1: doc.data().toString().contains('Mentor Hobby 1')
          ? doc['Mentor Hobby 1']
          : null,
      mentorHobby2: doc.data().toString().contains('Mentor Hobby 2')
          ? doc['Mentor Hobby 2']
          : null,
      mentorHobby3: doc.data().toString().contains('Mentor Hobby 3')
          ? doc['Mentor Hobby 3']
          : null,
      mentorFreeForm: doc.data().toString().contains('Mentor Free Form')
          ? doc['Mentor Free Form']
          : '',
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'Mentor Slots': mentorSlots,
      'Mentor Hobby 1': mentorHobby1,
      'Mentor Hobby 2': mentorHobby2,
      'Mentor Hobby 3': mentorHobby3,
      'Mentor Skill 1': mentorSkill1,
      'Mentor Skill 2': mentorSkill2,
      'Mentor Skill 3': mentorSkill3,
      'Mentor Free Form': mentorFreeForm,
    };
  }
}
