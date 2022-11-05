import 'package:flutter/material.dart';

class NotesTile extends StatelessWidget {
  final String titleText;
  final String noteText;
  final String noteID;

  NotesTile({
    this.titleText,
    this.noteText,
    this.noteID,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {},
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 10,
          child: Container(
            width: 220,
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 350,
                  child: Center(
                    child: Text(
                      '$titleText',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontFamily: 'WorkSans',
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
