import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/screens/programs/program_profile.dart';

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
        padding: const EdgeInsets.only(top: 10.0),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.90,
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
                        padding: const EdgeInsets.all(10.0),
                        child: GestureDetector(
                          onTap: onPressed ??
                              () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ProgramProfile(programId: programId),
                                    ),
                                  ),
                          child: cachedNetworkImage ?? null,
                        ),
                      ),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Container(
                                width: 220,
                                child: Text(
                                  '$programName',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontFamily: 'WorkSans',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  'Institution: ',
                                  style: TextStyle(
                                    fontFamily: 'WorkSans',
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  '$institutionName',
                                  style: TextStyle(
                                    fontFamily: 'WorkSans',
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Container(
                                width: 220,
                                child: Text(
                                  '$programAbout',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 4,
                                  style: TextStyle(
                                    fontFamily: 'WorkSans',
                                    fontSize: 12,
                                    color: Colors.black54,
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

    //   IconCard(
    //   boxWidth: boxWidth ?? 150,
    //   boxHeight: boxHeight ?? 150,
    //   onTap: onPressed ??
    //       () => Navigator.push(
    //             context,
    //             MaterialPageRoute(
    //               builder: (context) => ProgramProfile(programId: programId),
    //             ),
    //           ),
    //   textSize: textSize ?? 15,
    //   cardText: programName ?? "",
    //   cardTextColor: Colors.black54,
    //   cardColor: Theme.of(context).cardColor,
    //   cachedNetworkImage: cachedNetworkImage ?? null,
    // );
  }
}
