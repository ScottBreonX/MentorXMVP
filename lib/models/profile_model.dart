class ProfileModel {
  ProfileModel({
    this.fName,
    this.lName,
    this.email,
    this.major,
    this.yearInSchool,
    this.hobbies,
    this.motivations,
    this.expertise,
  });
  final String fName;
  final String lName;
  final String major;
  final String yearInSchool;
  final String email;
  final String hobbies;
  final String motivations;
  final String expertise;

  factory ProfileModel.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String fName = data['First Name'];
    final String lName = data['Last Name'];
    final String major = data['Major'];
    final String yearInSchool = data['Year in School'];
    final String email = data['Email Address'];
    final String hobbies = data['Hobbies'];
    final String motivations = data['Motivations'];
    final String expertise = data['Expertise'];

    return ProfileModel(
      fName: fName,
      lName: lName,
      email: email,
      major: major,
      yearInSchool: yearInSchool,
      hobbies: hobbies,
      motivations: motivations,
      expertise: expertise,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'First Name': fName,
      'Last Name': lName,
      'Major': major,
      'Email Address': email,
      'Year in School': yearInSchool,
      'Hobbies': hobbies,
      'Motivations': motivations,
      'Expertise': expertise,
    };
  }
}
