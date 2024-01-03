import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:mentorx_mvp/screens/menu_bar/menu_bar.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import '../../components/program_tile.dart';
import '../../components/progress.dart';
import '../../models/program.dart';
import '../../services/auth.dart';
import '../launch_screen.dart';
import '../programs/available_programs.dart';
import '../programs/program_launch/program_enrollment_screen.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');

class HomeScreen extends StatefulWidget {
  final myUser loggedInUser;

  const HomeScreen({
    Key key,
    this.loggedInUser,
  }) : super(key: key);

  static const String id = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool loggedIn = false;
  bool showSpinner = false;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  getCurrentUser() async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    loggedInUser = myUser.fromDocument(
        await usersRef.doc(auth.currentUser.uid).get().whenComplete(() {
      if (mounted) {
        setState(() {
          loggedIn = true;
        });
      }
    }));
  }

  Future _welcomeBoolUpdate() async {
    await usersRef.doc(widget.loggedInUser.id).update({
      'Welcome Message': false,
    });
  }

  welcomeMessage(parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              'Welcome to MentorUP!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: kMentorXPAccentDark,
                fontFamily: 'Montserrat',
                fontSize: 25,
                fontWeight: FontWeight.w500,
              ),
            ),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Divider(
                  height: 4,
                  color: Colors.grey,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 20, left: 20.0, right: 20.0, bottom: 10),
                child: Column(
                  children: [
                    Text(
                      'Through involvement in this program, you will gain access to resources designed to facilitate your mentoring relationship and unlock your full career potential.',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Explore curated content tailored to your experience as you further your development alongside your mentor / mentee.',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Congratulations on investing in yourself and beginning your mentorship journey!',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    SizedBox(height: 20),
                    RoundedButton(
                      title: 'Let\'s Go',
                      textAlignment: MainAxisAlignment.center,
                      buttonColor: kMentorXPSecondary,
                      fontColor: Colors.white,
                      onPressed: () async {
                        await _welcomeBoolUpdate();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(
                              loggedInUser: loggedInUser,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  buildProgramListContent() {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AvailableProgramsStream(widget.loggedInUser),
        ],
      ),
    );
  }

  bool profilePictureStatus = false;

  @override
  Widget build(BuildContext context) {
    if (loggedIn == false || widget.loggedInUser == null) {
      return circularProgress(Theme.of(context).primaryColor);
    }

    final drawerItems = MentorXMenuList(loggedInUser: loggedInUser);
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();

    return StreamBuilder<DocumentSnapshot>(
        stream: usersRef.doc(widget.loggedInUser.id).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress(Theme.of(context).primaryColor);
          }

          if (widget.loggedInUser.profilePicture != "") {
            profilePictureStatus = true;
          }

          if (widget.loggedInUser.profilePicture.isEmpty ||
              widget.loggedInUser.profilePicture == null ||
              widget.loggedInUser.profilePicture == "") {
            profilePictureStatus = false;
          } else {
            profilePictureStatus = true;
          }

          pageTransition(Widget page, double offSetLow, double offSetHigh) {
            return PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 300),
              pageBuilder: (context, animation, secondaryAnimation) => page,
              transitionsBuilder:
                  (context, animation, secondaryAnimation, page) {
                var begin = Offset.fromDirection(offSetLow, offSetHigh);
                var end = Offset.zero;
                var curve = Curves.ease;

                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));
                return SlideTransition(
                  position: animation.drive(tween),
                  child: page,
                );
              },
            );
          }

          loggedInUser.welcomeMessage
              ? Future.delayed(Duration.zero, () => welcomeMessage(context))
              : null;

          return Scaffold(
            key: _scaffoldKey,
            drawer: Drawer(
              child: Container(
                child: drawerItems,
              ),
            ),
            appBar: AppBar(
              elevation: 5,
              backgroundColor: Color.fromRGBO(38, 70, 83, 1),
              centerTitle: true,
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
            body: Container(
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    kMentorXPPrimary.withOpacity(0.1),
                    Colors.white,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 20,
                            right: 40,
                            left: 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Welcome to',
                                  style:
                                      Theme.of(context).textTheme.headlineLarge,
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/MentorXPDark.png',
                                fit: BoxFit.contain,
                                height: 150,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      thickness: 2,
                      indent: 20,
                      endIndent: 20,
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 20.0, left: 0, right: 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: 10.0, top: 10),
                            child: Text(
                              'Join a Program',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                          ),
                          Wrap(
                            children: [
                              Text(
                                'You are not currently enrolled in any programs.',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                          Wrap(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20.0),
                                child: Text(
                                  'Click below to view available programs.',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 2.0),
                            child: ButtonCard(
                              buttonCardText: "View Available Programs",
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AvailableProgramsScreen(
                                    loggedInUser: loggedInUser,
                                  ),
                                ),
                              ),
                              cardIconBool: Container(),
                              cardWidthPercent: .80,
                              cardAlignment: MainAxisAlignment.center,
                              buttonCardColor: kMentorXPPrimary,
                              buttonCardTextColor: Colors.white,
                              buttonCardTextSize: 20,
                              buttonCardRadius: 20,
                            ),
                          ),
                          // buildProgramListContent(),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
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
                    ? Padding(
                        padding: const EdgeInsets.only(
                            left: 5, right: 5, top: 5, bottom: 5),
                        child: Image.asset(
                          'assets/images/MXPDark.png',
                          height: 50,
                          fit: BoxFit.fill,
                        ),
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
