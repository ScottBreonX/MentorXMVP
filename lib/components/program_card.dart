import 'package:flutter/material.dart';

class ProgramCard extends StatelessWidget {
  const ProgramCard({
    Key key,
    this.bodyText,
    this.programTitle,
    this.programTiming,
    this.programIcon,
  }) : super(key: key);

  final String bodyText;
  final String programTitle;
  final String programTiming;
  final IconData programIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: 250,
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
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    programIcon ?? Icons.assignment_rounded,
                    size: 50,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        programTiming ?? 'Upcoming',
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                      Text(
                        programTitle ?? 'TBD',
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        bodyText ?? 'Upcoming program TBD',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
