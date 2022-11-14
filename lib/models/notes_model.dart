import 'package:cloud_firestore/cloud_firestore.dart';

class Notes {
  final String titleText;
  final String noteText;
  final String noteID;
  final Timestamp dateID;

  Notes({
    this.titleText,
    this.noteText,
    this.noteID,
    this.dateID,
  });

  factory Notes.fromDocument(DocumentSnapshot doc) {
    return Notes(
      titleText: doc['Title Text'],
      noteText: doc['Notes'],
      noteID: doc['id'],
      dateID: doc['timeStamp'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'Title Text': titleText,
      'Notes': noteText,
      'id': noteID,
      'timeStamp': dateID,
    };
  }
}
