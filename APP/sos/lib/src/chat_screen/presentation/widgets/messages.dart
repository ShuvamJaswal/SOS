// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:sos/globals.dart';
// import 'package:sos/src/chat_screen/presentation/widgets/message_bubble.dart';

// class Messages extends StatelessWidget {
//   final String userId;
//   final String requestId;
//   final DocumentSnapshot<Map<String, dynamic>> docSnap;

//   const Messages({
//     super.key,
//     required this.userId,
//     required this.requestId,
//     required this.docSnap,
//   });
//   Widget buildItem(int index, DocumentSnapshot? document) {
//     if (document != null) {
//       if (document['userId'] == userId) {
//         return Container(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 document['user'],
//                 style: TextStyle(
//                     color: Colors.green[800], fontWeight: FontWeight.bold),
//               ),
//               Text(
//                 document['message'],
//               ),
//             ],
//           ),
//           padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
//           width: 200,
//           decoration: BoxDecoration(
//               color: Colors.red, borderRadius: BorderRadius.circular(8)),
//           margin: EdgeInsets.only(bottom: 10, right: 10, left: 10),
//         );
//       }

//       if (document['userId'] == FirebaseAuth.instance.currentUser!.uid) {
//         return Row(children: <Widget>[
//           Container(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   document['user'],
//                   style: TextStyle(
//                       color: Colors.green[500], fontWeight: FontWeight.bold),
//                 ),
//                 Text(
//                   document['message'],
//                 ),
//               ],
//             ),
//             padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
//             width: 200,
//             decoration: BoxDecoration(
//                 color: const Color.fromARGB(255, 90, 176, 93),
//                 borderRadius: BorderRadius.circular(8)),
//             margin: EdgeInsets.only(bottom: 10, right: 10),
//           ),
//         ], mainAxisAlignment: MainAxisAlignment.end);
//       } else {
//         return Row(
//           children: <Widget>[
//             Container(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     document['user'],
//                     style: TextStyle(
//                         color: Colors.green[400], fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     document['message'],
//                   ),
//                 ],
//               ),
//               padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
//               width: 200,
//               decoration: BoxDecoration(
//                   color: Colors.black12,
//                   borderRadius: BorderRadius.circular(8)),
//               margin: EdgeInsets.only(left: 10, bottom: 10),
//             ),
//           ],
//         );
//       }
//     } else {
//       return SizedBox.shrink();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('users')
//             .doc(userId)
//             .collection('requests')
//             .doc(requestId)
//             .collection('messages')
//             .orderBy('timestamp', descending: true)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//           final chatDocs = snapshot.data!.docs;
//           return ListView.builder(
//             reverse: true,
//             scrollDirection: Axis.vertical,
//             itemBuilder: (ctx, index) => MessageBubble(
//                 document: chatDocs[index],
//                 isAuthor: chatDocs[index]['userId'] == userId,
//                 isMe: chatDocs[index]['userId'] ==
//                     FirebaseAuth.instance.currentUser!.uid),
//             itemCount: chatDocs.length,
//           );
//         });
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sos/src/chat_screen/data/chat_screen_data.dart';
import 'package:sos/src/chat_screen/presentation/widgets/message_bubble.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sos/src/chat_screen/presentation/widgets/shiimer.dart';

class Messages extends ConsumerWidget {
  final String userId;
  final String requestId;
  const Messages({super.key, required this.userId, required this.requestId});
  Widget buildItem(int index, DocumentSnapshot? document) {
    if (document != null) {
      if (document['userId'] == userId) {
        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                document['user'],
                style: TextStyle(
                    color: Colors.green[800], fontWeight: FontWeight.bold),
              ),
              Text(
                document['message'],
              ),
            ],
          ),
          padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
          width: 200,
          decoration: BoxDecoration(
              color: Colors.red, borderRadius: BorderRadius.circular(8)),
          margin: EdgeInsets.only(bottom: 10, right: 10, left: 10),
        );
      }

      if (document['userId'] == FirebaseAuth.instance.currentUser!.uid) {
        return Row(children: <Widget>[
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  document['user'],
                  style: TextStyle(
                      color: Colors.green[500], fontWeight: FontWeight.bold),
                ),
                Text(
                  document['message'],
                ),
              ],
            ),
            padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
            width: 200,
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 90, 176, 93),
                borderRadius: BorderRadius.circular(8)),
            margin: EdgeInsets.only(bottom: 10, right: 10),
          ),
        ], mainAxisAlignment: MainAxisAlignment.end);
      } else {
        return Row(
          children: <Widget>[
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    document['user'],
                    style: TextStyle(
                        color: Colors.green[400], fontWeight: FontWeight.bold),
                  ),
                  Text(
                    document['message'],
                  ),
                ],
              ),
              padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
              width: 200,
              decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(8)),
              margin: EdgeInsets.only(left: 10, bottom: 10),
            ),
          ],
        );
      }
    } else {
      return SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stream =
        ref.watch(messagesDataProvider(requestId: requestId, userId: userId));

    return stream.when(
      data: (data) {
        final chatDocs = data.docs;
        return ListView.builder(
          reverse: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (ctx, index) => MessageBubble2(
              document: chatDocs[index],
              isAuthor: chatDocs[index]['userId'] == userId,
              isMe: chatDocs[index]['userId'] ==
                  FirebaseAuth.instance.currentUser!.uid),
          itemCount: chatDocs.length,
        );
      },
      error: (error, stackTrace) {
        return CircularProgressIndicator();
      },
      loading: () {
        return ShimmerWidget(
            child: ListView.builder(
          itemBuilder: (context, index) => const Card(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: ListTile(
                title: Material(color: Colors.transparent),
                subtitle: Material(
                  color: Colors.black,
                ),
                trailing: Material(),
                leading: Material(
                  color: Colors.black,
                ),
              ),
            ),
          ),
          itemCount: 5,
        ));
      },
    );
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('requests')
            .doc(requestId)
            .collection('messages')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          // print(snapshot);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final chatDocs = snapshot.data!.docs;
          return ListView.builder(
            reverse: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (ctx, index) => MessageBubble2(
                document: chatDocs[index],
                isAuthor: chatDocs[index]['userId'] == userId,
                isMe: chatDocs[index]['userId'] ==
                    FirebaseAuth.instance.currentUser!.uid),
            itemCount: chatDocs.length,
          );
        });
  }
}
