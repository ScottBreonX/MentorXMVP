import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mentorx_mvp/models/user.dart';

abstract class Database {
  Future<void> createProfile(myUser user);
}

class FirestoreDatabase implements Database {
  FirestoreDatabase();

  Future<void> createProfile(myUser user) => _setData(
        path: 'users/${user.id}',
        data: user.toMap(),
      );

  Future<void> _setData({String path, Map<String, dynamic> data}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.set(data);
  }
}
