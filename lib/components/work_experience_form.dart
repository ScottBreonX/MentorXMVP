import 'dart:ui';

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
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 10.0,
        sigmaY: 10.0,
      ),
      child: Stack(
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
              color: kMentorXPrimary.withOpacity(0.5),
              borderRadius: BorderRadius.circular(Constants.padding),
            ),
            child: ListView(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            'Title',
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextField(
                      decoration: kTextFieldDecorationDark,
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            'Company',
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextField(
                      decoration: kTextFieldDecorationDark,
                      style: TextStyle(color: Colors.white),
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
                          color: Colors.white,
                        ),
                      ),
                    ),
                    TextField(
                      decoration: kTextFieldDecorationDark,
                      style: TextStyle(color: Colors.white),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    RoundedButton(
                      title: 'Save',
                      buttonColor: kMentorXSecondary.withOpacity(0.6),
                      fontColor: Colors.white,
                      fontSize: 20,
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
              backgroundColor: kMentorXPrimary,
              radius: Constants.avatarRadius,
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(Constants.avatarRadius),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(
                    "images/XLogoWhite.png",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: Constants.padding,
            top: 50,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(
                  Icons.save,
                  color: kMentorXSecondary,
                  size: 30,
                ),
              ),
            ),
          ),
          Positioned(
            left: Constants.padding,
            top: 50,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ), // top part
        ],
      ),
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
