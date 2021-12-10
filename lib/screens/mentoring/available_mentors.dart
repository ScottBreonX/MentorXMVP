import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mentorx_mvp/components/mentor_card_test.dart';
import 'package:mentorx_mvp/models/profile_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mentorx_mvp/models/user.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/screens/home_screen.dart';
import 'package:mentorx_mvp/screens/menu_bar/menu_bar.dart';
import 'package:mentorx_mvp/services/database.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

final _firestore = FirebaseFirestore.instance;

class AvailableMentorsScreen extends StatefulWidget {
  final myUser loggedInUser;
  static const String id = 'available_mentors_screen';
  final Database database;

  AvailableMentorsScreen({
    this.loggedInUser,
    this.database,
  });

  @override
  _AvailableMentorsScreenState createState() => _AvailableMentorsScreenState();
}

class _AvailableMentorsScreenState extends State<AvailableMentorsScreen> {
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  TextEditingController searchController = TextEditingController();
  String searchString;

  @override
  void initState() {
    super.initState();
  }

  clearSearch() {
    searchController.clear();
    setState(() {
      searchString = null;
    });
  }

  AppBar buildSearchField() {
    return AppBar(
      title: Container(
        width: double.infinity,
        height: 40,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
        child: TextFormField(
          style: Theme.of(context).textTheme.subtitle2,
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Search for a mentor...',
            hintStyle: Theme.of(context).textTheme.subtitle2,
            filled: true,
            fillColor: Colors.white,
            prefixIcon: Icon(
              Icons.account_box,
              size: 30,
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear),
              onPressed: clearSearch,
            ),
          ),
//           onFieldSubmitted: handleSearch),
          onFieldSubmitted: handleSearch,
        ),
      ),
    );
  }

  handleSearch(String query) {
    String _query = query;
    setState(() {
      searchString = _query;
    });
  }

  buildNoContent() {
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            Icon(Icons.search),
            Text('Test'),
          ],
        ),
      ),
    );
  }

  buildMentorListContent(myUser loggedInUser) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Available Mentors',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline1,
              ),
              AvailableMentorsStream(
                searchString: searchString,
                loggedInUser: loggedInUser,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    final drawerItems = MentorXMenuList();
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();

    return Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          child: Container(
            child: drawerItems,
          ),
        ),
        appBar: buildSearchField(),
        body: buildMentorListContent(loggedInUser));
  }
}

class AvailableMentorsStream extends StatelessWidget {
  final myUser loggedInUser;
  final String searchString;
  final Stream mentorStream = _firestore
      .collection('users')
      .where('Mentor', isEqualTo: true)
      .snapshots();

  AvailableMentorsStream({
    this.searchString,
    this.loggedInUser,
  });

  @override
  Widget build(BuildContext context) {
    var strStart = searchString == null
        ? null
        : searchString.substring(0, searchString.length - 1);
    var strEnd = searchString == null
        ? null
        : String.fromCharCode(searchString.characters.last.codeUnitAt(0) + 1);
    var limit = searchString != null ? (strStart + strEnd) : null;

    Stream searchStream = _firestore
        .collection('users')
        .where('First Name', isGreaterThanOrEqualTo: searchString)
        .where('First Name', isLessThan: limit)
        .where('Mentor', isEqualTo: true)
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: searchString == null ? mentorStream : searchStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center();
        }
        final mentors = snapshot.data.docs;
        print(mentors);

        // List<MentorCard> mentorBubbles = [];
        List<MentorCardTest> mentorBubbles = [];

        for (var mentor in mentors) {
          if (mentor.id == loggedInUser.id) {
            continue;
          }
          ProfileModel user = ProfileModel.fromDocument(mentor);

          final mentorBubble = MentorCardTest(
            mentorUID: mentor.id.toString(),
            // mentorSlots: mentor.data()['Available Slots'],
            mentorSlots: 1,
            mentorFname: user.fName,
            mentorLname: user.lName,
            mentorEmail: user.email,
          );
          mentorBubbles.add(mentorBubble);
        }
        return Expanded(
          child: ListView(
              padding: EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 10.0,
              ),
              children: mentorBubbles),
        );
      },
    );
  }
}
