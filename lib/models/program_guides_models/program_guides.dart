import 'package:cloud_firestore/cloud_firestore.dart';

class ProgramGuideStatus {
  final String introductionStatus;
  final String resume101Status;
  final String networking101Status;
  final String career101Status;
  final String company101Status;
  final String interview101Status;

  ProgramGuideStatus({
    this.career101Status,
    this.company101Status,
    this.interview101Status,
    this.introductionStatus,
    this.resume101Status,
    this.networking101Status,
  });

  factory ProgramGuideStatus.fromDocument(DocumentSnapshot doc) {
    return ProgramGuideStatus(
      introductionStatus: doc.data().toString().contains('Introductions')
          ? doc['Introductions']
          : null,
      resume101Status: doc.data().toString().contains('Resume 101')
          ? doc['Resume 101']
          : null,
      networking101Status: doc.data().toString().contains('Networking 101')
          ? doc['Networking 101']
          : null,
      career101Status: doc.data().toString().contains('Career 101')
          ? doc['Career 101']
          : null,
      company101Status: doc.data().toString().contains('Company 101')
          ? doc['Company 101']
          : null,
      interview101Status: doc.data().toString().contains('Interview 101')
          ? doc['Interview 101']
          : null,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'Introductions': introductionStatus,
      'Resume 101': resume101Status,
      'Networking 101': networking101Status,
      'Company 101': company101Status,
      'Career 101': career101Status,
      'Interview 101': interview101Status,
    };
  }
}
