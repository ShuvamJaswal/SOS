import 'dart:isolate';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sos/src/auth/data/my_profile.dart';
import 'package:sos/src/chat_screen/data/chat_screen_data.dart';
import 'package:sos/src/chat_screen/presentation/widgets/chip_widget.dart';
import 'package:sos/src/chat_screen/presentation/widgets/description_widget.dart';
import 'package:sos/src/chat_screen/presentation/widgets/messages.dart';
import 'package:sos/src/chat_screen/presentation/widgets/new_message.dart';
import 'package:sos/src/chat_screen/presentation/widgets/shiimer.dart';
import 'package:sos/src/home_screen/data/location_data.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class ChatS extends ConsumerStatefulWidget {
  ChatS({super.key, required this.userId, required this.requestId});
  final String userId;
  final String requestId;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatSState();
}

class _ChatSState extends ConsumerState<ChatS> {
  @override
  void initState() {
    print("initstate chat");
    super.initState();
    final firestore = ref.read(firestoreInstanceProvider);
    final user = ref.read(userIdProvider);
    firestore
        .collection('users')
        .doc(user.uid)
        .collection('history')
        .doc(widget.requestId)
        .set({
      'time': DateTime.now().millisecondsSinceEpoch.toString(),
      'userId': widget.userId,
      'requestId': widget.requestId.toString(),
    }, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    print("initstate chat");
    final stream = ref.watch(requestDataProvider(
        requestId: widget.requestId, userId: widget.userId));
    return Scaffold(
      appBar: RequestAppBar(
          requestId: widget.requestId, userId: widget.userId, stream: stream),
      body: RequestBody(
          requestId: widget.requestId, userId: widget.userId, stream: stream),
    );
  }
}

class RequestAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const RequestAppBar(
      {super.key,
      required this.userId,
      required this.requestId,
      required this.stream});
  final AsyncValue stream;
  final String userId;
  final String requestId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return stream.when(
        data: (data) {
          print(data);
          return AppBar(
            titleSpacing: 0,
            toolbarHeight: 100,
            actions: [
              IconButton(
                  onPressed: () async {
                    final firestore = ref.watch(firestoreInstanceProvider);

                    await firestore
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection('history')
                        .doc(requestId)
                        .set({
                      'time': DateTime.now().millisecondsSinceEpoch.toString(),
                      'userId': userId,
                      'requestId': requestId.toString(),
                    }, SetOptions(merge: true));
                  },
                  icon: const Icon(Icons.save))
            ],
            title: ListTile(
                title: Text(
                  ref.read(userIdProvider).displayName ?? 'User',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: data.data()?['time'] != null
                    ? Text(
                        DateFormat("dd/MM/yy 'at' HH:mm").format(
                            DateTime.fromMillisecondsSinceEpoch(
                                int.parse(data.data()!['time']))),
                      )
                    : SizedBox.shrink()),
            leadingWidth: 30,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(20),
              child: RequestBottomBar(
                data: data,
                isAuthor: userId == FirebaseAuth.instance.currentUser!.uid,
                isLoading: false,
              ),
            ),
          );
        },
        error: (error, stackTrace) => Text(error.toString()),
        loading: () => AppBar(
              titleSpacing: 0,
              toolbarHeight: 100,
              actions: [
                // IconButton(onPressed: null, icon: const Icon(Icons.save))
              ],
              title: ListTile(
                title: ShimmerWidget(
                    child: Padding(
                  padding: const EdgeInsets.only(right: 82.0, top: 10),
                  child: Container(
                    width: 80,
                    height: 15,
                    decoration: BoxDecoration(
                      color: Colors.black,
                    ),
                  ),
                )),
                subtitle: ShimmerWidget(
                    child: Padding(
                  padding: const EdgeInsets.only(right: 120.0, top: 5),
                  child: Container(
                    width: 40,
                    height: 15,
                    decoration: BoxDecoration(
                      color: Colors.black,
                    ),
                  ),
                )),
              ),
              leadingWidth: 30,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(20),
                child: RequestBottomBar(
                  isAuthor: userId == FirebaseAuth.instance.currentUser!.uid,
                  isLoading: true,
                ),
              ),
            ));
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}

class RequestBottomBar extends ConsumerWidget {
  const RequestBottomBar(
      {super.key, this.isAuthor = false, this.data, this.isLoading = false});
  final bool isAuthor;
  final DocumentSnapshot? data;
  final bool isLoading;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isLoading) {
      return Wrap(spacing: 6.0, runSpacing: 6.0, children: [
        const ShimmerWidget(
          child: Chip(
            backgroundColor: Colors.black,
            label: SizedBox(
              width: 100,
            ),
          ),
        ),
        if (isAuthor)
          const ShimmerWidget(
            child: Chip(
                backgroundColor: Colors.black,
                label: SizedBox(
                  width: 100,
                )),
          )
      ]);
    }
    String userId = data!.get('userId');
    String requestId = data!.get('requestId');
    return Wrap(
      spacing: 6.0,
      runSpacing: 6.0,
      children: [
        ChipWidget(
          label: !isAuthor ? 'Location' : 'Refresh Location',
          icon: const Icon(Icons.map_sharp),
          onTap: () async {
            if (!isAuthor) {
              launchUrlString(data!.get('google_url'),
                  mode: LaunchMode.externalApplication);
              return;
            }
            String userId = data!.get('userId');
            String requestId = data!.get('requestId');
            Position position =
                await ref.read(locationDataProvider).getCurrentLocation();
            final firestore = ref.watch(firestoreInstanceProvider);

            await firestore
                .collection('users')
                .doc(userId)
                .collection('requests')
                .doc(requestId)
                .set(
              {
                'location': position.toString(),
                'google_url':
                    'https://www.google.com/maps/place/${position.latitude},${position.longitude}'
              },
              SetOptions(merge: true),
            );
          },
        ),
        Builder(
          builder: (context) => !isAuthor
              ? data!['phone'].toString().isEmpty
                  ? const SizedBox.shrink()
                  : ChipWidget(
                      icon: const Icon(Icons.phone),
                      label: data!['phone'].toString(),
                      onTap: () {
                        launchUrlString('tel:+${data!['phone'].toString()}');
                      })
              : ChipWidget(
                  icon: const Icon(Icons.phone),
                  label: data!['phone'].toString().isEmpty
                      ? "Add Phone number"
                      : data!['phone'].toString(),
                  onTap: () async {
                    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

                    final TextEditingController controller =
                        TextEditingController();
                    PhoneNumber number = PhoneNumber(
                        isoCode: 'IN',
                        phoneNumber: data!['phone'].toString().isEmpty
                            ? null
                            : data!['phone'].toString());

                    await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          actions: [
                            TextButton(
                                onPressed: () {
                                  context.pop();
                                },
                                child: const Text('Cancel')),
                            TextButton(
                                onPressed: () {
                                  bool vali =
                                      formKey.currentState?.validate() ?? false;
                                  if (!vali) {
                                    return;
                                  }
                                  formKey.currentState?.save();
                                },
                                child: const Text('Ok'))
                          ],
                          content: Form(
                            key: formKey,
                            child: InternationalPhoneNumberInput(
                              spaceBetweenSelectorAndTextField: 2,
                              onInputChanged: (PhoneNumber number) {},
                              selectorConfig: const SelectorConfig(
                                setSelectorButtonAsPrefixIcon: true,
                                selectorType: PhoneInputSelectorType.DIALOG,
                              ),
                              ignoreBlank: false,
                              autoValidateMode:
                                  AutovalidateMode.onUserInteraction,
                              selectorTextStyle:
                                  const TextStyle(color: Colors.black),
                              initialValue: number,
                              textFieldController: controller,
                              formatInput: true,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      signed: true, decimal: true),
                              onSaved: (PhoneNumber number) {
                                final firestore =
                                    ref.watch(firestoreInstanceProvider);
                                firestore
                                    .collection('users')
                                    .doc(userId)
                                    .collection('requests')
                                    .doc(requestId)
                                    .update({'phone': number.phoneNumber});
                                context.pop();
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class RequestBody extends ConsumerWidget {
  const RequestBody({
    super.key,
    required this.userId,
    required this.requestId,
    required this.stream,
  });
  final String userId;
  final String requestId;
  final AsyncValue stream;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(children: [
      DescriptionWidget(
        stream: stream,
        requestId: requestId,
        userId: userId,
      ),
      Expanded(
          child: Messages(
        userId: userId,
        requestId: requestId,
      )),
      NewMessage(
        userId: userId,
        requestId: requestId,
      )
    ]);
  }
}
