import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/program_tile.dart';
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
  // TextEditingController searchController = TextEditingController();
  // String searchString;
  bool showSpinner = false;

  @override
  void initState() {
    super.initState();
  }

  // clearSearch() {
  //   searchController.clear();
  //   setState(() {
  //     searchString = null;
  //   });
  // }

  // handleSearch(String query) {
  //   String _query = query;
  //   setState(() {
  //     searchString = _query;
  //   });
  // }

//   AppBar buildSearchField() {
//     return AppBar(
//       title: Container(
//         width: double.infinity,
//         height: 40,
//         decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
//         child: TextFormField(
//           style: Theme.of(context).textTheme.subtitle2,
//           controller: searchController,
//           decoration: InputDecoration(
//             hintText: 'Search for a program...',
//             hintStyle: Theme.of(context).textTheme.subtitle2,
//             filled: true,
//             fillColor: Colors.white,
//             prefixIcon: Icon(
//               Icons.account_box,
//               size: 30,
//             ),
//             suffixIcon: IconButton(
//               icon: Icon(Icons.clear),
//               onPressed: clearSearch,
//             ),
//           ),
// //           onFieldSubmitted: handleSearch),
//           onFieldSubmitted: handleSearch,
//         ),
//       ),
//     );
//   }

  buildProgramListContent() {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: widget.programType == 'school'
                        ? Icon(
                            Icons.school,
                            size: 40,
                            color: Colors.pink,
                          )
                        : Image.asset(
                            'assets/images/MLogoBlue.png',
                            height: 50,
                          ),
                  ),
                  Text(
                    'Available Programs',
                    style: TextStyle(
                      fontFamily: 'WorkSans',
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
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
                        // searchString: searchString,
                        type: '${widget.programType}',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: buildSearchField(),
      appBar: AppBar(
        elevation: 5,
        title: Image.asset(
          'assets/images/MentorPinkWhite.png',
          height: 150,
        ),
      ),
      body: buildProgramListContent(),
    );
  }
}

// building class for stream of Available Programs

class AvailableProgramsStream extends StatelessWidget {
  // final String searchString;
  final String type;

  AvailableProgramsStream({
    // this.searchString,
    this.type,
  });

  @override
  Widget build(BuildContext context) {
    final Stream programStream = _firestore
        .collection('institutions')
        .where('type', isEqualTo: type)
        .snapshots();

    // var strStart = searchString == null
    //     ? null
    //     : searchString.substring(0, searchString.length - 1);
    // var strEnd = searchString == null
    //     ? null
    //     : String.fromCharCode(searchString.characters.last.codeUnitAt(0) + 1);
    // var limit = searchString != null ? (strStart + strEnd) : null;

    // Stream searchStream = _firestore
    //     .collection('institutions')
    //     .where('type', isEqualTo: type)
    //     .where('programName', isGreaterThanOrEqualTo: searchString)
    //     .where('programName', isLessThan: limit)
    //     .snapshots();

    return StreamBuilder<QuerySnapshot>(
      // stream: searchString == null ? programStream : searchStream,
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
            type: prog.type,
            imageContainer: Container(
                child: prog.programLogo == null || prog.programLogo.isEmpty
                    ? Image.asset(
                        'assets/images/MLogoBlue.png',
                        height: 50,
                        width: 50,
                        fit: BoxFit.fill,
                      )
                    : CachedNetworkImage(
                        imageUrl: prog.programLogo,
                        imageBuilder: (context, imageProvider) => Container(
                          height: 60,
                          width: 60,
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
                        errorWidget: (context, url, error) => Image.asset(
                          'assets/images/MLogoPink.png',
                          height: 50,
                          width: 50,
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
