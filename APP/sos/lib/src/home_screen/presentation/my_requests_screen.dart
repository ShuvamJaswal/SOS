import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class MyRequestsScreen extends ConsumerWidget {
  const MyRequestsScreen({super.key, required this.requestsQuery});
  final Query<Map<String, dynamic>> requestsQuery;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FirestoreListView<Map<String, dynamic>>(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      query: requestsQuery,
      itemBuilder: (context, snapshot) {
        Map<String, dynamic> request = snapshot.data();
        return ListTile(
          onTap: () => context.push(
              '/chat?requestId=${request['requestId']}&userId=${request['userId']}'),
          title: Text('Request ${request['requestId']}'),
          subtitle: Text(
              '${DateFormat("dd/MM/yy 'at' HH:mm").format(DateTime.fromMillisecondsSinceEpoch(int.parse(request['requestId'])))}'),
        );
      },
    );
  }
}
