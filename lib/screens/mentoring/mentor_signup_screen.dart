import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mentorx_mvp/components/alert_dialog.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/launch_screen.dart';
import 'package:mentorx_mvp/screens/programs/program_launch/program_launch_screen.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');

class MentorSignupScreen extends StatefulWidget {
  final myUser loggedInUser;
  final String programUID;
  static const String id = 'mentoring_signup_screen_test';

  const MentorSignupScreen({
    this.loggedInUser,
    this.programUID,
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

  List<IconData> skillIcons = [
    Icons.code,
    Icons.numbers,
    FontAwesomeIcons.chalkboardTeacher,
    Icons.podcasts_rounded,
    Icons.monetization_on,
    Icons.people,
    Icons.swipe_up_alt_rounded,
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
    List iconItems,
    List listItems,
    final void Function(String) inputFunction,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      padding: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(
          color: kMentorXPSecondary,
          width: 3.0,
        ),
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.white,
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<String>(
            dropdownColor: Colors.white,
            value: inputValue,
            iconSize: 30,
            isExpanded: true,
            icon: Icon(Icons.arrow_drop_down, color: kMentorXPSecondary),
            items: listItems,
            onChanged: inputFunction,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 20,
              color: kMentorXPSecondary,
              fontWeight: FontWeight.bold,
            ),
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

  DropdownMenuItem<IconData> buildIconItem(IconData icon) => DropdownMenuItem(
        value: icon,
        child: Icon(
          icon,
          size: 10,
          color: kMentorXPSecondary,
        ),
      );

  buildFormField({
    String hintString,
    IconData icon,
    TextEditingController traitController,
    int minLines,
  }) {
    return TextFormField(
      style: TextStyle(
        color: Colors.black54,
        fontFamily: 'Montserrat',
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      controller: traitController,
      autocorrect: true,
      textCapitalization: TextCapitalization.sentences,
      minLines: minLines,
      maxLines: minLines == null ? 1 : minLines + 1,
      decoration: InputDecoration(
        hintText: hintString,
        hintStyle: TextStyle(
            color: Colors.grey.shade400, fontSize: 20, fontFamily: 'WorkSans'),
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: Colors.black54,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: kMentorXPSecondary,
            width: 3.0,
          ),
        ),
        fillColor: Colors.white,
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
    // bool slotSelection = false;

    return FutureBuilder<Object>(
        future: programsRef
            .doc(widget.programUID)
            .collection('mentors')
            .doc(loggedInUser.id)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          return Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FloatingActionButton(
                heroTag: 'decrement1',
                onPressed: _decrementCounter,
                child: Icon(
                  Icons.remove,
                  size: 40,
                ),
                backgroundColor: Colors.white,
                foregroundColor: kMentorXPSecondary,
                tooltip: 'Decrement',
              ),
              SizedBox(width: 25),
              Text(
                '$mentorSlots',
                style: TextStyle(fontSize: 80.0),
              ),
              SizedBox(width: 25),
              FloatingActionButton(
                heroTag: 'increment1',
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
        });
  }

  buildQuestionnaire() {
    return FutureBuilder<Object>(
        future: programsRef
            .doc(widget.programUID)
            .collection('mentors')
            .doc(loggedInUser.id)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          // Mentor mentorModel = Mentor.fromDocument(snapshot.data);

          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'What are the top 3 skill sets you can mentor on?',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                          fontSize: 20,
                        ),
                        // textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, top: 20.0, bottom: 10.0),
                    child: Row(
                      children: [
                        Text(
                          'Skill #1',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Colors.black54,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  buildDropdownField(
                    inputValue: trait1
                    // ?? mentorModel.mtrAtt1
                    ,
                    // iconItems: skillIcons.map(buildIconItem).toList(),
                    listItems: skillsets.map(buildMenuItem).toList(),
                    inputFunction: (trait1) =>
                        setState(() => this.trait1 = trait1),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, top: 20.0, bottom: 10.0),
                    child: Row(
                      children: [
                        Text(
                          'Skill #2',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Colors.black54,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  buildDropdownField(
                    inputValue: trait2
                    // ?? mentorModel.mtrAtt2
                    ,
                    listItems: skillsets.map(buildMenuItem).toList(),
                    inputFunction: (trait2) =>
                        setState(() => this.trait2 = trait2),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, top: 20.0, bottom: 10.0),
                    child: Row(
                      children: [
                        Text(
                          'Skill #3',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Colors.black54,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  buildDropdownField(
                    inputValue: trait3
                    // ?? mentorModel.mtrAtt3
                    ,
                    listItems: skillsets.map(buildMenuItem).toList(),
                    inputFunction: (trait3) =>
                        setState(() => this.trait3 = trait3),
                  ),
                ],
              ),
            ],
          );
        });
  }

  buildHobbiesForm() {
    return FutureBuilder<Object>(
        future: programsRef
            .doc(widget.programUID)
            .collection('mentors')
            .doc(loggedInUser.id)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          // Mentor mentorModel = Mentor.fromDocument(snapshot.data);
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'What are your top 3 hobbies or activities?',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, top: 20, bottom: 10.0),
                    child: Row(
                      children: [
                        Text(
                          'Hobby / Activity #1',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Colors.black54,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  buildDropdownField(
                    inputValue: hobby1
                    // ?? mentorModel.mtrHobby1
                    ,
                    listItems: hobbies.map(buildMenuItem).toList(),
                    inputFunction: (hobby1) =>
                        setState(() => this.hobby1 = hobby1),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, top: 20, bottom: 10.0),
                    child: Row(
                      children: [
                        Text(
                          'Hobby / Activity #2',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Colors.black54,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  buildDropdownField(
                    inputValue: hobby2
                    // ?? mentorModel.mtrHobby2
                    ,
                    listItems: hobbies.map(buildMenuItem).toList(),
                    inputFunction: (hobby2) =>
                        setState(() => this.hobby2 = hobby2),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, top: 20, bottom: 10.0),
                    child: Row(
                      children: [
                        Text(
                          'Hobby / Activity #3',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Colors.black54,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  buildDropdownField(
                    inputValue: hobby3
                    // ?? mentorModel.mtrHobby3
                    ,
                    listItems: hobbies.map(buildMenuItem).toList(),
                    inputFunction: (hobby3) =>
                        setState(() => this.hobby3 = hobby3),
                  ),
                ],
              ),
            ],
          );
        });
  }

  buildStepList(steps) {
    steps = [
      Step(
        title: const Text(
          'Skills',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            color: Colors.black54,
            fontSize: 25,
          ),
        ),
        isActive: currentStep == 0 ? true : false,
        content: Column(
          children: [buildQuestionnaire()],
        ),
      ),
      Step(
        title: const Text(
          'Hobbies',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            color: Colors.black54,
            fontSize: 25,
          ),
        ),
        isActive: currentStep == 1 ? true : false,
        content: Column(
          children: [buildHobbiesForm()],
        ),
      ),
      Step(
        title: const Text(
          'X-Factor',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            color: Colors.black54,
            fontSize: 25,
          ),
        ),
        isActive: currentStep == 2 ? true : false,
        content: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10, bottom: 20.0),
              child: Text(
                'What makes you a great mentor?',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black54,
                ),
              ),
            ),
            buildFormField(
              hintString: 'I would make a great mentor because...',
              traitController: makesMeGreatController,
              minLines: 10,
            ),
          ],
        ),
      ),
      Step(
        title: const Text(
          'Slots',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            color: Colors.black54,
            fontSize: 25,
          ),
        ),
        isActive: currentStep == 3 ? true : false,
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
                  color: kMentorXPSecondary,
                ),
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

  _enrollmentSuccess(parentContext, programUID) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Center(
              child: Text(
                'Enrollment Success',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: kMentorXPSecondary,
                ),
              ),
            ),
            children: <Widget>[
              SimpleDialogOption(
                padding: EdgeInsets.only(left: 10, right: 10, bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 250,
                      child: Column(
                        children: [
                          Text(
                            'Thank you for enrolling as a Mentor',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black45,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SimpleDialogOption(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: RoundedButton(
                      title: 'Continue',
                      buttonColor: kMentorXPSecondary,
                      fontColor: Colors.white,
                      minWidth: 200,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProgramLaunchScreen(
                              programUID: programUID,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 10.0, right: 10.0, top: 0.0),
                child: Text(
                  'Next Steps: Proceed to the launch screen and complete the required pre-read materials.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          );
        });
  }

  Future<void> _updateMentoringAttributes(
      BuildContext context, String programUID) async {
    try {
      await programsRef
          .doc(programUID)
          .collection('mentors')
          .doc(loggedInUser.id)
          .set({
        "Mentor Attribute 1": trait1,
        "Mentor Attribute 2": trait2,
        "Mentor Attribute 3": trait3,
        "Mtr Hobby 1": hobby1,
        "Mtr Hobby 2": hobby2,
        "Mtr Hobby 3": hobby3,
        "XFactor": makesMeGreatController.text,
        "mentorSlots": mentorSlots,
        "id": loggedInUser.id,
      });
      await programsRef
          .doc(programUID)
          .collection('userSubscribed')
          .doc(loggedInUser.id)
          .set({
        "enrollmentStatus": 'mentor',
      });
      loggedInUser =
          myUser.fromDocument(await usersRef.doc(loggedInUser.id).get());
    } on FirebaseException catch (e) {
      showAlertDialog(context,
          title: 'Operation Failed', content: '$e', defaultActionText: 'Ok');
    }
  }

  next() async {
    if (currentStep + 1 != steps.length) {
      goTo(currentStep + 1);
    } else if ((trait1 != null) &
        (trait2 != null) &
        (trait3 != null) &
        (hobby1 != null) &
        (hobby2 != null) &
        (hobby3 != null) &
        (makesMeGreatController.text != '')) {
      await _updateMentoringAttributes(context, widget.programUID);
      print('successful update');
      _enrollmentSuccess(context, widget.programUID);
    } else {
      showDialog(
        context: context,
        builder: (_) => SimpleDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Center(
            child: Text(
              'Questionnaire Incomplete',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 20,
                color: Colors.blue,
              ),
            ),
          ),
          children: <Widget>[
            SimpleDialogOption(
              padding:
                  EdgeInsets.only(left: 5, right: 5, bottom: 10.0, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 250,
                    child: Column(
                      children: [
                        Text(
                          'Please fill in entire questionnaire.',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 20,
                            color: Colors.black45,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SimpleDialogOption(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: RoundedButton(
                    title: 'Ok',
                    buttonColor: kMentorXPSecondary,
                    fontColor: Colors.white,
                    minWidth: 200,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
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
        backgroundColor: kMentorXPPrimary,
        elevation: 5,
        title: Text('Mentor Sign Up'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stepper(
              controlsBuilder: (context, details) {
                return Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: RoundedButton(
                          title: 'Next',
                          buttonColor: kMentorXPSecondary,
                          fontColor: Colors.white,
                          onPressed: next,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          borderRadius: 12,
                          minWidth: 120,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: RoundedButton(
                          title: 'Back',
                          buttonColor: Colors.white,
                          fontColor: kMentorXPSecondary,
                          onPressed: cancel,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          borderRadius: 12,
                          minWidth: 120,
                        ),
                      ),
                    ],
                  ),
                );
              },
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
