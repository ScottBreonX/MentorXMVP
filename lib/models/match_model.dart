import 'package:cloud_firestore/cloud_firestore.dart';

class MatchModel {
  final String id;
  final String notes;

  MatchModel({
    this.id,
    this.notes,
  });

  factory MatchModel.fromDocument(DocumentSnapshot doc) {
    return MatchModel(
      id: doc['id'],
      notes: doc['notes'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'notes': notes,
    };
  }
}
