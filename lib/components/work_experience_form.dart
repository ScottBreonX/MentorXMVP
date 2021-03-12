import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';

import '../constants.dart';

class WorkExperienceForm extends StatefulWidget {
  const WorkExperienceForm({
    Key key,
    @required this.title,
    @required this.descriptions,
    @required this.textLeft,
    @required this.textRight,
    @required this.leftOnPressed,
    @required this.rightOnPressed,
    this.titleFontSize,
    this.descriptionFontSize,
  });

  final String title;
  final double titleFontSize;
  final String descriptions;
  final double descriptionFontSize;
  final String textLeft;
  final String textRight;
  final Function leftOnPressed;
  final Function rightOnPressed;

  @override
  _WorkExperienceFormState createState() => _WorkExperienceFormState();
}

class _WorkExperienceFormState extends State<WorkExperienceForm> {
  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          height: double.infinity,
          width: double.infinity,
          padding: EdgeInsets.only(
              left: Constants.padding,
              top: Constants.avatarRadius + Constants.padding,
              right: Constants.padding,
              bottom: Constants.padding),
          margin: EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constants.padding),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  offset: Offset(0, 10),
                  blurRadius: 10,
                ),
              ]),
          child: ListView(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Title',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: kMentorXTeal,
                      ),
                    ),
                  ),
                  TextField(
                    decoration: kTextFieldDecorationLight,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Company',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: kMentorXTeal,
                      ),
                    ),
                  ),
                  TextField(
                    decoration: kTextFieldDecorationLight,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Start Date',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: kMentorXTeal,
                      ),
                    ),
                  ),
                  TextField(
                    decoration: kTextFieldDecorationLight,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'End Date',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: kMentorXTeal,
                      ),
                    ),
                  ),
                  TextField(
                    decoration: kTextFieldDecorationLight,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: kMentorXTeal,
                      ),
                    ),
                  ),
                  TextField(
                    decoration: kTextFieldDecorationLight,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  RoundedButton(
                    title: 'Save',
                    buttonColor: kMentorXTeal,
                    fontColor: Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    minWidth: 300,
                  )
                ],
              ),
            ],
          ),
        ),
        Positioned(
          left: Constants.padding,
          right: Constants.padding,
          child: CircleAvatar(
            backgroundColor: kMentorXTeal,
            radius: Constants.avatarRadius,
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(Constants.avatarRadius),
              ),
              child: Image.asset("images/XLogoWhite.png"),
            ),
          ),
        ), // top part
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }
}
