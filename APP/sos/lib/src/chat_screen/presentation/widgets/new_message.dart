import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sos/src/auth/data/my_profile.dart';

class NewMessage extends ConsumerStatefulWidget {
  final String userId;
  final String requestId;
  const NewMessage({
    super.key,
    required this.userId,
    required this.requestId,
  });
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewMessageState();
}

class _NewMessageState extends ConsumerState<NewMessage> {
  final _controller = TextEditingController();

  void _sendMessage(String myName) async {
    final firestore = ref.watch(firestoreInstanceProvider);
    firestore
        .collection('users')
        .doc(widget.userId)
        .collection('requests')
        .doc(widget.requestId)
        .collection('messages')
        .add({
      'user': myName,
      'message': _controller.text,
      'timestamp': DateTime.now().microsecondsSinceEpoch,
      'userId': FirebaseAuth.instance.currentUser!.uid,
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _controller,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: InputDecoration(labelText: 'Send a message'),
            ),
          ),
          ref.watch(usernameProvider).when(
              data: (data) {
                return IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _controller.text.isEmpty ? null : _sendMessage(data);
                  },
                  color: Theme.of(context).primaryColor,
                );
              },
              error: (error, stackTrace) => Icon(Icons.send),
              loading: () => Icon(Icons.send))
        ],
      ),
    );
  }
}
