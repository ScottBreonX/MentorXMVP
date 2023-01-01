import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/models/user.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');

class MenteeSignupScreen extends StatefulWidget {
  final myUser loggedInUser;
  final String programUID;
  static const String id = 'mentee_signup_screen';

  const MenteeSignupScreen({
    this.loggedInUser,
    this.programUID,
  });

  @override
  State<MenteeSignupScreen> createState() => _MenteeSignupScreenState();
}

class _MenteeSignupScreenState extends State<MenteeSignupScreen> {
  //
  // Future<void> _updateMenteeAttributes(
  //     BuildContext context, String programUID) async {
  //   try {
  //     await programsRef
  //         .doc(programUID)
  //         .collection('mentees')
  //         .doc(loggedInUser.id)
  //         .set({
  //       trait1 ?? "Mentee Attribute 1": trait1,
  //       trait2 ?? "Mentee Attribute 2": trait2,
  //       trait3 ?? "Mentee Attribute 3": trait3,
  //       "id": loggedInUser.id,
  //     });
  //     await programsRef
  //         .doc(programUID)
  //         .collection('userSubscribed')
  //         .doc(loggedInUser.id)
  //         .set({
  //       "enrollmentStatus": 'mentee',
  //     });
  //     loggedInUser =
  //         myUser.fromDocument(await usersRef.doc(loggedInUser.id).get());
  //   } on FirebaseException catch (e) {
  //     showAlertDialog(context,
  //         title: 'Operation Failed', content: '$e', defaultActionText: 'Ok');
  //   }
  // }

  String selectedValue;

  List<String> items = [
    'coding',
    'analytics',
    'presenting',
    'communication',
    'finance',
    'networking',
    'managing up'
  ];

  Map<String, IconData> map = {
    'coding': Icons.code,
    'analytics': Icons.add,
    'presenting': Icons.add,
    'communication': Icons.add,
    'finance': Icons.add,
    'networking': Icons.add,
    'managing up': Icons.add,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMentorXPPrimary,
        elevation: 5,
        title: Image.asset(
          'assets/images/MentorXP.png',
          height: 100,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20, top: 40),
        child: Column(
          children: [
            Text(
              'What are the top 3 skills you are looking to develop?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 20,
                color: Colors.black54,
              ),
            ),
            dropDownSection('Skill #1'),
            dropDownSection('Skill #2'),
            dropDownSection('Skill #3'),
          ],
        ),
      ),
    );
  }

  DropdownButtonHideUnderline dropDownSection(String titleText) {
    return DropdownButtonHideUnderline(
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0, bottom: 10, top: 20),
                child: Text(
                  titleText,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 20,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          DropdownButton2(
            isExpanded: true,
            hint: Row(
              children: const [
                Expanded(
                  child: Text(
                    'Select Item',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            items: items
                .map((name) => DropdownMenuItem<String>(
                      value: name,
                      child: Row(
                        children: [
                          Icon(
                            map[name],
                            color: Colors.white,
                          ),
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontFamily: 'Montserrat',
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ))
                .toList(),
            value: selectedValue,
            onChanged: (value) {
              setState(() {
                selectedValue = value as String;
              });
            },
            icon: const Icon(
              Icons.arrow_drop_down_circle_rounded,
            ),
            iconSize: 30,
            iconEnabledColor: Colors.white,
            buttonHeight: 60,
            buttonPadding: const EdgeInsets.only(left: 14, right: 14),
            buttonDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white,
              ),
              color: kMentorXPSecondary,
            ),
            buttonElevation: 4,
            itemHeight: 40,
            itemPadding: const EdgeInsets.only(left: 14, right: 14),
            dropdownMaxHeight: 200,
            dropdownOverButton: false,
            dropdownDecoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              color: kMentorXPSecondary,
            ),
            dropdownElevation: 8,
            scrollbarRadius: const Radius.circular(50),
            scrollbarThickness: 15,
            scrollbarAlwaysShow: true,
            // offset: const Offset(-20, 0),
          ),
        ],
      ),
    );
  }
}
