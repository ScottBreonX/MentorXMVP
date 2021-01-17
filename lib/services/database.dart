import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:mentorx_mvp/models/profile_model.dart';
import 'package:mentorx_mvp/services/api_path.dart';

abstract class Database {
  Future<void> createProfile(Profile profile);
  Stream<List<Profile>> profileStream();
}

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  Future<void> createProfile(Profile profile) => _setData(
        path: APIPath.profile(uid, 'coreInfo'),
        data: profile.toMap(),
      );

  Future<void> _setData({String path, Map<String, dynamic> data}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('$path: $data');
    await reference.set(data);
  }

  Stream<List<Profile>> profileStream() {
    final path = 'users/$uid/profile';
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.docs
        .map(
          (snapshot) => Profile.fromMap(snapshot.data()),
        )
        .toList());
  }
}