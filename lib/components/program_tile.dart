import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/screens/programs/program_profile.dart';
import '../models/user.dart';

class ProgramTile extends StatelessWidget {
  final String programId;
  final myUser loggedInUser;
  final String programName;
  final String institutionName;
  final String programAbout;
  final Function onPressed;
  final double boxHeight;
  final double boxWidth;
  final double textSize;
  final double imageHeight;
  final Image imageAsset;
  final CachedNetworkImage cachedNetworkImage;
  final Container imageContainer;

  ProgramTile({
    this.programId,
    this.programName,
    this.institutionName,
    this.programAbout,
    this.onPressed,
    this.boxHeight,
    this.boxWidth,
    this.textSize,
    this.imageHeight,
    this.imageAsset,
    this.cachedNetworkImage,
    this.imageContainer,
    this.loggedInUser,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ??
          () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProgramProfile(
                    programId: programId,
                    loggedInUser: loggedInUser,
                  ),
                ),
              ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          height: 100,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: <
                    Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: GestureDetector(
                      onTap: onPressed ??
                          () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProgramProfile(
                                    programId: programId,
                                    loggedInUser: loggedInUser,
                                  ),
                                ),
                              ),
                      child: imageContainer ??
                          imageAsset ??
                          cachedNetworkImage ??
                          null,
                    ),
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * .7,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Container(
                              child: Text(
                                '$programName',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Text('Institution: ',
                                style: Theme.of(context).textTheme.labelSmall),
                            Container(
                              width: MediaQuery.of(context).size.width * .50,
                              child: Text('$institutionName',
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall),
                            ),
                          ],
                        ),
                      ]),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
