import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:mentorx_mvp/models/profile_model.dart';
import 'package:mentorx_mvp/services/auth.dart';
import 'package:mentorx_mvp/services/database.dart';

class ProfileBloc {
  ProfileBloc({@required this.auth});
  final AuthBase auth;

  final StreamController<ProfileModel> _modelController =
      StreamController<ProfileModel>();
  Stream<ProfileModel> get modelStream => _modelController.stream;
  ProfileModel _model = ProfileModel();

  void dispose() {
    _modelController.close();
  }

//  Future<void> createUser() async {
//    updateWith(submitted: true, showSpinner: true);
//    try {
//      await auth.createUserWithEmailAndPassword(_model.email, _model.password);
//    } catch (e) {
//      updateWith(showSpinner: false);
//      rethrow;
//    }
//  }

  void updateEmail(String email) => updateWith(email: email);
  void updateFName(String fName) => updateWith(fName: fName);
  void updateLName(String lName) => updateWith(lName: lName);
  void updateMajor(String major) => updateWith(major: major);

  void updateWith({
    String email,
    String fName,
    String lName,
    String major,
    bool submitted,
    bool showSpinner,
  }) {
    //update model
    _model = _model.copyWith(
      email: email,
      fName: fName,
      lName: lName,
      major: major,
      submitted: submitted,
      showSpinner: showSpinner,
    );
    //add updated model to _modelController
    _modelController.add(_model);
  }
}
