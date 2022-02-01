import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';

import '../../../constants.dart';

class WorkExperienceEdit extends StatefulWidget {
  const WorkExperienceEdit();

  @override
  _WorkExperienceEditState createState() => _WorkExperienceEditState();
}

class _WorkExperienceEditState extends State<WorkExperienceEdit> {
  String companyText;
  final _formKey1 = GlobalKey<FormState>();
  TextFormField _buildCompanyTextField(String userCompanyText) {
    return TextFormField(
      key: _formKey1,
      initialValue: userCompanyText,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      textAlign: TextAlign.start,
      onChanged: (value) => companyText = value,
      style: Theme.of(context).textTheme.subtitle2,
      autocorrect: false,
      decoration: kTextFieldDecoration.copyWith(fillColor: Colors.white),
    );
  }

  String titleText;
  final _formKey2 = GlobalKey<FormState>();
  TextFormField _buildTitleTextField(String userTitleText) {
    return TextFormField(
      key: _formKey2,
      initialValue: userTitleText,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      textAlign: TextAlign.start,
      onChanged: (value) => titleText = value,
      style: Theme.of(context).textTheme.subtitle2,
      autocorrect: false,
      decoration: kTextFieldDecoration.copyWith(fillColor: Colors.white),
    );
  }

  String startText;
  final _formKey3 = GlobalKey<FormState>();
  TextFormField _buildStartTextField(String userStartText) {
    return TextFormField(
      key: _formKey3,
      initialValue: userStartText,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      textAlign: TextAlign.start,
      onChanged: (value) => startText = value,
      style: Theme.of(context).textTheme.subtitle2,
      autocorrect: false,
      decoration: kTextFieldDecoration.copyWith(fillColor: Colors.white),
    );
  }

  String endText;
  final _formKey4 = GlobalKey<FormState>();
  TextFormField _buildEndTextField(String userEndText) {
    return TextFormField(
      key: _formKey4,
      initialValue: userEndText,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      textAlign: TextAlign.start,
      onChanged: (value) => endText = value,
      style: Theme.of(context).textTheme.subtitle2,
      autocorrect: false,
      decoration: kTextFieldDecoration.copyWith(fillColor: Colors.white),
    );
  }

  String descriptionText;
  final _formKey5 = GlobalKey<FormState>();
  TextFormField _buildDescriptionTextField(String descriptionText) {
    return TextFormField(
      key: _formKey5,
      initialValue: descriptionText,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      textAlign: TextAlign.start,
      onChanged: (value) => descriptionText = value,
      style: Theme.of(context).textTheme.subtitle2,
      autocorrect: false,
      decoration: kTextFieldDecoration.copyWith(fillColor: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20.0,
        bottom: 20.0,
        right: 10.0,
        left: 10.0,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withOpacity(1.0),
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[700],
                  blurRadius: 5,
                  offset: Offset(5, 5),
                ),
              ],
              color: Theme.of(context).backgroundColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, right: 0.0),
                    child: Row(
                      children: [
                        GestureDetector(
                          child: Icon(
                            Icons.close_rounded,
                            color: Colors.pink,
                            size: 40,
                          ),
                          onTap: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0, right: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                'Job Title',
                                style: Theme.of(context).textTheme.headline4,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Container(
                                child: _buildTitleTextField('Finance Intern'),
                                width: 300,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, right: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                'Company',
                                style: Theme.of(context).textTheme.headline4,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Container(
                                child: _buildCompanyTextField('Disney'),
                                width: 300,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, right: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Start',
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Container(
                                child: _buildStartTextField('May 2020'),
                                width: 150,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'End',
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Container(
                                child: _buildEndTextField('Aug 2020'),
                                width: 150,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, right: 10.0),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Description',
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Container(
                                child: _buildDescriptionTextField(
                                    'Test description text'),
                                width: 330,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RoundedButton(
                        title: 'Cancel',
                        minWidth: 150,
                        buttonColor: Colors.white,
                        fontColor: Colors.black54,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      RoundedButton(
                        title: 'Save',
                        minWidth: 150,
                        buttonColor: Colors.blue,
                        fontColor: Colors.white,
                        onPressed: () {},
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
