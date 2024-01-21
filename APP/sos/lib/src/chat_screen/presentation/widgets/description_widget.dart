import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sos/src/auth/data/my_profile.dart';
import 'package:sos/src/chat_screen/data/chat_screen_data.dart';

class DescriptionWidget extends ConsumerWidget {
  const DescriptionWidget(
      {super.key,
      required this.stream,
      required this.requestId,
      required this.userId});
  final AsyncValue stream;
  final String userId;
  final String requestId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return stream.when(
        loading: () => Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16),
            )),
        error: (error, stackTrace) => Center(
              child: Text(
                ('No description.'),
              ),
            ),
        data: (data) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    const Text('Description'),
                    userId == ref.read(userIdProvider).uid
                        ? IconButton(
                            onPressed: () async {
                              final GlobalKey<FormState> formKeyD =
                                  GlobalKey<FormState>();
                              final TextEditingController controllerD =
                                  TextEditingController();
                              controllerD.text =
                                  data.data()!['description'].toString();
                              await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Description'),
                                      content: Form(
                                        key: formKeyD,
                                        child: TextField(
                                          keyboardType: TextInputType.multiline,
                                          maxLines: null,
                                          onChanged: (value) {},
                                          controller: controllerD,
                                          decoration: const InputDecoration(
                                              hintText: "Description"),
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              context.pop();
                                            },
                                            child: const Text('Cancel')),
                                        TextButton(
                                            onPressed: () {
                                              bool vali = formKeyD.currentState
                                                      ?.validate() ??
                                                  false;
                                              if (!vali) {
                                                return;
                                              }
                                              final firestore = ref.watch(
                                                  firestoreInstanceProvider);
                                              firestore
                                                  .collection('users')
                                                  .doc(userId)
                                                  .collection('requests')
                                                  .doc(requestId)
                                                  .set({
                                                'description': controllerD.text
                                              }, SetOptions(merge: true));
                                              context.pop();
                                            },
                                            child: const Text('Ok'))
                                      ],
                                    );
                                  });
                            },
                            icon: const Icon(Icons.edit))
                        : const SizedBox.shrink()
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(data.data()!['description'].toString().isEmpty
                        ? "No Desrciption Provided"
                        : data.data()!['description'].toString()),
                  ),
                ),
              )
            ],
          );
        });
  }
}
