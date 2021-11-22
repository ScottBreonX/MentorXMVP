import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/profile_image_circle.dart';
import 'package:mentorx_mvp/models/profile_model.dart';
import '../constants.dart';

class MenteeCard extends StatelessWidget {
  ProfileModel user;
  final Color cardColor;
  final Color cardTextColor;
  final Function onTap;
  final double primaryTextSize;
  final double secondaryTextSize;
  final double boxHeight;
  final double boxWidth;

  MenteeCard({
    Key key,
    @required this.user,
    this.cardTextColor,
    this.onTap,
    this.cardColor,
    this.primaryTextSize,
    this.secondaryTextSize,
    this.boxHeight,
    this.boxWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {},
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Padding(
//             padding: EdgeInsets.fromLTRB(0, 35, 0, 0),
//           ),
//           // Image.network(user.photoUrl),
//           ProfileImageCircle(
//               iconSize: 75, circleSize: 100), // image placeholder
//           SizedBox(height: 15.0),
//           Text(
//             user.fName,
//             style: TextStyle(
//               fontSize: 24,
//               color: Colors.black,
//             ),
//           ),
//           Text(user.major,
//               style: TextStyle(
//                 fontSize: 18,
//                 color: Colors.black,
//               )),
//         ],
//       ),
//     );
//   }
// }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                blurRadius: 2,
                offset: Offset(2, 3),
                color: Colors.grey[700],
              ),
            ],
            color: cardColor ?? kMentorXPrimary,
//            color: Colors.blue,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ProfileImageCircle(
                iconSize: 150,
                circleSize: 100,
                circleColor: Colors.grey[700],
              ), // image placeholder
              SizedBox(height: 5.0),
              SizedBox(
                height: 5,
              ),
              Text(
                user.fName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: cardTextColor ?? Colors.white,
                  fontSize: primaryTextSize ?? 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                user.major,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: cardTextColor ?? Colors.white,
                  fontSize: secondaryTextSize ?? 20,
                ),
              ),
            ],
          ),
          height: boxHeight ?? 150,
          width: boxWidth ?? 450,
        ),
      ),
    );
  }
}
