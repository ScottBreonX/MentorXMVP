import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileModel {
  ProfileModel({
    this.fName,
    this.lName,
    this.email,
  });
  final String fName;
  final String lName;
  final String email;

  factory ProfileModel.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String fName = data['First Name'];
    final String lName = data['Last Name'];
    final String email = data['Email Address'];

    return ProfileModel(
      fName: fName,
      lName: lName,
      email: email,
    );
  }

  factory ProfileModel.fromDocument(DocumentSnapshot doc) {
    if (doc == null) {
      return null;
    }
    return ProfileModel(
        fName: doc['First Name'],
        lName: doc['Last Name'],
        email: doc['Email Address']);
  }

  Map<String, dynamic> toMap() {
    return {
      'First Name': fName,
      'Last Name': lName,
      'Email Address': email,
    };
  }
}

class AboutMeModel {
  AboutMeModel({
    this.aboutMe,
  });
  final String aboutMe;

  factory AboutMeModel.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String aboutMe = data['About Me'];

    return AboutMeModel(
      aboutMe: aboutMe,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'About Me': aboutMe,
    };
  }
}

class MentoringAttributesModel {
  MentoringAttributesModel({
    this.mentoringAttributes,
  });
  final String mentoringAttributes;

  factory MentoringAttributesModel.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String mentoringAttributes = data['Mentoring Attributes'];

    return MentoringAttributesModel(
      mentoringAttributes: mentoringAttributes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Mentoring Attributes': mentoringAttributes,
    };
  }
}

class MenteeAttributesModel {
  MenteeAttributesModel({
    this.menteeAttributes,
  });
  final String menteeAttributes;

  factory MenteeAttributesModel.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String menteeAttributes = data['Mentee Attributes'];

    return MenteeAttributesModel(
      menteeAttributes: menteeAttributes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Mentee Attributes': menteeAttributes,
    };
  }
}
