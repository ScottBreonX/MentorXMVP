import 'package:cloud_firestore/cloud_firestore.dart';

class Matches {
  final String mentorSelected;

  Matches({
    this.mentorSelected,
  });

  factory Matches.fromDocument(DocumentSnapshot doc) {
    return Matches(
      mentorSelected: doc['mentorSelected'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'mentorSelected': mentorSelected,
    };
  }
}
