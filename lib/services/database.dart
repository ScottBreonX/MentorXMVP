import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/models/program.dart';

abstract class Database {
  Future<void> createProfile(myUser user);
  Future<String> createProgram(Program program);
}

class FirestoreDatabase implements Database {
  FirestoreDatabase();

  Future<void> createProfile(myUser user) => _setData(
        path: 'users/${user.id}',
        data: user.toMap(),
      );

  Future<String> createProgram(Program program) => _setCollectionData(
        path: 'institutions/',
        data: program.toMap(),
      );

  Future<void> updateProgram(Program program, String programUID) => _setData(
        path: 'institutions/$programUID',
        data: program.toMap(),
      );

  Future<void> editProgram(Program program, String programUID) => _updateData(
        path: 'institutions/$programUID',
        data: program.toMap(),
      );

  Future<void> _setData({String path, Map<String, dynamic> data}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.set(data);
  }

  Future<void> _updateData({String path, Map<String, dynamic> data}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.update(data);
  }

  Future<String> _setCollectionData(
      {String path, Map<String, dynamic> data}) async {
    final reference = FirebaseFirestore.instance.collection(path);
    var docRef = await reference.add(data);
    return (docRef.id.toString());
  }
}
