import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:mentorx_mvp/models/profile_model.dart';
import 'package:mentorx_mvp/services/api_path.dart';

abstract class Database {
  Future<void> createProfile(ProfileModel profile);
}

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid, this.mentorUID}) : assert(uid != null);
  final String uid;
  final String mentorUID;

  Future<void> createProfile(ProfileModel profile) => _setData(
        path: APIPath.user(uid),
        data: profile.toMap(),
      );

  Future<void> _setData({String path, Map<String, dynamic> data}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.set(data);
  }

  Future<void> updateAboutMe(ProfileModel profile) => _updateData(
        path: APIPath.user(uid),
        data: profile.toMap(),
      );

  Future<void> updateMentoringAttributes(MentoringAttributesModel profile) =>
      _updateData(
        path: APIPath.user(uid),
        data: profile.toMap(),
      );

  Future<void> updateMenteeAttributes(MenteeAttributesModel profile) =>
      _updateData(
        path: APIPath.user(uid),
        data: profile.toMap(),
      );

  Future<void> _updateData({String path, Map<String, dynamic> data}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.update(data);
  }
}
