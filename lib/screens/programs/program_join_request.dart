import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:mentorx_mvp/models/program.dart';
import 'package:mentorx_mvp/screens/launch_screen.dart';
import 'package:mentorx_mvp/screens/mentoring/mentoring_screen.dart';

class ProgramJoinRequest extends StatefulWidget {
  static String id = 'program_join_request';
  final loggedInUser;
  final program;

  const ProgramJoinRequest({
    this.loggedInUser,
    this.program,
  });

  @override
  _ProgramJoinRequestState createState() => _ProgramJoinRequestState();
}

class _ProgramJoinRequestState extends State<ProgramJoinRequest> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController codeController = TextEditingController();
  String programCode;
  bool hasRequested = false;
  bool hasJoined = false;

  @override
  void initState() {
    super.initState();
    // checkHasRequested();
    checkHasJoined();
  }

  // for use when turning "request to join" feature on
  // checkHasRequested() async {
  //   DocumentSnapshot doc = await programsRef
  //       .doc(widget.program.id)
  //       .collection('userRequested')
  //       .doc(loggedInUser.id)
  //       .get();
  //   setState(() {
  //     hasRequested = doc.exists;
  //   });
  // }

  checkHasJoined() async {
    DocumentSnapshot doc = await programsRef
        .doc(widget.program.id)
        .collection('userSubscribed')
        .doc(loggedInUser.id)
        .get();
    setState(() {
      hasJoined = doc.exists;
    });
  }

  Widget build(BuildContext context) {
    final Program _program = widget.program;

    clearCode() {
      codeController.clear();
      setState(() {
        programCode = null;
      });
    }

    handleCode(String code) {
      String _code = code;
      setState(() {
        programCode = _code;
      });
    }

    // Container buildButton({String text, Function function}) {
    //   return Container(
    //     padding: EdgeInsets.only(top: 2.0),
    //     child: RoundedButton(
    //       onPressed: function,
    //       title: text,
    //       buttonColor: hasRequested
    //           ? Colors.grey
    //           : Theme.of(context).buttonTheme.colorScheme.primary,
    //       fontColor: hasRequested
    //           ? Colors.grey[700]
    //           : Theme.of(context).textTheme.button.color,
    //       fontSize: 20,
    //       minWidth: MediaQuery.of(context).size.width * 0.77,
    //     ),
    //   );
    // }

    Container buildButton({String text, Function function}) {
      return Container(
        padding: EdgeInsets.only(top: 2.0),
        child: RoundedButton(
          onPressed: function,
          title: text,
          buttonColor: hasJoined
              ? Colors.grey
              : Theme.of(context).buttonTheme.colorScheme.primary,
          fontColor: hasJoined
              ? Colors.grey[700]
              : Theme.of(context).textTheme.button.color,
          fontSize: 20,
          minWidth: MediaQuery.of(context).size.width * 0.77,
        ),
      );
    }

    // enable for request to join feature
    // requestJoin() {
    //   handleCode(codeController.text);
    //   if (programCode == _program.programCode) {
    //     setState(() {
    //       hasRequested = true;
    //     });
    //     programsRef
    //         .doc(widget.program.id)
    //         .collection('userRequested')
    //         .doc(loggedInUser.id)
    //         .set({});
    //   } else {
    //     showDialog(
    //       context: context,
    //       builder: (_) => AlertDialog(
    //         title:
    //             Text('The program code does not match. \n Please try again.'),
    //         actions: [
    //           TextButton(
    //             child: Text(
    //               "Okay",
    //               style: TextStyle(
    //                 fontSize: 18,
    //                 fontWeight: FontWeight.bold,
    //               ),
    //             ),
    //             onPressed: () => Navigator.pop(context),
    //           ),
    //         ],
    //       ),
    //       barrierDismissible: true,
    //     );
    //   }
    // }

    joinProgram() {
      handleCode(codeController.text);
      if (programCode == _program.programCode) {
        setState(() {
          hasJoined = true;
        });
        programsRef
            .doc(widget.program.id)
            .collection('userSubscribed')
            .doc(loggedInUser.id)
            .set({});
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Congratulations! You have signed up for the \ '
                '${_program.programName} mentorship program. You should now \ '
                'head to your program landing page and select your role in \ '
                'the program.'),
            actions: [
              TextButton(
                child: Text('Go There Now!'),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    maintainState: false,
                    builder: (context) => MentoringScreen(),
                  ),
                ),
              )
            ],
          ),
          barrierDismissible: true,
        );
      } else {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title:
                Text('The program code does not match. \n Please try again.'),
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

    // buildRequestButton() {
    //   if (hasRequested == false) {
    //     return buildButton(
    //       text: 'Request to Join',
    //       function: requestJoin,
    //     );
    //   } else if (hasRequested == true) {
    //     return buildButton(
    //       text: 'Join Requested',
    //       function: null,
    //     );
    //   }
    // }

    buildJoinButton() {
      if (hasJoined == false) {
        return buildButton(
          text: 'Join the Program',
          function: joinProgram,
        );
      } else if (hasJoined == true) {
        return buildButton(
          text: 'You have joined!',
          function: null,
        );
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 5,
        title: Text('Join ${_program.programName}'),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.monetization_on,
                size: 150,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Join ${_program.institutionName}\'s \n '
                    '${_program.programName} Program',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.headline4.color,
                    ),
                  ),
                  SizedBox(height: 35),
                  // !hasRequested
                  !hasJoined
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Enter program code:',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color:
                                    Theme.of(context).textTheme.headline4.color,
                              ),
                            ),
                            SizedBox(height: 5),
                            TextFormField(
                              style: Theme.of(context).textTheme.subtitle2,
                              key: formKey,
                              controller: codeController,
                              decoration: InputDecoration(
                                hintText: 'ENTER PROGRAM CODE',
                                hintStyle:
                                    Theme.of(context).textTheme.subtitle2,
                                filled: true,
                                fillColor: Colors.white,
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.clear),
                                  onPressed: clearCode,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Text(
                          'You have joined the program!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                ],
              ),
              SizedBox(height: 10),
              Expanded(
                child: Column(
                  children: [
                    // buildRequestButton(),
                    buildJoinButton(),
                    // !hasRequested
                    !hasJoined
                        ? RoundedButton(
                            onPressed: () => Navigator.pop(context),
                            title: 'Cancel',
                            buttonColor: Theme.of(context)
                                .buttonTheme
                                .colorScheme
                                .background,
                            fontColor:
                                Theme.of(context).textTheme.headline3.color,
                            fontSize: 20,
                            borderColor: Theme.of(context).colorScheme.primary,
                            borderWidth: 5,
                            minWidth: MediaQuery.of(context).size.width * 0.77,
                          )
                        : SizedBox(height: 0),
                  ],
                ),
              ),
              Divider(
                thickness: 8,
                color: Theme.of(context).dividerColor,
              ),
              Text(
                'Don\'t have a code? Contact your program administrator.',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).textTheme.headline4.color,
                ),
              ),
              // uncomment the text below to add in a box containing the
              // program admin's name for contact purposes
              // Container(
              //   alignment: Alignment.center,
              //   decoration: BoxDecoration(
              //     color: Colors.grey,
              //   ),
              //   child: Padding(
              //     padding: const EdgeInsets.symmetric(
              //       horizontal: 8,
              //       vertical: 8,
              //     ),
              //     child: Text(
              //       '${_program.headAdmin}',
              //       style: TextStyle(fontSize: 20, color: Colors.white70),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
