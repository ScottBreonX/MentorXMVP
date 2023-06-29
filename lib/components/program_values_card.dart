import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/constants.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');

class ProgramValuesCard extends StatefulWidget {
  final String titleText;
  final String bodyText;

  ProgramValuesCard({
    this.titleText,
    this.bodyText,
  });

  @override
  State<ProgramValuesCard> createState() => _ProgramValuesCardState();
}

class _ProgramValuesCardState extends State<ProgramValuesCard> {
  bool expandStatus = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 10,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10.0,
                    top: 20,
                    bottom: 15,
                  ),
                  child: Text(
                    '${widget.titleText}',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Montserrat',
                      color: kMentorXPAccentDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        expandStatus
                            ? expandStatus = false
                            : expandStatus = true;
                      });
                    },
                    child: Icon(
                      expandStatus
                          ? Icons.remove_circle_rounded
                          : Icons.add_circle_rounded,
                      color: kMentorXPAccentDark,
                      size: 25,
                    ),
                  ),
                ),
              ],
            ),
            expandStatus
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10),
                        child: Divider(
                          thickness: 2,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          '${widget.bodyText}',
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Montserrat',
                            color: kMentorXPPrimary,
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
