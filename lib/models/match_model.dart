import 'package:cloud_firestore/cloud_firestore.dart';

class MatchModel {
  final String matchID;

  MatchModel({
    this.matchID,
  });

  factory MatchModel.fromDocument(DocumentSnapshot doc) {
    return MatchModel(
      matchID: doc['matchID'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'matchID': matchID,
    };
  }
}
