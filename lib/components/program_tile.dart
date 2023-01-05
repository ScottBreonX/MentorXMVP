import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/screens/programs/program_profile.dart';

import '../constants.dart';

class ProgramTile extends StatelessWidget {
  final String programId;
  final String programName;
  final String institutionName;
  final String type;
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
    this.type,
    this.onPressed,
    this.boxHeight,
    this.boxWidth,
    this.textSize,
    this.imageHeight,
    this.imageAsset,
    this.cachedNetworkImage,
    this.imageContainer,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ??
          () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProgramProfile(programId: programId),
                ),
              ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 10,
            child: Column(
              children: [
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: GestureDetector(
                          onTap: onPressed ??
                              () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ProgramProfile(programId: programId),
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
                                    '$programName $programName',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  'Institution: ',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 10,
                                    color: kMentorXPSecondary,
                                  ),
                                ),
                                Text(
                                  '$institutionName',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 10,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 5.0, bottom: 10),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.70,
                                child: Text(
                                  '$programAbout',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 12,
                                    color: Colors.black45,
                                  ),
                                ),
                              ),
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
