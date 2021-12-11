import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/icon_card.dart';
import 'package:mentorx_mvp/screens/profile/profile_screen.dart';

class ProgramTile extends StatelessWidget {
  final String programId;
  final String programName;
  final String institutionName;
  final String type;

  ProgramTile({
    this.programId,
    this.programName,
    this.institutionName,
    this.type,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {},
      child: Container(
        child: IconCard(
          onTap: () {},
          cardText: '$programName',
          cardColor: type == 'school' ? Theme.of(context).cardColor : null,
          cardGradient: type != 'school'
              ? LinearGradient(
                  colors: [Colors.grey[700], Colors.grey[200]],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                )
              : null,
          borderColor: Colors.blue,
          borderWidth: 5,
          imageAsset: Image.asset(
            'assets/images/MLogoBlue.png',
            height: 60,
          ),
        ),
      ),
    );
  }
}
