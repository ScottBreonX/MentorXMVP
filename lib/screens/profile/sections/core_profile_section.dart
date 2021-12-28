import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../components/progress.dart';
import '../../../constants.dart';
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
  String yearInSchoolText;
  String majorText;
  final _formKey1 = GlobalKey<FormState>();

  TextFormField _buildFirstNameTextField(String userFirstNameText) {
    return TextFormField(
      key: _formKey1,
      initialValue: userFirstNameText,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      textAlign: TextAlign.start,
      onChanged: (value) => firstNameText = value,
      style: Theme.of(context).textTheme.subtitle2,
      autocorrect: false,
      decoration: kTextFieldDecoration,
    );
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
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: coreProfileEditStatus
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.end,
                  children: [
                    coreProfileEditStatus
                        ? Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 8.0,
                                  bottom: 10.0,
                                ),
                                child: GestureDetector(
                                  onTap: () {},
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
                          )
                        : !widget.myProfileView
                            ? SizedBox()
                            : Padding(
                                padding: const EdgeInsets.only(right: 8.0),
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
                              ),
                  ],
                ),
              ),
              coreProfileEditStatus
                  ? _buildFirstNameTextField(user.aboutMe)
                  : Padding(
                      padding: const EdgeInsets.only(top: 8.0, right: 10.0),
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              "${user.aboutMe}",
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }
}
