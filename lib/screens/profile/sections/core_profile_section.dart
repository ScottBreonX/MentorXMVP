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
          "Year in School": schoolYearText,
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
                          coreProfileTextField(
                            user,
                            _formKey1,
                            user.firstName,
                            "First Name",
                            (value) => firstNameText = value,
                          ),
                          coreProfileTextField(
                            user,
                            _formKey2,
                            user.lastName,
                            'Last Name',
                            (value) => lastNameText = value,
                          )
                        ],
                      ),
                      Row(
                        children: [
                          coreProfileTextField(
                            user,
                            _formKey3,
                            user.yearInSchool,
                            'Year in School',
                            (value) => schoolYearText = value,
                          ),
                          coreProfileTextField(
                            user,
                            _formKey4,
                            user.major,
                            'Major',
                            (value) => majorText = value,
                          )
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
                style: TextStyle(
                  color: Colors.black45,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Material(
              elevation: 10,
              shadowColor: Colors.black54,
              borderRadius: BorderRadius.circular(20.0),
              child: Column(
                children: [
                  TextFormField(
                    key: formKey,
                    initialValue: initialValue,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    textAlign: TextAlign.start,
                    onChanged: onChanged,
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                    autocorrect: false,
                    decoration: kTextFieldDecoration.copyWith(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2.0),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      alignLabelWithHint: true,
                      hintText: hintText,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      labelStyle: TextStyle(color: Colors.grey.shade400),
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      filled: true,
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 4.0),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
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
    );
  }
}
