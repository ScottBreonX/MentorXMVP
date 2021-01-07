import 'package:flutter/foundation.dart';

class Profile {
  Profile({@required this.fName, @required this.lName});
  final String fName;
  final String lName;

  Map<String, dynamic> toMap() {
    return {
      'fName': fName,
      'lName': lName,
    };
  }
}
