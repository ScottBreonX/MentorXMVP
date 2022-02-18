import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/alert_dialog.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/launch_screen.dart';

class MenteeSignupScreen extends StatefulWidget {
  final myUser loggedInUser;
  static const String id = 'mentoring_signup_screen_test';

  const MenteeSignupScreen({
    this.loggedInUser,
  });

  @override
  State<MenteeSignupScreen> createState() => _MenteeSignupScreenState();
}

class _MenteeSignupScreenState extends State<MenteeSignupScreen> {
  String trait1;
  String trait2;
  String trait3;
  String hobby1;
  String hobby2;
  String hobby3;
  TextEditingController makesMeGreatController = TextEditingController();
  List<Step> steps;
  int currentStep = 0;
  bool complete = false;

  List<String> skillsets = [
    'adfgdfgdf',
    'bdfgdfg',
    'cdfgdfgd',
    'ddfgdfgdfg',
  ];

  List<String> hobbies = [
    'golf',
    'coding',
    'video games',
    'painting',
    'drawing',
    'robotics'
  ];

  buildDropdownField({
    String inputValue,
    List listItems,
    final void Function(String) inputFunction,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary,
          width: 3.0,
        ),
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.white,
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<String>(
            dropdownColor: Colors.white,
            value: inputValue,
            iconSize: 36,
            isExpanded: true,
            icon: Icon(Icons.arrow_drop_down, color: Colors.black),
            items: listItems,
            onChanged: inputFunction,
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      );

  buildFormField({
    String hintString,
    IconData icon,
    TextEditingController traitController,
    int minLines,
  }) {
    return TextFormField(
      style: Theme.of(context).textTheme.subtitle2,
      controller: traitController,
      minLines: minLines,
      maxLines: minLines == null ? 1 : minLines + 1,
      decoration: InputDecoration(
        hintText: hintString,
        hintStyle: Theme.of(context).textTheme.subtitle2,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2.0,
          ),
        ),
        fillColor: Colors.white,
        prefixIcon: Icon(
          icon,
          size: 30,
        ),
      ),
    );
  }

  buildQuestionnaire() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Top 3 skill sets you\'re looking to develop',
                  style: Theme.of(context).textTheme.headline4,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 6),
        Column(
          children: [
            Text(
              'Skill set 1',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            buildDropdownField(
              inputValue: trait1,
              listItems: skillsets.map(buildMenuItem).toList(),
              inputFunction: (trait1) => setState(() => this.trait1 = trait1),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Skill set 2',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            buildDropdownField(
              inputValue: trait2,
              listItems: skillsets.map(buildMenuItem).toList(),
              inputFunction: (trait2) => setState(() => this.trait2 = trait2),
            ),
            SizedBox(height: 10),
            Text(
              'Skill set 3',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            buildDropdownField(
              inputValue: trait3,
              listItems: skillsets.map(buildMenuItem).toList(),
              inputFunction: (trait3) => setState(() => this.trait3 = trait3),
            ),
          ],
        ),
      ],
    );
  }

  buildHobbiesForm() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'What are your top 3 hobbies/activities?',
                  style: Theme.of(context).textTheme.headline4,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 6),
        Column(
          children: [
            Text(
              'Hobby/Activity 1',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            buildDropdownField(
              inputValue: hobby1,
              listItems: hobbies.map(buildMenuItem).toList(),
              inputFunction: (hobby1) => setState(() => this.hobby1 = hobby1),
            ),
            SizedBox(height: 10),
            Text(
              'Hobby/Activity 2',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            buildDropdownField(
              inputValue: hobby2,
              listItems: hobbies.map(buildMenuItem).toList(),
              inputFunction: (hobby2) => setState(() => this.hobby2 = hobby2),
            ),
            SizedBox(height: 10),
            Text(
              'Hobby/Activity 3',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            buildDropdownField(
              inputValue: hobby3,
              listItems: hobbies.map(buildMenuItem).toList(),
              inputFunction: (hobby3) => setState(() => this.hobby3 = hobby3),
            ),
          ],
        ),
      ],
    );
  }

  buildStepList(steps) {
    steps = [
      Step(
        title: const Text(
          'Skill Sets',
          style: TextStyle(
            fontSize: 15,
          ),
        ),
        isActive: currentStep == 0 ? true : false,
        state: currentStep == 0
            ? StepState.editing
            : ((trait1 != null) & (trait2 != null) & (trait3 != null))
                ? StepState.complete
                : StepState.error,
        content: Column(
          children: [buildQuestionnaire()],
        ),
      ),
      Step(
        title: const Text(
          'Hobbies',
          style: TextStyle(
            fontSize: 15,
          ),
        ),
        isActive: currentStep == 1 ? true : false,
        state: currentStep == 1
            ? StepState.editing
            : ((hobby1 != null) & (hobby2 != null) & (hobby3 != null))
                ? StepState.complete
                : StepState.error,
        content: Column(
          children: [buildHobbiesForm()],
        ),
      ),
      Step(
        title: const Text(
          'LookingFor',
          style: TextStyle(
            fontSize: 15,
          ),
        ),
        isActive: currentStep == 2 ? true : false,
        state: currentStep == 2
            ? StepState.editing
            : makesMeGreatController.text != ''
                ? StepState.complete
                : StepState.error,
        content: Column(
          children: [
            buildFormField(
              hintString: 'What I\'m looking for in a mentor is...',
              traitController: makesMeGreatController,
              minLines: 7,
            ),
          ],
        ),
      ),
    ];
    setState(() => this.steps = steps);
    return steps;
  }

  Future<void> _updateMenteeAttributes(
    BuildContext context,
  ) async {
    try {
      await menteesRef.doc(loggedInUser.id).set({
        "Mentee Attribute 1": trait1,
        "Mentee Attribute 2": trait2,
        "Mentee Attribute 3": trait3,
        "Hobby 1": hobby1,
        "Hobby 2": hobby2,
        "Hobby 3": hobby3,
        "LookingFor": makesMeGreatController.text,
      });
      await usersRef.doc(loggedInUser.id).update({
        "Mentee": true,
      });
      // re-fetch loggedInUser info to set Mentee status to true
      loggedInUser =
          myUser.fromDocument(await usersRef.doc(loggedInUser.id).get());
    } on FirebaseException catch (e) {
      showAlertDialog(context,
          title: 'Operation Failed', content: '$e', defaultActionText: 'Ok');
    }
    print('ATTRIBUTES UPDATED');
  }

  next() {
    if (currentStep + 1 != steps.length) {
      goTo(currentStep + 1);
    } else if ((trait1 != '') &
        (trait2 != '') &
        (trait3 != '') &
        (hobby1 != '') &
        (hobby2 != '') &
        (hobby3 != '') &
        (makesMeGreatController.text != '')) {
      setState(() => complete = true);
      _updateMenteeAttributes(context);
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Questionnaire incomplete'),
          actions: [
            TextButton(
              child: Text(
                "Okay",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        barrierDismissible: true,
      );
    }
  }

  cancel() {
    if (currentStep > 0) {
      goTo(currentStep - 1);
    } else {
      Navigator.pop(context);
    }
  }

  goTo(int step) {
    setState(() => currentStep = step);
    print(currentStep);
    print(steps.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMentorXPrimary,
        elevation: 5,
        title: Text('Mentee Sign Up Questionnaire'),
      ),
      body: Column(
        children: [
          complete
              ? Expanded(
                  child: Center(
                    child: AlertDialog(
                      backgroundColor: Colors.grey[200],
                      title: Text(
                        'Success! Thank you for enrolling as a Mentee!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      content: SingleChildScrollView(
                          child: Column(
                        children: [
                          SizedBox(height: 20),
                          Text(
                            'Next Steps: ',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).textTheme.headline1.color,
                            ),
                          ),
                          Text(
                            'Proceed to the mentorship launch screen and complete the required pre-read materials.',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      )),
                      actions: [
                        TextButton(
                          child: Text('Close'),
                          onPressed: () {
                            int count = 0;
                            Navigator.of(context).popUntil((_) => count++ >= 2);
                          },
                        ),
                      ],
                    ),
                  ),
                )
              : Expanded(
                  child: Stepper(
                    steps: buildStepList(steps),
                    type: StepperType.horizontal,
                    currentStep: currentStep,
                    onStepContinue: next,
                    onStepCancel: cancel,
                    onStepTapped: (step) => goTo(step),
                  ),
                )
        ],
      ),
    );
  }
}
