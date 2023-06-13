import 'package:flutter/material.dart';

class PayingItForward01DataV1 extends StatelessWidget {
  const PayingItForward01DataV1({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'As you progress through your academic journey, taking the time to pause and reflect is crucial.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'Montserrat',
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Text(
            'Sharing what you’ve learned  is integral to leaving a legacy and positive impact. Attending panels, coffee chats, answering cold calls/emails, are all examples of ways to pay it forward.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
      ],
    );
  }
}
