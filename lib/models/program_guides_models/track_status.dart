import 'package:cloud_firestore/cloud_firestore.dart';

class TrackInfo {
  final bool trackSelected;
  final String track;

  TrackInfo({
    this.trackSelected,
    this.track,
  });

  factory TrackInfo.fromDocument(DocumentSnapshot doc) {
    return TrackInfo(
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
