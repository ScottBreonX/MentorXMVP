import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/icon_card.dart';
import 'package:mentorx_mvp/screens/programs/program_profile.dart';

class ProgramTile extends StatelessWidget {
  final String programId;
  final String programName;
  final String institutionName;
  final String type;
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
    return IconCard(
      boxWidth: boxWidth ?? 150,
      boxHeight: boxHeight ?? 150,
      onTap: onPressed ??
          () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProgramProfile(programId: programId),
                ),
              ),
      textSize: textSize ?? 15,
      cardText: programName ?? "",
      cardTextColor: Colors.black54,
      cardColor: Theme.of(context).cardColor,
      // cardColor: type == 'school' ? Theme.of(context).cardColor : null,
      // cardGradient: type != 'school'
      //     ? LinearGradient(
      //         colors: [Colors.grey[700], Colors.grey[200]],
      //         begin: Alignment.bottomLeft,
      //         end: Alignment.topRight,
      //       )
      //     : null,
      cachedNetworkImage: cachedNetworkImage ?? null,
    );
  }
}
