import 'package:cloud_firestore/cloud_firestore.dart';

class Program {
  final String institutionName;
  final String programName;
  final String type;

  Program({
    this.institutionName,
    this.programName,
    this.type,
  });

  factory Program.fromDocument(DocumentSnapshot doc) {
    return Program(
      institutionName: doc['institutionName'],
      programName: doc['programName'],
      type: doc['type'],
    );
  }
}
