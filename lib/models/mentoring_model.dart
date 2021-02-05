class MentorModel {
  MentorModel(
      {this.uid, this.availableSlots, this.fName, this.lName, this.email});
  final int availableSlots;
  final String uid;
  final String fName;
  final String lName;
  final String email;

  factory MentorModel.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final int availableSlots = data['Available Slots'];
    final String uid = data['UID'];
    final String fName = data['First Name'];
    final String lName = data['Last Name'];
    final String email = data['Email Address'];

    return MentorModel(
      availableSlots: availableSlots,
      uid: uid,
      fName: fName,
      lName: lName,
      email: email,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Available Slots': availableSlots,
      'UID': uid,
      'First Name': fName,
      'Last Name': lName,
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
