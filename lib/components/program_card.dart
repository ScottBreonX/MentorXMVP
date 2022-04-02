import 'package:flutter/material.dart';

class ProgramCard extends StatelessWidget {
  const ProgramCard({
    Key key,
    @required this.programName,
    @required this.programStartDate,
    @required this.programEndDate,
  }) : super(key: key);

  final String programName;
  final String programStartDate;
  final String programEndDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 300,
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
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.school,
                      size: 40,
                    )
                  ],
                ),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        programName ?? 'TBD',
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        programStartDate ?? 'TBD',
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                      Text(
                        ' to ',
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                      Text(
                        programEndDate ?? 'TBD',
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
