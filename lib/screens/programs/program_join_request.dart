import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:mentorx_mvp/models/program.dart';
import 'package:mentorx_mvp/screens/launch_screen.dart';

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

    joinProgram() async {
      handleCode(codeController.text);
      if (programCode == _program.programCode) {
        setState(() {
          hasJoined = true;
        });
        await programsRef
            .doc(widget.program.id)
            .collection('userSubscribed')
            .doc(loggedInUser.id)
            .set({});
        await usersRef
            .doc(loggedInUser.id)
            .collection('enrolledPrograms')
            .doc(widget.program.id)
            .set({});
        showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Center(
                child: Column(
                  children: [
                    // You should now "
                    // "\ head to your program landing page and select your role in "
                    //     "\ the program.",
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Success!",
                        style: TextStyle(
                          fontFamily: 'Work Sans',
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Text(
                        "You have signed up for ${_program.programName}",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: 'Work Sans',
                          fontSize: 20,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Text(
                        "Head to your program landing page to finish enrollment",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: 'Work Sans',
                          fontSize: 20,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RoundedButton(
                        minWidth: 200,
                        title: "OK",
                        buttonColor: Colors.blue,
                        fontColor: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        onPressed: () => Navigator.pop(context),
                      ),
                    )
                  ],
                ),
              ],
            );
          },
        );
        // showDialog(
        //   context: context,
        //   builder: (_) => AlertDialog(
        //     title: Text('Congratulations! You have signed up for the \ '
        //         '${_program.programName} mentorship program. You should now \ '
        //         'head to your program landing page and select your role in \ '
        //         'the program.'),
        //     actions: [
        //       TextButton(
        //         child: Text('Go There Now!'),
        //         onPressed: () => Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //             maintainState: false,
        //             builder: (context) => MentoringScreen(),
        //           ),
        //         ),
        //       )
        //     ],
        //   ),
        //   barrierDismissible: true,
        // );
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return SimpleDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Center(
                  child: Text(
                    "The program code does not match. \n\nPlease try again.",
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RoundedButton(
                          minWidth: 130,
                          title: "OK",
                          buttonColor: Colors.blue,
                          fontColor: Colors.white,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      )
                    ],
                  ),
                ],
              );
            });
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
        title: Image.asset(
          'assets/images/MentorPinkWhite.png',
          height: 150,
        ),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: _program.programLogo == null ||
                        _program.programLogo.isEmpty ||
                        _program.programLogo == ""
                    ? Image.asset(
                        'assets/images/MLogoPink.png',
                        height: 150,
                        width: 150,
                        fit: BoxFit.fill,
                      )
                    : CachedNetworkImage(
                        imageUrl: _program.programLogo,
                        imageBuilder: (context, imageProvider) => Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Image.asset(
                          'assets/images/MLogoPink.png',
                          height: 150,
                          width: 150,
                          fit: BoxFit.fill,
                        ),
                      ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '${_program.programName}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
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
                              'Enter the program code:',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color:
                                    Theme.of(context).textTheme.headline4.color,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: TextFormField(
                                style: Theme.of(context).textTheme.subtitle2,
                                key: formKey,
                                controller: codeController,
                                decoration: InputDecoration(
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
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 25.0),
                child: Text(
                  'Don\'t have a code? Contact the program administrator.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).textTheme.headline4.color,
                  ),
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
