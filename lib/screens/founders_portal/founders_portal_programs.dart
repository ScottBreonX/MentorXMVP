import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../../components/program_tile.dart';
import '../../models/program.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');

class FoundersPortalProgramsScreen extends StatefulWidget {
  final myUser loggedInUser;
  static const String id = 'founders_portal_programs';

  FoundersPortalProgramsScreen({
    this.loggedInUser,
  });

  @override
  _FoundersPortalProgramsScreenState createState() =>
      _FoundersPortalProgramsScreenState();
}

class _FoundersPortalProgramsScreenState
    extends State<FoundersPortalProgramsScreen> {
  bool showSpinner = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  buildProgramListContent(myUser loggedInUser) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Created Programs',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 35,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
                Divider(
                  indent: 30,
                  endIndent: 30,
                  color: Colors.black54,
                  thickness: 2,
                ),
                AvailableProgramsStream(widget.loggedInUser),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMentorXPPrimary,
        elevation: 5,
        title: Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 35.0, bottom: 10),
            child: Image.asset(
              'assets/images/MentorXP.png',
              fit: BoxFit.contain,
              height: 35,
            ),
          ),
        ),
      ),
      body: buildProgramListContent(widget.loggedInUser),
    );
  }
}

class AvailableProgramsStream extends StatelessWidget {
  AvailableProgramsStream(this.loggedInUser);
  final myUser loggedInUser;

  @override
  Widget build(BuildContext context) {
    final Stream programStream = programsRef.snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: programStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center();
        }
        final programs = snapshot.data.docs;

        List<ProgramTile> programBubbles = [];

        for (var program in programs) {
          Program prog = Program.fromDocument(program);

          final programBubble = ProgramTile(
            programId: program.id.toString(),
            loggedInUser: loggedInUser,
            programName: prog.programName,
            institutionName: prog.institutionName,
            programAbout: prog.aboutProgram,
            imageContainer: Container(
                child: prog.programLogo == null || prog.programLogo.isEmpty
                    ? Image.asset(
                        'assets/images/MXPDark.png',
                        height: 50,
                        fit: BoxFit.fill,
                      )
                    : Padding(
                        padding: const EdgeInsets.only(
                            left: 12, right: 12, top: 5, bottom: 5),
                        child: CachedNetworkImage(
                          imageUrl: prog.programLogo,
                          imageBuilder: (context, imageProvider) => Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Image.asset(
                            'assets/images/MXPDark.png',
                            height: 40,
                            width: 40,
                            fit: BoxFit.fill,
                          ),
                        ),
                      )),
          );
          programBubbles.add(programBubble);
        }
        return Wrap(
          children: programBubbles,
        );
      },
    );
  }
}
