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
  final String programLogo;

  Program({
    this.id,
    this.institutionName,
    this.programName,
    this.type,
    this.enrollmentType,
    this.aboutProgram,
    this.headAdmin,
    this.programCode,
    this.programLogo,
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
      programLogo: doc['programLogo'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'institutionName': institutionName,
      'programName': programName,
      'type': type,
      'enrollmentType': enrollmentType,
      'aboutProgram': aboutProgram,
      'headAdmin': headAdmin,
      'programCode': programCode,
      'programLogo': programLogo,
    };
  }
}
