import 'package:flutter/material.dart';

import '../constants.dart';

class WorkExperienceSection extends StatefulWidget {
  const WorkExperienceSection({
    @required this.title,
    @required this.company,
    @required this.dateRange,
    @required this.location,
    @required this.description,
    @required this.dividerColor,
    this.dividerHeight,
    this.dividerThickness,
  });

  final String title;
  final String company;
  final String dateRange;
  final String location;
  final String description;
  final Color dividerColor;
  final double dividerHeight;
  final double dividerThickness;

  @override
  _WorkExperienceSectionState createState() => _WorkExperienceSectionState();
}

class _WorkExperienceSectionState extends State<WorkExperienceSection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Divider(
            height: widget.dividerHeight,
            thickness: widget.dividerThickness,
            color: widget.dividerColor,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, right: 10.0),
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: kMentorXTeal,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, right: 10.0),
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    widget.company,
                    style: TextStyle(
                      fontSize: 15.0,
                      color: kMentorXTeal,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, right: 10.0),
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    widget.dateRange,
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, right: 10.0),
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    widget.location,
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, right: 10.0),
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    widget.description,
                    style: TextStyle(
                      fontSize: 15.0,
                      color: kMentorXTeal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
