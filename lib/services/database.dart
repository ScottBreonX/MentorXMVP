import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

abstract class Database {
  Future<void> createProfile(Map<String, dynamic> profileData);
}

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);

  final String uid;

  Future<void> createProfile(Map<String, dynamic> profileData) async {
    final path = '/users/$uid/profile/';
    final documentReference = FirebaseFirestore.instance.doc(path);
    await documentReference.set(profileData);
  }
}
