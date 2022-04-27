import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/models/user.dart';
import '../../../components/progress.dart';
import '../../../models/match_model.dart';
import '../../launch_screen.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');

class MentoringLaunchScreen extends StatefulWidget {
  final myUser loggedInUser;
  final String mentorUID;
  final String programUID;

  const MentoringLaunchScreen({
    Key key,
    this.loggedInUser,
    this.mentorUID,
    this.programUID,
  }) : super(key: key);

  static const String id = 'mentoring_launch_screen';

  @override
  _MentoringLaunchScreenState createState() => _MentoringLaunchScreenState();
}

class _MentoringLaunchScreenState extends State<MentoringLaunchScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: programsRef
            .doc(widget.programUID)
            .collection('matchedPairs')
            .doc(widget.mentorUID + loggedInUser.id)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          MatchModel matchInfo = MatchModel.fromDocument(snapshot.data);

          return Scaffold(
            appBar: AppBar(
              elevation: 5,
              title: Image.asset(
                'assets/images/MentorPinkWhite.png',
                height: 150,
              ),
            ),
            body: SingleChildScrollView(
              child: Container(
                child: Text('${matchInfo.notes}'),
              ),
            ),
          );
        });
  }
}
