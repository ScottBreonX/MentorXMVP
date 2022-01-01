import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../components/progress.dart';
import '../../../constants.dart';
import '../../../components/alert_dialog.dart';
import '../../../components/icon_circle.dart';
import '../../../models/user.dart';
import '../../launch_screen.dart';

class ProfileMentorSection extends StatefulWidget {
  const ProfileMentorSection({
    this.profileId,
    @required this.myProfileView,
    Key key,
  });

  final String profileId;
  final bool myProfileView;

  @override
  _ProfileMentorSectionState createState() => _ProfileMentorSectionState();
}

class _ProfileMentorSectionState extends State<ProfileMentorSection> {
  @override
  void initState() {
    mentorEditStatus = false;
    super.initState();
  }

  bool mentorEditStatus;
  String mentorText;
  final _formKey1 = GlobalKey<FormState>();

  TextFormField _buildMentorTextField(String userMentorText) {
    return TextFormField(
      key: _formKey1,
      initialValue: userMentorText,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      textAlign: TextAlign.start,
      onChanged: (value) => mentorText = value,
      style: Theme.of(context).textTheme.subtitle2,
      autocorrect: false,
      decoration: kTextFieldDecoration.copyWith(fillColor: Colors.white),
    );
  }

  Future<void> _updateMentoringAttributes(BuildContext context) async {
    try {
      await usersRef
          .doc(widget.profileId)
          .update({"Mentoring About": mentorText});
    } on FirebaseException catch (e) {
      showAlertDialog(context,
          title: 'Operation Failed', content: '$e', defaultActionText: 'Ok');
    }
    setState(() {
      mentorEditStatus = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
        future: usersRef.doc(widget.profileId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          myUser user = myUser.fromDocument(snapshot.data);
          return Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: mentorEditStatus
                        ? CrossAxisAlignment.center
                        : CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          'What makes me a good mentor',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ),
                      mentorEditStatus
                          ? Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    right: 8.0,
                                    bottom: 10.0,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      _updateMentoringAttributes(context);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.green,
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
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 8.0, bottom: 10.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        mentorEditStatus = false;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.red,
                                      ),
                                      height: 40.0,
                                      width: 40.0,
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : !widget.myProfileView
                              ? SizedBox()
                              : Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        mentorEditStatus = true;
                                      });
                                    },
                                    child: IconCircle(
                                      circleColor:
                                          Theme.of(context).backgroundColor,
                                      width: 30.0,
                                      height: 30.0,
                                      iconType: Icons.edit,
                                    ),
                                  ),
                                ),
                    ],
                  ),
                ),
                mentorEditStatus
                    ? _buildMentorTextField(user.mentorAbout)
                    : Padding(
                        padding: const EdgeInsets.only(top: 8.0, right: 10.0),
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                '${user.mentorAbout}',
                                style: Theme.of(context).textTheme.subtitle2,
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          );
        });
  }
}
