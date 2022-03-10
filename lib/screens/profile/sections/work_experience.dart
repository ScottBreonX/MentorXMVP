import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../components/progress.dart';
import '../../../constants.dart';
import '../../../components/alert_dialog.dart';
import '../../../components/icon_circle.dart';
import 'package:mentorx_mvp/models/user.dart';

final usersRef = FirebaseFirestore.instance.collection('users');

class WorkExperienceSection extends StatefulWidget {
  final String profileId;
  final bool myProfileView;

  const WorkExperienceSection({
    @required this.profileId,
    @required this.myProfileView,
  });

  @override
  _WorkExperienceSectionState createState() => _WorkExperienceSectionState();
}

class _WorkExperienceSectionState extends State<WorkExperienceSection> {
  @override
  void initState() {
    workExperienceEditStatus = false;
    super.initState();
  }

  bool workExperienceEditStatus;
  String workExperienceText;
  final _formKey1 = GlobalKey<FormState>();

  TextFormField _buildWorkExperienceTextField(String userWorkExperienceText) {
    return TextFormField(
      key: _formKey1,
      initialValue: userWorkExperienceText,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      textAlign: TextAlign.start,
      onChanged: (value) => workExperienceText = value,
      style: Theme.of(context).textTheme.subtitle2,
      autocorrect: false,
      decoration: kTextFieldDecoration.copyWith(fillColor: Colors.white),
    );
  }

  Future<void> _updateWorkExperience(String userID) async {
    try {
      if (workExperienceText != null) {
        await usersRef
            .doc(userID)
            .update({"Work Experience": workExperienceText});
      }
    } on FirebaseException catch (e) {
      showAlertDialog(context,
          title: 'Operation Failed', content: '$e', defaultActionText: 'Ok');
    }
    setState(() {
      workExperienceEditStatus = false;
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
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: workExperienceEditStatus
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Work Experience',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    workExperienceEditStatus
                        ? Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 8.0,
                                  bottom: 10.0,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    _updateWorkExperience(user.id);
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
                                      workExperienceEditStatus = false;
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
                                      workExperienceEditStatus = true;
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
              workExperienceEditStatus
                  ? _buildWorkExperienceTextField(user.workExperience)
                  : Padding(
                      padding: const EdgeInsets.only(top: 8.0, right: 10.0),
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              "${user.workExperience}",
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
