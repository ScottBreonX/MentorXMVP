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
  TextEditingController traitOneController = TextEditingController();
  TextEditingController traitTwoController = TextEditingController();
  TextEditingController traitThreeController = TextEditingController();
  TextEditingController hobbyOneController = TextEditingController();
  TextEditingController hobbyTwoController = TextEditingController();
  TextEditingController hobbyThreeController = TextEditingController();
  TextEditingController makesMeGreatController = TextEditingController();
  List<Step> steps;
  int currentStep = 0;
  bool complete = false;

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
            buildFormField(
              hintString: 'Skill set 1...',
              icon: Icons.looks_one,
              traitController: traitOneController,
            ),
            SizedBox(height: 10),
            buildFormField(
              hintString: 'Skill set 2...',
              icon: Icons.looks_two,
              traitController: traitTwoController,
            ),
            SizedBox(height: 10),
            buildFormField(
              hintString: 'Skill set 3...',
              icon: Icons.looks_3,
              traitController: traitThreeController,
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
            buildFormField(
              hintString: 'Hobby 1...',
              icon: Icons.looks_one,
              traitController: hobbyOneController,
            ),
            SizedBox(height: 10),
            buildFormField(
              hintString: 'Hobby 2...',
              icon: Icons.looks_two,
              traitController: hobbyTwoController,
            ),
            SizedBox(height: 10),
            buildFormField(
              hintString: 'Hobby 3...',
              icon: Icons.looks_3,
              traitController: hobbyThreeController,
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
            : ((traitOneController.text != '') &
                    (traitTwoController.text != '') &
                    (traitThreeController.text != ''))
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
            : ((traitOneController.text != '') &
                    (traitTwoController.text != '') &
                    (traitThreeController.text != ''))
                ? StepState.complete
                : StepState.error,
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
        state: currentStep == 2
            ? StepState.editing
            : ((traitOneController.text != '') &
                    (traitTwoController.text != '') &
                    (traitThreeController.text != ''))
                ? StepState.complete
                : StepState.error,
        content: Column(
          children: [
            buildFormField(
              hintString: 'I would make a great mentor because...',
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

  Future<void> _updateMentoringAttributes(
    BuildContext context,
  ) async {
    try {
      await mentorsRef.doc(loggedInUser.id).set({
        "Mentor Attribute 1": traitOneController.text,
        "Mentor Attribute 2": traitTwoController.text,
        "Mentor Attribute 3": traitThreeController.text,
        "Hobby 1": hobbyOneController.text,
        "Hobby 2": hobbyTwoController.text,
        "Hobby 3": hobbyThreeController.text,
        "XFactor": makesMeGreatController.text,
      });
      await usersRef.doc(loggedInUser.id).update({
        "Mentor": true,
      });
      // re-fetch loggedInUser info to set Mentor status to true
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
    } else if ((traitOneController.text != '') &
        (traitTwoController.text != '') &
        (traitThreeController.text != '') &
        (hobbyOneController.text != '') &
        (hobbyTwoController.text != '') &
        (hobbyThreeController.text != '') &
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
    print(currentStep);
    print(steps.length);
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
                      title: Text('Mentor Questionnaire Completed!'),
                      content: Text('Thank you!'),
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
