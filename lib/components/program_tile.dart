import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/icon_card.dart';
import 'package:mentorx_mvp/screens/programs/program_profile.dart';

class ProgramTile extends StatelessWidget {
  final String programId;
  final String programName;
  final String institutionName;
  final String type;
  final Function onPressed;

  ProgramTile({
    this.programId,
    this.programName,
    this.institutionName,
    this.type,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconCard(
      onTap: onPressed ??
          () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProgramProfile(programId: programId),
                ),
              ),
      textSize: 15,
      cardText: '$programName',
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
      imageAsset: Image.asset(
        'assets/images/MLogoBlue.png',
        height: 60,
      ),
    );
  }
}
