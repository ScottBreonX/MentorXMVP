import 'package:cloud_firestore/cloud_firestore.dart';

class Program {
  final String id;
  final String institutionName;
  final String programName;
  final String type;
  final String enrollmentType;
  final String aboutProgram;
  final String headAdmin;
  final String programCode;

  Program({
    this.id,
    this.institutionName,
    this.programName,
    this.type,
    this.enrollmentType,
    this.aboutProgram,
    this.headAdmin,
    this.programCode,
  });

  factory Program.fromDocument(DocumentSnapshot doc) {
    return Program(
      id: doc['id'],
      institutionName: doc['institutionName'],
      programName: doc['programName'],
      type: doc['type'],
      enrollmentType: doc['enrollmentType'],
      aboutProgram: doc['aboutProgram'],
      headAdmin: doc['headAdmin'],
      programCode: doc['programCode'],
    );
  }
}
