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
        yearInSchool: yearInSchool);
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
