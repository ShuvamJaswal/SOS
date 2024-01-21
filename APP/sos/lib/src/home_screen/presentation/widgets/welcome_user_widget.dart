import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sos/src/auth/data/my_profile.dart';

class WelcomeUserWidget extends StatelessWidget {
  const WelcomeUserWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKeyname = GlobalKey<FormState>();
    final TextEditingController controllerName = TextEditingController();
    return GestureDetector(
      onTap: () async {
        await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Name'),
                content: Form(
                  key: formKeyname,
                  child: TextField(
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(20),
                    ],
                    onChanged: (value) {},
                    controller: controllerName,
                    decoration: const InputDecoration(hintText: "Name"),
                  ),
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        context.pop();
                      },
                      child: const Text('Cancel')),
                  TextButton(
                      onPressed: () async {
                        bool val =
                            formKeyname.currentState?.validate() ?? false;
                        if (!val) {
                          return;
                        }
                        var user = FirebaseAuth.instance.currentUser;
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(user!.uid)
                            .set(
                          {'user': controllerName.text},
                          SetOptions(merge: true),
                        );

                        user.updateDisplayName(controllerName.text);

                        context.pop();
                      },
                      child: const Text('OK'))
                ],
              );
            });
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 100),
            child: Text(
              'Welcome,',
              style: TextStyle(
                letterSpacing: 2,
                color: Colors.red[300],
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Consumer(
            builder: (context, ref, child) {
              return ref.watch(usernameProvider).when(
                    data: (data) => Text(
                      data,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    error: (error, stackTrace) => const Text(''),
                    loading: () => const Text(''),
                  );
            },
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 4),
            child: Icon(Icons.edit, size: 20),
          ),
        ],
      ),
    );
  }
}
