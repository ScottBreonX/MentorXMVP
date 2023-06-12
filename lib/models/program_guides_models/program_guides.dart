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
  final String companyTour201Status;
  final String interview301Status;
  final String networking301Status;
  final String mentor301Status;
  final String coaching301Status;
  final String jobShadow301Status;
  final String emotionalIntelligenceStatus;
  final String diversityInclusion;
  final String skillDevelopment;
  final String graduateDegrees;
  final String payingItForward;

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
    this.companyTour201Status,
    this.interview301Status,
    this.networking301Status,
    this.mentor301Status,
    this.coaching301Status,
    this.jobShadow301Status,
    this.emotionalIntelligenceStatus,
    this.diversityInclusion,
    this.skillDevelopment,
    this.graduateDegrees,
    this.payingItForward,
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
      companyTour201Status: doc.data().toString().contains('Company Tour 201')
          ? doc['Company Tour 201']
          : null,
      interview301Status: doc.data().toString().contains('Interview 301')
          ? doc['Interview 301']
          : null,
      networking301Status: doc.data().toString().contains('Networking 301')
          ? doc['Networking 301']
          : null,
      mentor301Status: doc.data().toString().contains('Mentor 301')
          ? doc['Mentor 301']
          : null,
      coaching301Status: doc.data().toString().contains('Coaching 301')
          ? doc['Coaching 301']
          : null,
      jobShadow301Status: doc.data().toString().contains('Job Shadow 301')
          ? doc['Job Shadow 301']
          : null,
      emotionalIntelligenceStatus:
          doc.data().toString().contains('Emotional Intelligence')
              ? doc['Emotional Intelligence']
              : null,
      diversityInclusion:
          doc.data().toString().contains('Diversity & Inclusion')
              ? doc['Diversity & Inclusion']
              : null,
      skillDevelopment: doc.data().toString().contains('Skill Development')
          ? doc['Skill Development']
          : null,
      graduateDegrees: doc.data().toString().contains('Graduate Degrees')
          ? doc['Graduate Degrees']
          : null,
      payingItForward: doc.data().toString().contains('Paying It Forward')
          ? doc['Paying It Forward']
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
      'Company Tour 201': companyTour201Status,
      'Interview 301': interview301Status,
      'Networking 301': networking301Status,
      'Mentor 301': mentor301Status,
      'Coaching 301': coaching301Status,
      'Job Shadow 301': jobShadow301Status,
      'Emotional Intelligence': emotionalIntelligenceStatus,
      'Diversity & Inclusion': diversityInclusion,
      'Skill Development': skillDevelopment,
      'Graduate Degrees': graduateDegrees,
      'Paying It Forward': payingItForward,
    };
  }
}
