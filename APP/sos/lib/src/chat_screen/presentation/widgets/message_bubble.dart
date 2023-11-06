import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String username;
  MessageBubble(this.message, this.username, this.isMe, {super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            Container(
              // width: 140,
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                color: isMe ? Colors.grey[300] : Colors.pink,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(12),
                  bottomRight: isMe ? Radius.circular(0) : Radius.circular(12),
                ),
              ),
              margin: EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 8,
              ),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    username,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isMe
                          ? Colors.black
                          : Theme.of(context).secondaryHeaderColor,
                    ),
                  ),
                  Text(
                    message,
                    style: TextStyle(
                        color: isMe
                            ? Colors.black
                            : Theme.of(context).secondaryHeaderColor),
                    textAlign: isMe ? TextAlign.end : TextAlign.start,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],

      // overflow: Overflow.visible,
    );
  }
}

class MessageBubble2 extends StatelessWidget {
  final DocumentSnapshot document;
  final bool isMe;
  final bool isAuthor;
  const MessageBubble2(
      {required this.document,
      required this.isMe,
      required this.isAuthor,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      child: Container(
        padding: EdgeInsets.only(
          left: isMe ? MediaQuery.of(context).size.width * .1 : 0,
          right: isMe ? 0 : MediaQuery.of(context).size.width * .1,
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              document['user'],
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 17,
                letterSpacing: 1,
              ),
            ),
            Text(
              document['message'],
              style: TextStyle(
                fontSize: 16,
                color: isAuthor ? Colors.blue[400] : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
