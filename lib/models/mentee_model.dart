import 'package:cloud_firestore/cloud_firestore.dart';

class Mentee {
  final String id;
  final String mteHobby1;
  final String mteHobby2;
  final String mteHobby3;
  final String mteAtt1;
  final String mteAtt2;
  final String mteAtt3;

  Mentee({
    this.id,
    this.mteHobby1,
    this.mteHobby2,
    this.mteHobby3,
    this.mteAtt1,
    this.mteAtt2,
    this.mteAtt3,
  });

  factory Mentee.fromDocument(DocumentSnapshot doc) {
    return Mentee(
      id: doc['id'],
      mteHobby1: doc['Mentee Hobby 1'],
      mteHobby2: doc['Mentee Hobby 2'],
      mteHobby3: doc['Mentee Hobby 3'],
      mteAtt1: doc['Mentee Attribute 1'],
      mteAtt2: doc['Mentee Attribute 2'],
      mteAtt3: doc['Mentee Attribute 3'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'Mentee Hobby 1': mteHobby1,
      'Mentee Hobby 2': mteHobby2,
      'Mentee Hobby 3': mteHobby3,
      'Mentee Attribute 1': mteAtt1,
      'Mentee Attribute 2': mteAtt2,
      'Mentee Attribute 3': mteAtt3,
    };
  }
}
