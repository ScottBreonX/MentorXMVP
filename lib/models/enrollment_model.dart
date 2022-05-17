import 'package:cloud_firestore/cloud_firestore.dart';

class EnrollmentModel {
  final String enrollmentStatus;

  EnrollmentModel({this.enrollmentStatus});

  factory EnrollmentModel.fromDocument(DocumentSnapshot doc) {
    return EnrollmentModel(
      enrollmentStatus: doc.data().toString().contains('enrollmentStatus')
          ? doc['enrollmentStatus']
          : '',
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'enrollmentStatus': enrollmentStatus,
    };
  }
}
