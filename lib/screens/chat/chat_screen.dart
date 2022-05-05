import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/alert_dialog.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mentorx_mvp/models/message_model.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../../components/progress.dart';
import '../../models/user.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final programsRef = FirebaseFirestore.instance.collection('institutions');

class ChatScreen extends StatefulWidget {
  final myUser loggedInUser;
  final String mentorUID;
  final String programUID;
  final String matchID;

  const ChatScreen({
    Key key,
    this.loggedInUser,
    this.mentorUID,
    this.programUID,
    this.matchID,
  }) : super(key: key);

  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  bool showSpinner = false;
  String messageText;
  bool canSubmit = false;
  final _formKey1 = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    messageTextController.dispose();
    super.dispose();
  }

  TextFormField _buildMessageInputField() {
    return TextFormField(
      key: _formKey1,
      controller: messageTextController,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      textAlign: TextAlign.start,
      onChanged: (text) {
        setState(() {
          messageText = text;
          if (messageText == null || messageText == '') {
            canSubmit = false;
          } else {
            canSubmit = true;
          }
        });
      },
      style: TextStyle(
        fontFamily: 'WorkSans',
        fontSize: 20,
        color: Colors.black54,
      ),
      autocorrect: true,
      decoration: InputDecoration(
        hintText: 'Type your message here...',
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 20),
        fillColor: Colors.grey.shade200,
        filled: canSubmit ? false : true,
        contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent, width: 2.0),
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 4.0, color: Colors.blue),
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    try {
      messageTextController.clear();
      await programsRef
          .doc(widget.programUID)
          .collection('matchedPairs')
          .doc(widget.matchID)
          .collection('messages')
          .add({
        'text': messageText,
        'sender': widget.loggedInUser.email,
        'senderFName': widget.loggedInUser.firstName,
        'senderLName': widget.loggedInUser.lastName,
        'timestamp': DateTime.now(),
      });
    } catch (e) {
      print(e);
      showAlertDialog(
        context,
        title: "Message Error",
        content: "Message send error, please try again",
        defaultActionText: "Ok",
      );
    }
  }

//  void messagesStream() async {
//    await for (var snapshot in _firestore.collection('messages').snapshots()) {
//      for (var message in snapshot.docs) {}
//    }
//    setState(() {
//      showSpinner = false;
//    });
//  }

  final FocusScopeNode _focusScopeNode = FocusScopeNode();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
        future: usersRef.doc(widget.mentorUID).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }

          myUser mentor = myUser.fromDocument(snapshot.data);

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              leading: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.blue,
                    size: 40,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              title: Text(
                '${mentor.firstName} ${mentor.lastName}',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'WorkSans',
                  color: Colors.black54,
                ),
              ),
              backgroundColor: Colors.transparent,
            ),
            body: ModalProgressHUD(
              inAsyncCall: showSpinner,
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    MessagesStream(
                      loggedInUser: widget.loggedInUser,
                      matchID: widget.matchID,
                      programUID: widget.programUID,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10.0,
                        right: 10.0,
                        bottom: 10,
                      ),
                      child: Divider(
                        thickness: 2,
                        color: Colors.black45,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 20.0, left: 10, right: 10),
                      child: Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: FocusScope(
                                node: _focusScopeNode,
                                child: _buildMessageInputField(),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: GestureDetector(
                                onTap: canSubmit ? _submit : null,
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor:
                                      canSubmit ? Colors.blue : Colors.grey,
                                  child: Icon(
                                    Icons.send,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class MessagesStream extends StatelessWidget {
  const MessagesStream({
    Key key,
    @required this.loggedInUser,
    @required this.programUID,
    @required this.matchID,
  }) : super(key: key);

  final String programUID;
  final myUser loggedInUser;
  final String matchID;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: usersRef.doc(loggedInUser.id).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          myUser user = myUser.fromDocument(snapshot.data);

          return StreamBuilder<QuerySnapshot>(
            stream: programsRef
                .doc(programUID)
                .collection('matchedPairs')
                .doc(matchID)
                .collection('messages')
                .orderBy('timestamp')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return circularProgress();
              }

              final messages = snapshot.data.docs.reversed;
              List<MessageBubble> messageBubbles = [];

              for (var message in messages) {
                final messageData = message;
                MessageModel messageModel =
                    MessageModel.fromDocument(messageData);

                final messageText = messageModel.messageText;
                final senderFName = messageModel.senderFName;
                final senderLName = messageModel.senderLName;
                final messageSender = messageModel.sender;
                final currentUser = user.email;

                final messageBubble = MessageBubble(
                  senderFName: senderFName,
                  senderLName: senderLName,
                  sender: messageSender,
                  text: messageText,
                  isMe: currentUser == messageSender,
                );
                messageBubbles.add(messageBubble);
              }
              return Expanded(
                child: ListView(
                  reverse: true,
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 20.0,
                  ),
                  children: messageBubbles,
                ),
              );
            },
          );
        });
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble(
      {this.text, this.sender, this.isMe, this.senderFName, this.senderLName});

  final String text;
  final String senderFName;
  final String senderLName;
  final String sender;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            width: 200,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Text(
                '$senderFName $senderLName',
                textAlign: isMe ? TextAlign.right : TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.black54,
                ),
              ),
            ),
          ),
          Material(
            borderRadius: BorderRadius.circular(20.0),
            elevation: 5.0,
            color: isMe ? kMentorXPrimary : Colors.grey,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 20.0,
              ),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
