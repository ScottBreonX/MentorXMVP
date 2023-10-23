import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/mentor_card.dart';
import 'package:mentorx_mvp/components/program_tile.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/models/program.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class AvailableProgramsScreen extends StatefulWidget {
  final myUser loggedInUser;
  static const String id = 'available_programs_screen';
  const AvailableProgramsScreen({
    this.loggedInUser,
  });

  @override
  _AvailableProgramsScreenState createState() =>
      _AvailableProgramsScreenState();
}

class _AvailableProgramsScreenState extends State<AvailableProgramsScreen> {
  bool showSpinner = false;

  @override
  void initState() {
    super.initState();
  }

  buildProgramListContent() {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.school,
                  size: 40,
                  color: kMentorXPAccentDark,
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  'Available Programs',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            thickness: 2,
            indent: 40,
            endIndent: 40,
            color: Colors.grey,
          ),
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: AvailableProgramsStream(widget.loggedInUser),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        backgroundColor: kMentorXPPrimary,
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
      body: SingleChildScrollView(
        child: buildProgramListContent(),
      ),
    );
  }
}

// building class for stream of Available Programs

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
