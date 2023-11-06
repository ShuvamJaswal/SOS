import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sos/src/auth/data/my_profile.dart';
import 'package:sos/src/home_screen/data/call_help_controller.dart';

class StatusWidget extends ConsumerWidget {
  const StatusWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (ref.watch(statusUpdateProvider)) {
      case StatusType.loading:
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: Colors.yellow[100],
              borderRadius: BorderRadius.circular(8),
              shape: BoxShape.rectangle,
            ),
            child: const Center(
              child: Text(
                "Please Wait",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 23,
                ),
              ),
            ),
          ),
        );
      case StatusType.error:
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: Colors.red[100],
              borderRadius: BorderRadius.circular(8),
              shape: BoxShape.rectangle,
            ),
            child: Center(
              child: Text(
                // ref.read(callHelpControllerProvider.notifier).error,
                "Something went wrong",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 23,
                ),
              ),
            ),
          ),
        );

      case StatusType.done:
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: GestureDetector(
            onTap: () {
              String userId = ref.watch(userIdProvider).uid;
              ref.read(statusUpdateProvider.notifier).change(StatusType.init);

              context.push(
                  '/chat?requestId=${ref.read(callHelpControllerProvider.notifier).reqId}&userId=$userId');
            },
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.green[200],
                borderRadius: BorderRadius.circular(8),
                shape: BoxShape.rectangle,
              ),
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      "Success",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        // color: Colors.white,
                        fontSize: 23,
                      ),
                    ),
                    Text(
                      " Click to chat",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      case StatusType.notFound:
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: Colors.red[100],
              borderRadius: BorderRadius.circular(8),
              shape: BoxShape.rectangle,
            ),
            child: const Center(
              child: Text(
                "No Nearby User found",
                textAlign: TextAlign.center,
                style: TextStyle(
                  // color: Colors.white,
                  fontSize: 23,
                ),
              ),
            ),
          ),
        );
      default:
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            height: 60,
          ),
        );
    }
  }
}
