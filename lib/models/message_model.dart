import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String sender;
  final String senderFName;
  final String senderLName;
  final String messageText;

  MessageModel(
      {this.sender, this.senderFName, this.senderLName, this.messageText});

  factory MessageModel.fromDocument(DocumentSnapshot doc) {
    return MessageModel(
      sender: doc['sender'],
      senderFName: doc['senderFName'],
      senderLName: doc['senderLName'],
      messageText: doc['text'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'sender': sender,
      'senderFName': senderFName,
      'senderLName': senderLName,
      'messageText': messageText,
    };
  }
}
