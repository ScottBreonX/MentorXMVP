import 'package:cloud_firestore/cloud_firestore.dart';

class Notes {
  final String titleText;
  final String noteText;
  final String noteID;

  Notes({
    this.titleText,
    this.noteText,
    this.noteID,
  });

  factory Notes.fromDocument(DocumentSnapshot doc) {
    return Notes(
      titleText: doc['Title Text'],
      noteText: doc['Notes'],
      noteID: doc['id'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'Title Text': titleText,
      'Notes': noteText,
      'id': noteID,
    };
  }
}
