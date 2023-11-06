import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sos/src/auth/data/my_profile.dart';
part 'chat_screen_data.g.dart';

@riverpod
Stream<DocumentSnapshot<Map<String, dynamic>>> requestData(RequestDataRef ref,
    {required String userId, required String requestId}) {
  final firestore = ref.watch(firestoreInstanceProvider);

  return firestore
      .collection('users')
      .doc(userId)
      .collection('requests')
      .doc(requestId)
      .snapshots();
}

@riverpod
Stream<QuerySnapshot<Map<String, dynamic>>> messagesData(MessagesDataRef ref,
    {required String userId, required String requestId}) {
  final firestore = ref.watch(firestoreInstanceProvider);

  return firestore
      .collection('users')
      .doc(userId)
      .collection('requests')
      .doc(requestId)
      .collection('messages')
      .orderBy('timestamp', descending: true)
      .snapshots();
}
