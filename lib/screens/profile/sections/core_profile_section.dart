import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../components/alert_dialog.dart';
import '../../../components/icon_circle.dart';
import 'package:mentorx_mvp/models/user.dart';

import '../profile_screen.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');

class CoreProfileSection extends StatefulWidget {
  final myUser loggedInUser;
  final String programImport;
  final String fNameImport;
  final String lNameImport;
  final String profileId;
  final bool myProfileView;

  const CoreProfileSection({
    @required this.fNameImport,
    @required this.lNameImport,
    @required this.programImport,
    @required this.loggedInUser,
    @required this.profileId,
    @required this.myProfileView,
  });

  @override
  _CoreProfileSectionState createState() => _CoreProfileSectionState();
}

class _CoreProfileSectionState extends State<CoreProfileSection> {
  @override
  void initState() {
    coreProfileEditStatus = false;
    super.initState();
  }

  bool coreProfileEditStatus;
  String firstNameText;
  String lastNameText;
  String majorText;
  String schoolYearText;
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  Future<void> _updateCoreProfile(String userID, String programID) async {
    try {
      if (firstNameText != null) {
        await usersRef.doc(userID).update({
          "First Name": firstNameText,
        });
        if (programID == "" || programID == null) {
        } else {
          await programsRef
              .doc(programID)
              .collection('mentors')
              .doc(userID)
              .get()
              .then((doc) => {
                    if (doc.exists)
                      {
                        programsRef
                            .doc(programID)
                            .collection('mentors')
                            .doc(userID)
                            .update({
                          "First Name": firstNameText,
                        })
                      }
                  });
          await programsRef
              .doc(programID)
              .collection('mentees')
              .doc(userID)
              .get()
              .then((doc) => {
                    if (doc.exists)
                      {
                        programsRef
                            .doc(programID)
                            .collection('mentees')
                            .doc(userID)
                            .update({
                          "First Name": firstNameText,
                        })
                      }
                  });
        }
      }
      if (lastNameText != null) {
        await usersRef.doc(userID).update({
          "Last Name": lastNameText,
        });
        if (programID == "" || programID == null) {
        } else {
          await programsRef
              .doc(programID)
              .collection('mentors')
              .doc(userID)
              .get()
              .then((doc) => {
                    if (doc.exists)
                      {
                        programsRef
                            .doc(programID)
                            .collection('mentors')
                            .doc(userID)
                            .update({
                          "Last Name": lastNameText,
                        })
                      }
                  });
          await programsRef
              .doc(programID)
              .collection('mentees')
              .doc(userID)
              .get()
              .then((doc) => {
                    if (doc.exists)
                      {
                        programsRef
                            .doc(programID)
                            .collection('mentees')
                            .doc(userID)
                            .update({
                          "Last Name": lastNameText,
                        })
                      }
                  });
        }
      }
    } on FirebaseException catch (e) {
      showAlertDialog(context,
          title: 'Operation Failed', content: '$e', defaultActionText: 'Ok');
    }
    if (this.mounted) {
      setState(() {
        coreProfileEditStatus = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        coreProfileEditStatus
            ? Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 8.0,
                              bottom: 10.0,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                _updateCoreProfile(
                                    widget.profileId, widget.programImport);
                                Navigator.pushReplacement(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (context, animation1, animation2) =>
                                            Profile(
                                      profileId: widget.profileId,
                                      loggedInUser: widget.loggedInUser,
                                    ),
                                    transitionDuration: Duration.zero,
                                    reverseTransitionDuration: Duration.zero,
                                  ),
                                );
                              },
                              child: Material(
                                elevation: 5,
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: kMentorXPSecondary,
                                  ),
                                  height: 40.0,
                                  width: 40.0,
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 8.0, bottom: 10.0),
                            child: GestureDetector(
                              onTap: () {
                                if (this.mounted) {
                                  setState(() {
                                    coreProfileEditStatus = false;
                                  });
                                }
                              },
                              child: Material(
                                elevation: 5,
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                  ),
                                  height: 40.0,
                                  width: 40.0,
                                  child: Icon(
                                    Icons.close,
                                    color: kMentorXPSecondary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        coreProfileTextField(
                          widget.loggedInUser,
                          _formKey1,
                          widget.fNameImport,
                          "First Name",
                          (value) => firstNameText = value,
                        ),
                        coreProfileTextField(
                          widget.loggedInUser,
                          _formKey2,
                          widget.lNameImport,
                          'Last Name',
                          (value) => lastNameText = value,
                        )
                      ],
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  widget.myProfileView
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 10.0,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  if (this.mounted) {
                                    setState(() {
                                      coreProfileEditStatus = true;
                                    });
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: IconCircle(
                                    width: 30.0,
                                    height: 30.0,
                                    iconType: Icons.edit,
                                    iconColor: kMentorXPAccentDark,
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      : Container(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Text(
                            "${widget.fNameImport} ${widget.lNameImport}",
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ],
    );
  }

  Expanded coreProfileTextField(myUser user, GlobalKey formKey,
      String initialValue, String hintText, Function onChanged) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                hintText,
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(10.0),
              child: TextFormField(
                key: formKey,
                initialValue: initialValue,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                cursorColor: Theme.of(context).indicatorColor,
                textAlign: TextAlign.start,
                onChanged: onChanged,
                style: Theme.of(context).textTheme.headlineLarge,
                autocorrect: false,
                decoration: kTextFieldDecoration.copyWith(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).cardColor, width: 1.0),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  alignLabelWithHint: true,
                  hintText: hintText,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  labelStyle: TextStyle(color: Colors.grey.shade400),
                  hintStyle:
                      TextStyle(color: Colors.grey.shade400, fontSize: 20),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: kMentorXPSecondary, width: 2.0),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
