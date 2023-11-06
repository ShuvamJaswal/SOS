import 'dart:async';
import 'dart:convert';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sos/src/auth/data/my_profile.dart';
import 'package:sos/src/home_screen/data/location_data.dart';
import 'package:http/http.dart' as http;
part 'call_help_controller.g.dart';

enum StatusType { somethingWentWrong, error, loading, notFound, init, done }

final statusUpdateProvider =
    StateNotifierProvider<StatusUpdate, StatusType>((ref) {
  return StatusUpdate();
});

class StatusUpdate extends StateNotifier<StatusType> {
  StatusUpdate() : super(StatusType.init);
  void change(StatusType st) {
    state = st;
  }
}

@riverpod
class CallHelpController extends _$CallHelpController {
  String error = '';
  @override
  FutureOr<String> build() {
    return '';
  }

  String reqId = '';
  Future<void> notifyUsers(List userList, String requestId) async {
    await http.post(Uri.https('sos-server-two.vercel.app', '/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'requestId': requestId,
          'userId': FirebaseAuth.instance.currentUser!.uid,
          'list': userList,
        }));
  }

  Future<String> addRequest(Position Pos) async {
    String time = DateTime.now().millisecondsSinceEpoch.toString();
    final firestore = ref.watch(firestoreInstanceProvider);

    await firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('requests')
        .doc(time)
        .set({
      'time': DateTime.now().millisecondsSinceEpoch.toString(),
      'location': Pos.toString(),
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'requestId': time.toString(),
      'phone': '',
      'description': '',
      'google_url':
          'https://www.google.com/maps/place/${Pos.latitude},${Pos.longitude}'
    }).then((e) {
      debugPrint('added successfully');
    });
    return time;
  }

  Future<String> callHelp() async {
    try {
      final locationDataRepository = ref.watch(locationDataProvider);
      ref.read(statusUpdateProvider.notifier).change(StatusType.loading);
      state = const AsyncLoading();
      Position myPosition = await locationDataRepository.getCurrentLocation();
      List nearbyData =
          await locationDataRepository.getNearbyUsers(10.0, myPosition);
      if (nearbyData.isEmpty) {
        ref.read(statusUpdateProvider.notifier).change(StatusType.notFound);

        return '';
      }
      String requestId = await addRequest(myPosition);
      reqId = requestId;
      await notifyUsers(locationDataRepository.data, requestId);

      ref.read(statusUpdateProvider.notifier).change(StatusType.done);
      return '${FirebaseAuth.instance.currentUser!.uid},${requestId}';
    } catch (e) {
      error = e.toString();
      ref.read(statusUpdateProvider.notifier).change(StatusType.error);
      print(e);
      FirebaseCrashlytics.instance.log(e.toString());
      FirebaseAnalytics.instance.logEvent(name: "testUwU");
      return '';
    }
  }
}
