import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/models/program.dart';
import 'package:mentorx_mvp/screens/launch_screen.dart';
import 'package:mentorx_mvp/screens/programs/program_launch/program_enrollment_screen.dart';
import 'package:mentorx_mvp/screens/programs/program_launch/program_launch_screen.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');

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
    checkHasJoined();
  }

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
        await programsRef
            .doc(widget.program.id)
            .collection('userSubscribed')
            .doc(loggedInUser.id)
            .update({
          'enrollmentStatus': '',
          'Profile Complete': false,
          'Enrollment Complete': false,
          'Guidelines Complete': false,
        });
        await usersRef.doc(loggedInUser.id).update({
          'Program': widget.program.id,
        });
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Success!",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                      child: Text(
                        "You have signed up for",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 20,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    Text(
                      "${_program.programName}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 20,
                        color: kMentorXPPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Text(
                        "Head to your program landing page to finish enrollment",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
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
                        buttonColor: kMentorXPAccentDark,
                        fontColor: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProgramLaunchScreen(
                                  programUID: _program.id,
                                  loggedInUser: loggedInUser,
                                ),
                              ));
                        },
                      ),
                    )
                  ],
                ),
              ],
            );
          },
        );
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
                    "The program code entered does not match. \n\nPlease try again.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 20,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
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
                          title: "Ok",
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          buttonColor: kMentorXPAccentDark,
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

    buildJoinButton() {
      if (hasJoined == false) {
        return ButtonCard(
          buttonCardText: 'Join the Program',
          buttonCardTextSize: 25,
          buttonCardTextColor: Colors.white,
          buttonCardColor: kMentorXPAccentDark,
          cardAlignment: MainAxisAlignment.center,
          cardIconBool: Container(),
          buttonCardRadius: 20,
          onPressed: joinProgram,
        );
      } else if (hasJoined == true) {
        return ButtonCard(
          buttonCardText: 'You have joined',
          buttonCardTextSize: 25,
          buttonCardTextColor: Colors.grey.shade600,
          buttonCardColor: Colors.grey,
          cardAlignment: MainAxisAlignment.center,
          cardIconBool: Container(),
          buttonCardRadius: 20,
          onPressed: null,
        );
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 5,
        backgroundColor: kMentorXPPrimary,
        title: Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 35.0, bottom: 10),
            child: Image.asset(
              'assets/images/MentorXP.png',
              fit: BoxFit.contain,
              height: 35,
            ),
          ),
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
                        'assets/images/MXPDark.png',
                        height: 150,
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
                          'assets/images/MXPDark.png',
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
                      fontFamily: 'Montserrat',
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                    child: Divider(
                      indent: 10,
                      endIndent: 10,
                      thickness: 2,
                      color: Theme.of(context).dividerColor,
                    ),
                  ),

                  // !hasRequested
                  !hasJoined
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Enter the program code:',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                color: Colors.black54,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 5.0,
                                      spreadRadius: 1,
                                    )
                                  ],
                                ),
                                child: TextFormField(
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontFamily: 'Montserrat',
                                    color: Colors.black54,
                                  ),
                                  key: formKey,
                                  controller: codeController,
                                  cursorColor: kMentorXPAccentDark,
                                  decoration: InputDecoration(
                                    filled: true,
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.transparent),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: kMentorXPAccentDark,
                                        width: 2,
                                      ),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        Icons.clear,
                                        color: kMentorXPAccentDark,
                                      ),
                                      onPressed: clearCode,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Text(
                          'You have joined the program',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 25,
                            fontFamily: 'Work Sans',
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                          ),
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
                        ? ButtonCard(
                            buttonCardText: 'Cancel',
                            onPressed: () => Navigator.pop(context),
                            buttonCardColor: Colors.white,
                            buttonCardTextColor: kMentorXPAccentDark,
                            buttonCardTextSize: 25,
                            buttonCardRadius: 20,
                            cardIconBool: Container(),
                            cardAlignment: MainAxisAlignment.center,
                          )
                        : SizedBox(height: 0),
                  ],
                ),
              ),
              Divider(
                thickness: 2,
                color: Theme.of(context).dividerColor,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 45.0),
                child: Text(
                  'Don\'t have a code? Contact the program administrator.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
