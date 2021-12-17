import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:mentorx_mvp/models/program.dart';
import 'package:mentorx_mvp/screens/menu_bar/menu_bar.dart';

class ProgramJoinRequest extends StatefulWidget {
  static String id = 'program_join_request';
  final loggedInUser;
  final program;

  const ProgramJoinRequest({
    this.loggedInUser,
    this.program,
  });

  @override
  _ProgramJoinRequestState createState() => _ProgramJoinRequestState();
}

class _ProgramJoinRequestState extends State<ProgramJoinRequest> {
  TextEditingController searchController = TextEditingController();
  String programCode;

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    final Program _program = widget.program;
    final drawerItems = MentorXMenuList(loggedInUser: widget.loggedInUser);
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();

    clearCode() {
      searchController.clear();
      setState(() {
        programCode = null;
      });
    }

    handleCode(String code) {
      String _code = code;
      setState(() {
        programCode = _code;
      });
    }

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Container(
          child: drawerItems,
        ),
      ),
      appBar: AppBar(
        elevation: 5,
        title: Text('Request to Join'),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.monetization_on,
                size: 150,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Request to Join ${_program.institutionName}\'s \n '
                    '${_program.programName} Program',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyText1.color,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Enter program code:',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyText1.color,
                    ),
                  ),
                  SizedBox(height: 5),
                  TextFormField(
                    style: Theme.of(context).textTheme.subtitle2,
                    controller: null,
                    decoration: InputDecoration(
                      hintText: (programCode == null || programCode.isEmpty)
                          ? 'ENTER PROGRAM CODE'
                          : programCode,
                      hintStyle: Theme.of(context).textTheme.subtitle2,
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: clearCode,
                      ),
                    ),
                    onFieldSubmitted: handleCode,
                  ),
                ],
              ),
              SizedBox(height: 35),
              Expanded(
                child: Column(
                  children: [
                    RoundedButton(
                      title: 'Request to Join',
                      fontColor: Theme.of(context).textTheme.button.color,
                      fontSize: 24,
                      minWidth: MediaQuery.of(context).size.width * 0.77,
                    ),
                    RoundedButton(
                      title: 'Cancel',
                      buttonColor:
                          Theme.of(context).buttonTheme.colorScheme.background,
                      fontColor: Theme.of(context).textTheme.button.color,
                      fontSize: 24,
                      minWidth: MediaQuery.of(context).size.width * 0.77,
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 8,
                color: Theme.of(context).dividerColor,
              ),
              Text(
                'Don\'t have a code? Contact the program administrator.',
                style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).textTheme.bodyText2.color),
              ),
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.grey,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  child: Text(
                    'SOMEBODY\'S NAME GOES HERE',
                    style: TextStyle(fontSize: 20, color: Colors.white70),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
