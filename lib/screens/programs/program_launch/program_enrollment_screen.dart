import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/models/program.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/home_screen/home_screen.dart';
import 'package:mentorx_mvp/screens/programs/program_launch/program_overview_screen.dart';
import '../../../components/progress.dart';
import '../../../components/rounded_button.dart';
import '../../launch_screen.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');

class ProgramEnrollmentScreen extends StatefulWidget {
  final myUser loggedInUser;
  final String programUID;

  const ProgramEnrollmentScreen({
    Key key,
    this.loggedInUser,
    this.programUID,
  }) : super(key: key);

  static const String id = 'program_enrollment_screen';

  @override
  _ProgramEnrollmentScreenState createState() =>
      _ProgramEnrollmentScreenState();
}

class _ProgramEnrollmentScreenState extends State<ProgramEnrollmentScreen> {
  @override
  void initState() {
    super.initState();
  }

  _confirmLeaveScreen(parentContext, programUID) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Center(
              child: Text(
                'Confirm Leaving Program',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: Colors.black54,
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
                            'Are you sure you want to leave the program?',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
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
                      title: 'Yes',
                      buttonColor: kMentorXPSecondary,
                      fontColor: Colors.white,
                      minWidth: 150,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      onPressed: () => _leaveProgram(programUID),
                    ),
                  ),
                  SimpleDialogOption(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: RoundedButton(
                      title: 'Cancel',
                      buttonColor: Colors.grey,
                      fontColor: Colors.white,
                      minWidth: 150,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 10.0, right: 10.0, top: 0.0),
                child: Text(
                  'You will lose all program-related mentoring information',
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

  _leaveProgram(programUID) {
    usersRef
        .doc(loggedInUser.id)
        .collection('enrolledPrograms')
        .doc(programUID)
        .delete();
    programsRef
        .doc(programUID)
        .collection('userSubscribed')
        .doc(loggedInUser.id)
        .delete();
    programsRef
        .doc(programUID)
        .collection('mentors')
        .doc(loggedInUser.id)
        .delete();
    programsRef
        .doc(programUID)
        .collection('mentees')
        .doc(loggedInUser.id)
        .delete();
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            loggedInUser: loggedInUser,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
        future: programsRef.doc(widget.programUID).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }

          Program program = Program.fromDocument(snapshot.data);

          return FutureBuilder<Object>(
              future: usersRef.doc(loggedInUser.id).get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return circularProgress();
                }

                return Scaffold(
                  appBar: AppBar(
                    elevation: 5,
                    backgroundColor: kMentorXPPrimary,
                    title: Image.asset(
                      'assets/images/MentorXP.png',
                      height: 100,
                    ),
                  ),
                  body: SingleChildScrollView(
                    child: Container(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 10.0,
                              bottom: 10.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Column(
                                    children: [
                                      program.programLogo == null ||
                                              program.programLogo.isEmpty ||
                                              program.programLogo == ""
                                          ? Image.asset(
                                              'assets/images/MXPDark.png',
                                              height: 150,
                                              fit: BoxFit.cover,
                                            )
                                          : CachedNetworkImage(
                                              imageUrl: program.programLogo,
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                height: 150.0,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              placeholder: (context, url) =>
                                                  circularProgress(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Image.asset(
                                                'assets/images/MXPDark.png',
                                                height: 150,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                      Container(
                                        width: 300,
                                        child: Row(
                                          children: [
                                            Flexible(
                                              child: Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10.0),
                                                  child: Text(
                                                    '${program.programName}',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            thickness: 2,
                            color: Colors.grey,
                            indent: 20,
                            endIndent: 20,
                          ),
                          ButtonCard(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProgramOverview(
                                    programId: program.id,
                                    loggedInUser: loggedInUser,
                                  ),
                                ),
                              );
                            },
                            buttonCardText: 'Program Overview',
                            buttonCardTextSize: 25,
                            buttonCardRadius: 20,
                            buttonCardIcon: Icons.info,
                            buttonCardIconSize: 40,
                            buttonCardIconColor: kMentorXPSecondary,
                          ),
                          ButtonCard(
                            buttonCardText: 'Leave Program',
                            buttonCardTextSize: 25,
                            buttonCardRadius: 20,
                            buttonCardIcon: Icons.exit_to_app,
                            buttonCardIconSize: 40,
                            buttonCardIconColor: kMentorXPSecondary,
                            onPressed: () =>
                                _confirmLeaveScreen(context, program.id),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        });
  }
}

class ButtonCard extends StatelessWidget {
  const ButtonCard({
    Key key,
    @required this.buttonCardText,
    this.onPressed,
    this.buttonCardIcon,
    this.buttonCardIconSize,
    this.buttonCardIconColor,
    this.buttonCardRadius,
    this.buttonCardTextSize,
    this.buttonCardColor,
    this.buttonCardTextColor,
    this.cardWidthPercent,
    this.cardAlignment,
    this.cardIconBool,
    this.iconPadding,
    this.buttonCardHeight,
  }) : super(key: key);

  final String buttonCardText;
  final Function onPressed;
  final IconData buttonCardIcon;
  final double buttonCardIconSize;
  final Color buttonCardIconColor;
  final double buttonCardRadius;
  final double buttonCardTextSize;
  final Color buttonCardColor;
  final Color buttonCardTextColor;
  final double cardWidthPercent;
  final MainAxisAlignment cardAlignment;
  final Container cardIconBool;
  final EdgeInsets iconPadding;
  final double buttonCardHeight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: GestureDetector(
        onTap: onPressed ?? () {},
        child: Container(
          height: buttonCardHeight ?? 80,
          width: MediaQuery.of(context).size.width * (cardWidthPercent ?? .95),
          child: Card(
            elevation: 10,
            color: buttonCardColor ?? Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(buttonCardRadius ?? 50),
            ),
            child: Row(
              mainAxisAlignment: cardAlignment ?? MainAxisAlignment.start,
              children: [
                cardIconBool ??
                    Padding(
                      padding: iconPadding ??
                          EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Icon(
                        buttonCardIcon ?? Icons.school,
                        size: buttonCardIconSize ?? 40,
                        color: buttonCardIconColor ?? Colors.pink,
                      ),
                    ),
                Text(
                  buttonCardText ?? '',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: buttonCardTextSize ?? 20,
                    fontWeight: FontWeight.w500,
                    color: buttonCardTextColor ?? Colors.black45,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
