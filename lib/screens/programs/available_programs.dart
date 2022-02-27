import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/program_tile.dart';
import 'package:mentorx_mvp/models/program.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

final _firestore = FirebaseFirestore.instance;

class AvailableProgramsScreen extends StatefulWidget {
  final myUser loggedInUser;
  static const String id = 'available_programs_screen';

  const AvailableProgramsScreen({this.loggedInUser});

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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 25, 0, 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'All Available Programs',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline4.color,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                color: Colors.black,
                endIndent: 75,
                indent: 75,
                thickness: 2,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'University Specific Programs',
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline4.color,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: AvailableProgramsStream(
                    // searchString: searchString,
                    type: 'school',
                  ),
                ),
              ),
              Divider(
                color: Colors.black,
                endIndent: 75,
                indent: 75,
                thickness: 2,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Mentor+ Career Programs',
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline4.color,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: AvailableProgramsStream(
                    // searchString: searchString,
                    type: 'mentorX',
                  ),
                ),
              ),
            ],
          ),
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
        title: Text('Available Programs'),
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
          );
          programBubbles.add(programBubble);
        }
        return ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 10.0,
            ),
            children: programBubbles);
      },
    );
  }
}
