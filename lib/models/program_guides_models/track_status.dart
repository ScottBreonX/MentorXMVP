import 'package:cloud_firestore/cloud_firestore.dart';

class TrackStatus {
  final bool trackSelected;
  final String track;

  TrackStatus({
    this.trackSelected,
    this.track,
  });

  factory TrackStatus.fromDocument(DocumentSnapshot doc) {
    return TrackStatus(
      trackSelected: doc.data().toString().contains('Track Selected')
          ? doc['Track Selected']
          : null,
      track: doc.data().toString().contains('Track') ? doc['Track'] : null,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'Track Selected': trackSelected,
      'Track': track,
    };
  }
}
