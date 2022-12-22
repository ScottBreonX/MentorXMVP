import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/models/match_model.dart';
import 'package:mentorx_mvp/models/program.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/programs/program_launch/program_launch_screen.dart';
import '../../../components/progress.dart';
import '../../../components/rounded_button.dart';
import '../../launch_screen.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');

class MentoringLaunchManage extends StatefulWidget {
  final myUser loggedInUser;
  final String programUID;
  final myUser mentorUser;

  const MentoringLaunchManage({
    Key key,
    this.loggedInUser,
    this.programUID,
    this.mentorUser,
  }) : super(key: key);

  static const String id = 'mentoring_launch_manage_screen';

  @override
  _MentoringLaunchManageState createState() => _MentoringLaunchManageState();
}

_confirmRemoveMatch(parentContext, mentorFname, mentorLname, programUID,
    mentorUID, matchID, mentorSlots) {
  return showDialog(
      context: parentContext,
      builder: (context) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Center(
            child: Text(
              'Confirm Removing Match',
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
                          'Are you sure you want to remove $mentorFname $mentorLname as a mentor connection?',
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
                    title: 'Yes',
                    buttonColor: kMentorXPSecondary,
                    fontColor: Colors.white,
                    minWidth: 120,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    onPressed: () {
                      _removeMatch(
                          context, programUID, mentorUID, matchID, mentorSlots);
                    },
                  ),
                ),
                SimpleDialogOption(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: RoundedButton(
                    title: 'Cancel',
                    buttonColor: Colors.white,
                    fontColor: kMentorXPSecondary,
                    minWidth: 120,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 0.0),
              child: Text(
                'You will lose all related mentoring information',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'WorkSans',
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

_removeMatch(context, programUID, mentorUID, matchID, mentorSlots) async {
  //remove match from loggedInUser collection
  await programsRef
      .doc(programUID)
      .collection('userSubscribed')
      .doc(loggedInUser.id)
      .collection('matches')
      .doc(mentorUID)
      .delete();
  //remove match from other match's collection
  await programsRef
      .doc(programUID)
      .collection('userSubscribed')
      .doc(mentorUID)
      .collection('matches')
      .doc(loggedInUser.id)
      .delete();

  //remove match from programs collection
  await programsRef
      .doc(programUID)
      .collection('matchedPairs')
      .doc(matchID)
      .delete();

  //add back mentor slot to mentor
  await programsRef
      .doc(programUID)
      .collection('mentors')
      .doc(mentorUID)
      .update({"mentorSlots": mentorSlots + 1});

  Navigator.pop(context);
  Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ProgramLaunchScreen(
          programUID: programUID,
        ),
      ));
}

class _MentoringLaunchManageState extends State<MentoringLaunchManage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
        future: programsRef
            .doc(widget.programUID)
            .collection('userSubscribed')
            .doc(loggedInUser.id)
            .collection('matches')
            .doc(widget.mentorUser.id)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }

          MatchModel matchInfo = MatchModel.fromDocument(snapshot.data);

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

                      return FutureBuilder<Object>(
                          future: programsRef
                              .doc(program.id)
                              .collection('mentors')
                              //need to dynamically generate who is mentor and who is mentee
                              .doc(widget.mentorUser.id)
                              .get(),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0),
                                              child: Column(
                                                children: [
                                                  program.programLogo == null ||
                                                          program.programLogo
                                                              .isEmpty ||
                                                          program.programLogo ==
                                                              ""
                                                      ? Image.asset(
                                                          'assets/images/MXPDark.png',
                                                          height: 150,
                                                          fit: BoxFit.cover,
                                                        )
                                                      : CachedNetworkImage(
                                                          imageUrl: program
                                                              .programLogo,
                                                          imageBuilder: (context,
                                                                  imageProvider) =>
                                                              Container(
                                                            height: 100.0,
                                                            width: 100,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12),
                                                              image:
                                                                  DecorationImage(
                                                                image:
                                                                    imageProvider,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                          placeholder: (context,
                                                                  url) =>
                                                              circularProgress(),
                                                          errorWidget: (context,
                                                                  url, error) =>
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
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top:
                                                                          10.0),
                                                              child: Text(
                                                                '${program.programName}',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Montserrat',
                                                                  fontSize: 25,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Colors
                                                                      .black54,
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
                                        buttonCardText: 'Remove Match',
                                        buttonCardTextSize: 25,
                                        buttonCardRadius: 20,
                                        buttonCardIcon: Icons.remove_circle,
                                        buttonCardIconSize: 40,
                                        buttonCardIconColor: Colors.red,
                                        onPressed: () {
                                          _confirmRemoveMatch(
                                            context,
                                            widget.mentorUser.firstName,
                                            widget.mentorUser.lastName,
                                            widget.programUID,
                                            widget.mentorUser.id,
                                            matchInfo.matchID,
                                            // mentor.mentorSlots,
                                            2,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    });
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: GestureDetector(
        onTap: onPressed ?? () {},
        child: Container(
          height: 80,
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
                        )),
                Text(
                  buttonCardText ?? '',
                  style: TextStyle(
                    fontFamily: 'WorkSans',
                    fontSize: buttonCardTextSize ?? 20,
                    fontWeight: FontWeight.w600,
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
