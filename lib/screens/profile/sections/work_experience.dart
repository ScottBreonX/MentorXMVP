import 'package:flutter/material.dart';
import '../../../components/progress.dart';
import '../../launch_screen.dart';

class WorkExperienceSection extends StatefulWidget {
  const WorkExperienceSection({
    this.profileId,
    @required this.myProfileView,
    Key key,
  });

  final String profileId;
  final bool myProfileView;

  @override
  _WorkExperienceSectionState createState() => _WorkExperienceSectionState();
}

class _WorkExperienceSectionState extends State<WorkExperienceSection> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
        future: usersRef.doc(widget.profileId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          return Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          'Summer Intern',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {});
                          },
                          child: Icon(
                            Icons.edit,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        'The Walt Disney Company',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2
                            .copyWith(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('May', style: Theme.of(context).textTheme.headline5),
                    Text(' 2020', style: Theme.of(context).textTheme.headline5),
                    Text(' - ', style: Theme.of(context).textTheme.headline5),
                    Text('Aug', style: Theme.of(context).textTheme.headline5),
                    Text(' 2020', style: Theme.of(context).textTheme.headline5),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 8.0, right: 10.0, bottom: 10.0),
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          'Financial planning, forecasting and other ad hoc analysis for the resort business planning and analysis center at Walt Disney World',
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
