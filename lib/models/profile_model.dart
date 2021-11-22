import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileModel {
  ProfileModel({
    this.fName,
    this.lName,
    this.email,
    this.major,
    this.yearInSchool,
  });
  final String fName;
  final String lName;
  final String major;
  final String yearInSchool;
  final String email;

  factory ProfileModel.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String fName = data['First Name'];
    final String lName = data['Last Name'];
    final String major = data['Major'];
    final String yearInSchool = data['Year in School'];
    final String email = data['Email Address'];

    return ProfileModel(
      fName: fName,
      lName: lName,
      email: email,
      major: major,
      yearInSchool: yearInSchool,
    );
  }

  factory ProfileModel.fromDocument(DocumentSnapshot doc) {
    if (doc == null) {
      return null;
    }
    return ProfileModel(
        fName: doc['First Name'],
        lName: doc['Last Name'],
        major: doc['Major'],
        yearInSchool: doc['Year in School'],
        email: doc['Email Address']);
  }

  Map<String, dynamic> toMap() {
    return {
      'First Name': fName,
      'Last Name': lName,
      'Major': major,
      'Email Address': email,
      'Year in School': yearInSchool,
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

class WorkExperienceModel {
  WorkExperienceModel(
      {this.company,
      this.title,
      this.description,
      this.startDate,
      this.endDate,
      this.location});

  final String company;
  final String title;
  final String description;
  final String startDate;
  final String endDate;
  final String location;

  factory WorkExperienceModel.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String company = data['Company'];
    final String title = data['Title'];
    final String description = data['Description'];
    final String startDate = data['Start Date'];
    final String endDate = data['End Date'];
    final String location = data['Location'];

    return WorkExperienceModel(
      company: company,
      title: title,
      description: description,
      startDate: startDate,
      endDate: endDate,
      location: location,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Company': company,
      'Title': title,
      'Description': description,
      'Start Date': startDate,
      'End Date': endDate,
      'Location': location,
    };
  }
}
