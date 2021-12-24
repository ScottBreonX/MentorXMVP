import 'package:flutter/material.dart';

class ConnectionCard extends StatelessWidget {
  const ConnectionCard({
    Key key,
    @required this.mentorClass,
    @required this.mentorFName,
    @required this.mentorLName,
    this.mentorClassTextColor,
  }) : super(key: key);

  final String mentorClass;
  final String mentorFName;
  final String mentorLName;
  final Color mentorClassTextColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          mentorClass,
                          style: Theme.of(context).textTheme.headline3.copyWith(
                              fontSize: 15,
                              color: mentorClassTextColor ?? null),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          mentorFName,
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              .copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          mentorLName,
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              .copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 30,
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 40.0,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                child: VerticalDivider(
                  color: Colors.black54,
                  thickness: 2,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.green,
                      radius: 25,
                      child: Icon(
                        Icons.chat_rounded,
                        color: Colors.white,
                        size: 30.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Text('Chat'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.pink,
                      radius: 25,
                      child: Icon(
                        Icons.calendar_today_rounded,
                        color: Colors.white,
                        size: 30.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Text('Meet'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: 25,
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Text('Profile'),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
