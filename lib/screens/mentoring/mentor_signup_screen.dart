import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/alert_dialog.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/launch_screen.dart';

class MentorSignupScreen extends StatefulWidget {
  final myUser loggedInUser;
  static const String id = 'mentoring_signup_screen_test';

  const MentorSignupScreen({
    this.loggedInUser,
  });

  @override
  State<MentorSignupScreen> createState() => _MentorSignupScreenState();
}

class _MentorSignupScreenState extends State<MentorSignupScreen> {
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
  int mentorSlots = 2;

  List<String> skillsets = [
    'coding',
    'analytics',
    'presenting',
    'communication',
    'finance',
    'networking',
    'managing up',
  ];

  List<String> hobbies = [
    'sports',
    'coding',
    'video games',
    'painting',
    'drawing',
    'robotics',
    'volunteering',
    'crafts',
    'travel'
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

  void _incrementCounter() {
    if (mentorSlots < 4) {
      setState(() {
        mentorSlots++;
      });
    }
  }

  void _decrementCounter() {
    if (mentorSlots > 2) {
      setState(() {
        mentorSlots--;
      });
    }
  }

  buildCounterWidget() {
    return Center(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FloatingActionButton(
          onPressed: _decrementCounter,
          child: Icon(
            Icons.remove,
            size: 40,
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.blue,
          tooltip: 'Decrement',
        ),
        SizedBox(width: 25),
        Text(
          '$mentorSlots',
          style: TextStyle(fontSize: 80.0),
        ),
        SizedBox(width: 25),
        FloatingActionButton(
          onPressed: _incrementCounter,
          child: Icon(
            Icons.add,
            size: 40,
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.blue,
          tooltip: 'Increment',
        ),
      ],
    ));
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
                  'Please list the top 3 skill sets you can mentor on',
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
          'Skills',
          style: TextStyle(
            fontSize: 15,
          ),
        ),
        isActive: currentStep == 0 ? true : false,
        // state: currentStep == 0
        //     ? StepState.editing
        //     : ((trait1 != null) & (trait2 != null) & (trait3 != null))
        //         ? StepState.complete
        //         : StepState.error,
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
        // state: currentStep == 1
        //     ? StepState.editing
        //     : ((hobby1 != null) & (hobby2 != null) & (hobby3 != null))
        //         ? StepState.complete
        //         : StepState.error,
        content: Column(
          children: [buildHobbiesForm()],
        ),
      ),
      Step(
        title: const Text(
          'X-Factor',
          style: TextStyle(
            fontSize: 15,
          ),
        ),
        isActive: currentStep == 2 ? true : false,
        // state: currentStep == 2
        //     ? StepState.editing
        //     : makesMeGreatController.text != ''
        //         ? StepState.complete
        //         : StepState.error,
        content: Column(
          children: [
            Text(
              'What makes you a great mentor?',
              style: Theme.of(context).textTheme.headline4,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 15),
            buildFormField(
              hintString: 'I would make a great mentor because...',
              traitController: makesMeGreatController,
              minLines: 7,
            ),
          ],
        ),
      ),
      Step(
        title: const Text(
          'Slots',
          style: TextStyle(
            fontSize: 15,
          ),
        ),
        isActive: currentStep == 3 ? true : false,
        // state: currentStep == 3
        //     ? StepState.editing
        //     : makesMeGreatController.text != ''
        //         ? StepState.complete
        //         : StepState.error,
        content: Column(
          children: [
            Text(
              'How many mentees are you willing to mentor this cycle?',
              style: Theme.of(context).textTheme.headline4,
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 35),
              child: Text(
                'Recommended: 2',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.headline3.color),
                textAlign: TextAlign.center,
              ),
            ),
            buildCounterWidget(),
          ],
        ),
      ),
    ];
    setState(() => this.steps = steps);
    return steps;
  }

  Future<void> _updateMentoringAttributes(
    BuildContext context,
  ) async {
    try {
      await usersRef.doc(loggedInUser.id).update({
        "Mentor Attribute 1": trait1,
        "Mentor Attribute 2": trait2,
        "Mentor Attribute 3": trait3,
        "Mtr Hobby 1": hobby1,
        "Mtr Hobby 2": hobby2,
        "Mtr Hobby 3": hobby3,
        "XFactor": makesMeGreatController.text,
      });
      await usersRef.doc(loggedInUser.id).update({
        "Mentor": true,
        "Mentor Slots": mentorSlots,
      });
      // re-fetch loggedInUser info to set Mentor status to true
      loggedInUser =
          myUser.fromDocument(await usersRef.doc(loggedInUser.id).get());
    } on FirebaseException catch (e) {
      showAlertDialog(context,
          title: 'Operation Failed', content: '$e', defaultActionText: 'Ok');
    }
  }

  next() {
    if (currentStep + 1 != steps.length) {
      goTo(currentStep + 1);
    } else if ((trait1 != null) &
        (trait2 != null) &
        (trait3 != null) &
        (hobby1 != null) &
        (hobby2 != null) &
        (hobby3 != null) &
        (makesMeGreatController.text != '')) {
      setState(() => complete = true);
      _updateMentoringAttributes(context);
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMentorXPrimary,
        elevation: 5,
        title: Text('Mentor Sign Up Questionnaire'),
      ),
      body: Column(
        children: [
          complete
              ? Expanded(
                  child: Center(
                    child: AlertDialog(
                      backgroundColor: Colors.grey[200],
                      title: Text(
                        'Success! Thank you for enrolling as a Mentor!',
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
                    type: StepperType.vertical,
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
