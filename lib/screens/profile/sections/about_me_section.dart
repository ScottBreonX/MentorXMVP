import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../components/progress.dart';
import '../../../constants.dart';
import '../../../components/alert_dialog.dart';
import '../../../components/icon_circle.dart';
import 'package:mentorx_mvp/models/user.dart';

final usersRef = FirebaseFirestore.instance.collection('users');

class AboutMeSection extends StatefulWidget {
  final String profileId;
  final bool myProfileView;

  const AboutMeSection({
    @required this.profileId,
    @required this.myProfileView,
  });

  @override
  _AboutMeSectionState createState() => _AboutMeSectionState();
}

class _AboutMeSectionState extends State<AboutMeSection> {
  @override
  void initState() {
    aboutMeEditStatus = false;
    super.initState();
  }

  bool aboutMeEditStatus;
  String aboutMeText;
  final _formKey1 = GlobalKey<FormState>();

  TextFormField _buildAboutMeTextField(String userAboutMeText) {
    return TextFormField(
      key: _formKey1,
      textCapitalization: TextCapitalization.sentences,
      initialValue: userAboutMeText,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      textAlign: TextAlign.start,
      onChanged: (value) => aboutMeText = value,
      style: TextStyle(
        fontFamily: 'Montserrat',
        color: Colors.black54,
        fontSize: 18,
      ),
      autocorrect: true,
      decoration: kTextFieldDecoration.copyWith(
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kMentorXPSecondary, width: 4.0),
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kMentorXPSecondary, width: 2.0),
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
      ),
    );
  }

  Future<void> _updateAboutMe(String userID) async {
    try {
      if (aboutMeText != null) {
        await usersRef.doc(userID).update({"About Me": aboutMeText});
      }
    } on FirebaseException catch (e) {
      showAlertDialog(context,
          title: 'Operation Failed', content: '$e', defaultActionText: 'Ok');
    }
    setState(() {
      aboutMeEditStatus = false;
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
                  crossAxisAlignment: aboutMeEditStatus
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.end,
                  children: [
                    Text(
                      'About Me',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                        fontSize: 20,
                        color: kMentorXPSecondary,
                      ),
                    ),
                    aboutMeEditStatus
                        ? Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 8.0,
                                  bottom: 10.0,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    _updateAboutMe(user.id);
                                  },
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
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 8.0, bottom: 10.0),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      aboutMeEditStatus = false;
                                    });
                                  },
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
                            ],
                          )
                        : !widget.myProfileView
                            ? SizedBox()
                            : Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      aboutMeEditStatus = true;
                                    });
                                  },
                                  child: IconCircle(
                                    width: 30.0,
                                    height: 30.0,
                                    iconType: Icons.edit,
                                    iconColor: kMentorXPAccentDark,
                                  ),
                                ),
                              ),
                  ],
                ),
              ),
              aboutMeEditStatus
                  ? _buildAboutMeTextField(user.aboutMe)
                  : Padding(
                      padding: const EdgeInsets.only(top: 8.0, right: 10.0),
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              "${user.aboutMe}",
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Montserrat',
                                color: Colors.black54,
                              ),
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
