import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:mentorx_mvp/models/mentoring_model.dart';
import 'package:mentorx_mvp/models/profile_model.dart';
import 'package:mentorx_mvp/services/api_path.dart';

abstract class Database {
  Future<void> createProfile(ProfileModel profile);
  Stream<List<ProfileModel>> _profileStream();
}

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid, this.mentorUID}) : assert(uid != null);
  final String uid;
  final String mentorUID;

  Future<void> createProfile(ProfileModel profile) => _setData(
        path: APIPath.profile(uid, 'coreInfo'),
        data: profile.toMap(),
      );

  Future<void> createMentor(MentorModel mentor) => _setData(
        path: APIPath.mentoring('UniversityOfFlorida', 'mentors', uid),
        data: mentor.toMap(),
      );

  Future<void> createMentee(MenteeModel mentee) => _setData(
        path: APIPath.mentoring('UniversityOfFlorida', 'mentee', uid),
        data: mentee.toMap(),
      );

  Future<void> createMentorMatch(
    MentorMatchModel mentorMatch,
    String mentorUID,
  ) =>
      _setData(
        path: APIPath.mentorMatch('UniversityOfFlorida', mentorUID, uid),
        data: mentorMatch.toMap(),
      );

  Future<void> _setData({String path, Map<String, dynamic> data}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('$path: $data');
    await reference.set(data);
  }

  Future<void> updateProfile(ProfileModel profile) => _updateData(
        path: APIPath.profile(uid, 'coreInfo'),
        data: profile.toMap(),
      );
  Future<void> createMatchID(MatchIDModel matchID) => _updateData(
        path: APIPath.profile(uid, 'coreInfo'),
        data: matchID.toMap(),
      );

  Future<void> _updateData({String path, Map<String, dynamic> data}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('$path: $data');
    await reference.update(data);
  }

  Stream<List<ProfileModel>> _profileStream() {
    final path = 'users/$uid/profile';
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.docs
        .map(
          (snapshot) => ProfileModel.fromMap(snapshot.data()),
        )
        .toList());
  }
}
