import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:mentorx_mvp/models/profile.dart';
import 'package:mentorx_mvp/services/api_path.dart';

abstract class Database {
  Future<void> createProfile(Profile profile);
}

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  Future<void> createProfile(Profile profile) => _setData(
        path: APIPath.profile(uid, 'profile_abc'),
        data: profile.toMap(),
      );

  Future<void> _setData({String path, Map<String, dynamic> data}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('$path: $data');
    await reference.set(data);
  }
}
