import 'package:cloud_firestore/cloud_firestore.dart';

class ProgramGuideStatus {
  final String introductionStatus;
  final String resume101Status;
  final String networking101Status;
  final String career101Status;
  final String company101Status;
  final String interview101Status;
  final String networking201Status;
  final String interviewPrep201status;
  final String mockInterview201status;
  final String resume201status;

  ProgramGuideStatus({
    this.career101Status,
    this.company101Status,
    this.interview101Status,
    this.introductionStatus,
    this.resume101Status,
    this.networking101Status,
    this.networking201Status,
    this.interviewPrep201status,
    this.mockInterview201status,
    this.resume201status,
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
      networking201Status: doc.data().toString().contains('Networking 201')
          ? doc['Networking 201']
          : null,
      interviewPrep201status:
          doc.data().toString().contains('Interview Prep 201')
              ? doc['Interview Prep 201']
              : null,
      mockInterview201status:
          doc.data().toString().contains('Mock Interview 201')
              ? doc['Mock Interview 201']
              : null,
      resume201status: doc.data().toString().contains('Resume 201')
          ? doc['Resume 201']
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
      'Networking 201': networking201Status,
      'Interview Prep 201': interviewPrep201status,
      'Mock Interview 201': mockInterview201status,
      'Resume 201': resume201status,
    };
  }
}
