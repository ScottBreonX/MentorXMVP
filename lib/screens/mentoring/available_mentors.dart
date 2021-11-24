import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mentorx_mvp/components/progress.dart';
import 'package:mentorx_mvp/models/profile_model.dart';
import 'package:mentorx_mvp/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mentorx_mvp/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/mentor_card.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/screens/menu_bar/menu_bar.dart';
import 'package:mentorx_mvp/services/database.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

User loggedInUser;
final _firestore = FirebaseFirestore.instance;

class AvailableMentorsScreen extends StatefulWidget {
  const AvailableMentorsScreen({
    Key key,
    this.database,
  }) : super(key: key);
  static const String id = 'available_mentors_screen';
  final Database database;

  @override
  _AvailableMentorsScreenState createState() => _AvailableMentorsScreenState();
}

class _AvailableMentorsScreenState extends State<AvailableMentorsScreen> {
  bool showSpinner = false;
  bool profilePhotoStatus = false;
  bool profilePhotoSelected = false;
  final _auth = FirebaseAuth.instance;
  String messageText;
  TextEditingController searchController = TextEditingController();
  String searchString;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    getProfileData();
  }

  void getCurrentUser() {
    final auth = Provider.of<AuthBase>(context, listen: false);
    try {
      final user = auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  dynamic profileData;

  Future<dynamic> getProfileData() async {
    await FirebaseFirestore.instance
        .collection('users/${loggedInUser.uid}/profile')
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        if (mounted) {
          setState(() {
            profileData = result.data();
          });
        }
      });
    });
  }

  clearSearch() {
    searchController.clear();
    setState(() {
      searchString = null;
    });
  }

  AppBar buildSearchField() {
    return AppBar(
      backgroundColor: kMentorXPrimary,
      title: Container(
        width: double.infinity,
        height: 40,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
        child: TextFormField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Search for a mentor...',
              filled: true,
              prefixIcon: Icon(Icons.account_box, size: 28),
              suffixIcon: IconButton(
                icon: Icon(Icons.clear),
                onPressed: clearSearch,
              ),
            ),
            // onFieldSubmitted: handleSearch),
            onFieldSubmitted: handleSearch),
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

  buildMentorListContent() {
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
                style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: kMentorXPrimary),
              ),
              AvailableMentorsStream(searchString: searchString),
            ],
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    if (profileData == null) {
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: kMentorXPrimary,
        ),
      );
    }

    if (profileData['images'] == null) {
      setState(() {
        profilePhotoStatus = false;
      });
    } else {
      setState(() {
        profilePhotoStatus = true;
      });
    }

    var drawerHeader = MentorXMenuHeader(
      fName: '${profileData['First Name']}',
      lName: '${profileData['Last Name']}',
      email: '${profileData['Email Address']}',
      profilePicture: '${profileData['images']}',
    );

    final drawerItems = MentorXMenuList(drawerHeader: drawerHeader);
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();

    return Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          child: Container(
            child: drawerItems,
            decoration: BoxDecoration(
              color: kMentorXPrimary,
            ),
          ),
        ),
        appBar: buildSearchField(),
        // body: searchResultsFuture == null
        //     ? buildMentorListContent(query)
        //     // ? buildNoContent()
        //     : buildSearchResults(),
        body: buildMentorListContent());
  }
}

class AvailableMentorsStream extends StatelessWidget {
  final String searchString;
  final Stream mentorStream = _firestore
      .collection('users')
      .where('Mentor', isEqualTo: true)
      .snapshots();

  AvailableMentorsStream({
    this.searchString,
  });

  @override
  Widget build(BuildContext context) {
    Stream searchStream = _firestore
        .collection('users')
        .where('First Name', isGreaterThanOrEqualTo: searchString)
        .where('Mentor', isEqualTo: true)
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: searchString == null ? mentorStream : searchStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: kMentorXPrimary,
            ),
          );
        }
        final mentors = snapshot.data.docs;
        print(mentors);

        List<MentorCard> mentorBubbles = [];

        for (var mentor in mentors) {
          if (mentor.id == loggedInUser.uid) {
            continue;
          }
          ProfileModel user = ProfileModel.fromDocument(mentor);

          final mentorBubble = MentorCard(
            mentorUID: mentor.id.toString(),
            // mentorSlots: mentor.get('Available Slots'),
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
