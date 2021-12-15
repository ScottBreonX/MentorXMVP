import 'package:cloud_firestore/cloud_firestore.dart';

class Program {
  final String institutionName;
  final String programName;
  final String type;
  final String enrollmentType;
  final String aboutProgram;

  Program({
    this.institutionName,
    this.programName,
    this.type,
    this.enrollmentType,
    this.aboutProgram,
  });

  factory Program.fromDocument(DocumentSnapshot doc) {
    return Program(
      institutionName: doc['institutionName'],
      programName: doc['programName'],
      type: doc['type'],
      enrollmentType: doc['enrollmentType'],
      aboutProgram: doc['aboutProgram'],
    );
  }
}
