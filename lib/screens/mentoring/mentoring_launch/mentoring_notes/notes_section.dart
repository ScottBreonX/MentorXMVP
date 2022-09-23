import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../../constants.dart';

final usersRef = FirebaseFirestore.instance.collection('users');

class NoteSection extends StatefulWidget {
  const NoteSection();

  @override
  _NoteSectionState createState() => _NoteSectionState();
}

class _NoteSectionState extends State<NoteSection> {
  @override
  void initState() {
    super.initState();
  }

  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            key: _formKey1,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.subtitle2,
            autocorrect: false,
            decoration: kTextFieldDecoration.copyWith(fillColor: Colors.white),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            key: _formKey2,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.subtitle2,
            autocorrect: false,
            decoration: kTextFieldDecoration.copyWith(fillColor: Colors.white),
          ),
        ),
      ],
    );
  }
}
