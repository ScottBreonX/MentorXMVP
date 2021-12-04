class MentorModel {
  MentorModel(
      {this.uid,
      this.availableSlots,
      this.fName,
      this.lName,
      this.email,
      this.whyMentor});
  final int availableSlots;
  final String uid;
  final String fName;
  final String lName;
  final String email;
  final String whyMentor;

  factory MentorModel.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final int availableSlots = data['Available Slots'];
    final String uid = data['UID'];
    final String fName = data['First Name'];
    final String lName = data['Last Name'];
    final String whyMentor = data['Why Mentor'];
    final String email = data['Email Address'];

    return MentorModel(
      availableSlots: availableSlots,
      uid: uid,
      fName: fName,
      lName: lName,
      whyMentor: whyMentor,
      email: email,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Available Slots': availableSlots,
      'UID': uid,
      'First Name': fName,
      'Last Name': lName,
      'Why Mentor': whyMentor,
      'Email Address': email,
    };
  }
}

class MenteeModel {
  MenteeModel({this.uid, this.fName, this.lName, this.email});
  final String uid;
  final String fName;
  final String lName;
  final String email;

  factory MenteeModel.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String uid = data['UID'];
    final String fName = data['First Name'];
    final String lName = data['Last Name'];
    final String email = data['Email Address'];

    return MenteeModel(
      uid: uid,
      fName: fName,
      lName: lName,
      email: email,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'UID': uid,
      'First Name': fName,
      'Last Name': lName,
      'Email Address': email,
    };
  }
}

class MentorMatchModel {
  MentorMatchModel({this.mentorUID, this.menteeUID});
  final String mentorUID;
  final String menteeUID;

  factory MentorMatchModel.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String mentorUID = data['mentorUID'];
    final String menteeUID = data['menteeUID'];

    return MentorMatchModel(
      mentorUID: mentorUID,
      menteeUID: menteeUID,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mentorUID': mentorUID,
      'menteeUID': menteeUID,
    };
  }
}

class MatchIDModel {
  MatchIDModel({this.mentorUID});
  final String mentorUID;

  factory MatchIDModel.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String mentorUID = data['mentorUID'];

    return MatchIDModel(
      mentorUID: mentorUID,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mentorUID': mentorUID,
    };
  }
}
