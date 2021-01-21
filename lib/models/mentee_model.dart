class MenteeModel {
  MenteeModel(
      {this.fName,
      this.lName,
      this.major,
      this.yearInSchool,
      this.uid,
      this.status});
  final String fName;
  final String lName;
  final String major;
  final String yearInSchool;
  final String uid;
  final String status;

  factory MenteeModel.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String fName = data['First Name'];
    final String lName = data['Last Name'];
    final String major = data['Major'];
    final String yearInSchool = data['Year in School'];
    final String uid = data['UID'];
    final String status = data['Status'];

    return MenteeModel(
      fName: fName,
      lName: lName,
      major: major,
      yearInSchool: yearInSchool,
      uid: uid,
      status: status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'First Name': fName,
      'Last Name': lName,
      'Major': major,
      'Year in School': yearInSchool,
      'UID': uid,
      'Status': status,
    };
  }
}
