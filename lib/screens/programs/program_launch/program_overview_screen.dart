import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/progress.dart';
import 'package:mentorx_mvp/models/program.dart';
import 'package:mentorx_mvp/screens/launch_screen.dart';

class ProgramOverview extends StatefulWidget {
  final loggedInUser;
  final String programId;
  static String id = 'program_overview_screen';

  const ProgramOverview({
    this.programId,
    this.loggedInUser,
  });

  @override
  State<ProgramOverview> createState() => _ProgramOverviewState();
}

class _ProgramOverviewState extends State<ProgramOverview> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
        future: programsRef.doc(widget.programId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          Program program = Program.fromDocument(snapshot.data);
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
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: program.programLogo.isEmpty ||
                                program.programLogo == null ||
                                program.programLogo == ""
                            ? Image.asset(
                                'assets/images/MLogoPink.png',
                                height: 120,
                                width: 120,
                              )
                            : CachedNetworkImage(
                                imageUrl: program.programLogo,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  height: 120,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                  'assets/images/MLogoBlue.png',
                                  height: 120,
                                  width: 120,
                                  fit: BoxFit.fill,
                                ),
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  '${program.programName}',
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: Theme.of(context)
                                        .textTheme
                                        .headline4
                                        .color,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 6,
                        color: Colors.black45,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10.0, bottom: 10),
                              child: Text(
                                'Type of program',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      .color,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.grey[200],
                                ),
                                height: 45,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  child: Text(
                                    '${program.enrollmentType.toUpperCase()}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30,
                                      color: Theme.of(context)
                                          .textTheme
                                          .headline4
                                          .color,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'About this program',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color:
                                    Theme.of(context).textTheme.headline1.color,
                              ),
                            ),
                            SizedBox(height: 5),
                            Container(
                              height: 150,
                              alignment: Alignment.topLeft,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                child: SingleChildScrollView(
                                  child: Text(
                                    '${program.aboutProgram}',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Theme.of(context)
                                          .textTheme
                                          .headline4
                                          .color,
                                    ),
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
              ),
            ),
          );
        });
  }
}
