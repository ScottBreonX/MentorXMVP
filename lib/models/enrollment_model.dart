import 'package:cloud_firestore/cloud_firestore.dart';

class EnrollmentModel {
  final String enrollmentStatus;
  final bool profileComplete;
  final bool enrollmentComplete;
  final bool guidelinesComplete;

  EnrollmentModel({
    this.enrollmentComplete,
    this.guidelinesComplete,
    this.enrollmentStatus,
    this.profileComplete,
  });

  factory EnrollmentModel.fromDocument(DocumentSnapshot doc) {
    return EnrollmentModel(
      enrollmentStatus: doc.data().toString().contains('enrollmentStatus')
          ? doc['enrollmentStatus']
          : '',
      profileComplete: doc.data().toString().contains('Profile Complete')
          ? doc['Profile Complete']
          : false,
      enrollmentComplete: doc.data().toString().contains('Enrollment Complete')
          ? doc['Enrollment Complete']
          : false,
      guidelinesComplete: doc.data().toString().contains('Guidelines Complete')
          ? doc['Guidelines Complete']
          : false,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'enrollmentStatus': enrollmentStatus,
      'Profile Complete': profileComplete,
      'Enrollment Complete': enrollmentComplete,
      'Guidelines Complete': guidelinesComplete,
    };
  }
}
