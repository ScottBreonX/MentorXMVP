import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/program_tile.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/models/program.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

final _firestore = FirebaseFirestore.instance;

class AvailableProgramsScreen extends StatefulWidget {
  final myUser loggedInUser;
  final String programType;
  static const String id = 'available_programs_screen';
  const AvailableProgramsScreen({this.loggedInUser, this.programType});

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
          widget.programType == 'school'
              ? Padding(
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
                        'University Programs',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 40.0, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Text(
                          'Mentor',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: kMentorXPPrimary,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Text(
                        'XP',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: kMentorXPAccentMed,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Text(
                          'Programs',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: kMentorXPPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
          Divider(
            thickness: 4,
            indent: 40,
            endIndent: 40,
            color: Colors.black45,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * .70,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10),
                    child: AvailableProgramsStream(
                      type: '${widget.programType}',
                    ),
                  ),
                ),
              ),
            ],
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
        title: Image.asset(
          'assets/images/MentorXP.png',
          height: 100,
        ),
      ),
      body: buildProgramListContent(),
    );
  }
}

// building class for stream of Available Programs

class AvailableProgramsStream extends StatelessWidget {
  final String type;

  AvailableProgramsStream({
    this.type,
  });

  @override
  Widget build(BuildContext context) {
    final Stream programStream = _firestore
        .collection('institutions')
        .where('type', isEqualTo: type)
        .snapshots();

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
            programName: prog.programName,
            institutionName: prog.institutionName,
            programAbout: prog.aboutProgram,
            type: prog.type,
            imageContainer: Container(
                child: prog.programLogo == null || prog.programLogo.isEmpty
                    ? Image.asset(
                        'assets/images/MLogoPink.png',
                        height: 70,
                        width: 70,
                        fit: BoxFit.fill,
                      )
                    : CachedNetworkImage(
                        imageUrl: prog.programLogo,
                        imageBuilder: (context, imageProvider) => Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Image.asset(
                          'assets/images/MLogoPink.png',
                          height: 70,
                          width: 70,
                          fit: BoxFit.fill,
                        ),
                      )),
          );
          programBubbles.add(programBubble);
        }
        return Container(
          child: ListView(
            scrollDirection: Axis.vertical,
            children: programBubbles,
          ),
        );
      },
    );
  }
}
