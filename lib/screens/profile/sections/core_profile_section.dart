import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../components/progress.dart';
import '../../../constants.dart';
import '../../../components/alert_dialog.dart';
import '../../../components/icon_circle.dart';
import 'package:mentorx_mvp/models/user.dart';

final usersRef = FirebaseFirestore.instance.collection('users');

class CoreProfileSection extends StatefulWidget {
  final String profileId;
  final bool myProfileView;

  const CoreProfileSection({
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
  final _formKey3 = GlobalKey<FormState>();
  final _formKey4 = GlobalKey<FormState>();

  Future<void> _updateCoreProfile(String userID) async {
    try {
      if (firstNameText != null) {
        await usersRef.doc(userID).update({
          "First Name": firstNameText,
        });
      }
      if (lastNameText != null) {
        await usersRef.doc(userID).update({
          "Last Name": lastNameText,
        });
      }
      if (majorText != null) {
        await usersRef.doc(userID).update({
          "Major": majorText,
        });
      }
      if (schoolYearText != null) {
        await usersRef.doc(userID).update({
          "Year In School": schoolYearText,
        });
      }
    } on FirebaseException catch (e) {
      showAlertDialog(context,
          title: 'Operation Failed', content: '$e', defaultActionText: 'Ok');
    }
    setState(() {
      coreProfileEditStatus = false;
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
        return Column(
          children: [
            coreProfileEditStatus
                ? Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: coreProfileEditStatus
                            ? CrossAxisAlignment.center
                            : CrossAxisAlignment.end,
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
                                    _updateCoreProfile(user.id);
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
                                      coreProfileEditStatus = false;
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
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                key: _formKey1,
                                initialValue: user.firstName,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                textAlign: TextAlign.start,
                                onChanged: (value) => firstNameText = value,
                                style: Theme.of(context).textTheme.subtitle2,
                                autocorrect: false,
                                decoration: kTextFieldDecoration.copyWith(
                                  fillColor: Colors.white,
                                  labelText: 'First Name',
                                  labelStyle: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                key: _formKey2,
                                initialValue: user.lastName,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                textAlign: TextAlign.start,
                                onChanged: (value) => lastNameText = value,
                                style: Theme.of(context).textTheme.subtitle2,
                                autocorrect: false,
                                decoration: kTextFieldDecoration.copyWith(
                                  fillColor: Colors.white,
                                  labelText: 'Last Name',
                                  labelStyle: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                key: _formKey3,
                                initialValue: user.yearInSchool,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                textAlign: TextAlign.start,
                                onChanged: (value) => schoolYearText = value,
                                style: Theme.of(context).textTheme.subtitle2,
                                autocorrect: false,
                                decoration: kTextFieldDecoration.copyWith(
                                  fillColor: Colors.white,
                                  labelText: 'Year in School',
                                  labelStyle: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                key: _formKey4,
                                initialValue: user.major,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                textAlign: TextAlign.start,
                                onChanged: (value) => majorText = value,
                                style: Theme.of(context).textTheme.subtitle2,
                                autocorrect: false,
                                decoration: kTextFieldDecoration.copyWith(
                                  fillColor: Colors.white,
                                  labelText: 'Field of Study',
                                  labelStyle: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.only(left: 15.0, top: 5.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                "${user.firstName} ${user.lastName}",
                                style: Theme.of(context).textTheme.headline4,
                              ),
                            ),
                            widget.myProfileView
                                ? Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          coreProfileEditStatus = true;
                                        });
                                      },
                                      child: IconCircle(
                                        width: 30.0,
                                        height: 30.0,
                                        iconType: Icons.edit,
                                        circleColor:
                                            Theme.of(context).backgroundColor,
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                "${user.yearInSchool}, ${user.major}",
                                style: Theme.of(context).textTheme.subtitle2,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
          ],
        );
      },
    );
  }
}
