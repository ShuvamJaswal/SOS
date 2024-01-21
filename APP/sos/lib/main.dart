import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sos/src/auth/data/my_profile.dart';
import 'package:sos/src/onboarding/data/onboarding_provider.dart';
import 'firebase_options.dart';
import 'src/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geolocator/geolocator.dart';

final liveLocProvider = StreamProvider<Position>((ref) {
  return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
    distanceFilter: 500,
  ));
});

class LiveLocationService {
  LiveLocationService(this.ref) {
    // s = ref.watch(liveLocProvider);
    _init();
    initial();
  }
  bool hasLocation() {
    return s != null;
  }

  final Ref ref;
  AsyncValue? s;
  Future<void> initial() async {
    print("Call initial");
    Position p = await Geolocator.getCurrentPosition();
    print("$p from initial");
    s = AsyncValue.data(p);
    GeoFirePoint geoFirePoint =
        GeoFlutterFire().point(latitude: p.latitude, longitude: p.longitude);
    await ref.watch(onboardingrepositoryProvider).signInAnonymously();
    String user = FirebaseAuth.instance.currentUser!.uid;
    String? token = await FirebaseMessaging.instance.getToken();
    FirebaseFirestore.instance.collection('users').doc(user).set(
      {'position': geoFirePoint.data, 'message_token': token},
      SetOptions(merge: true),
    );
  }

  void _init() async {
    print("Call _init");
    String? token = await FirebaseMessaging.instance.getToken();
    // await Future.delayed(Duration(seconds: 2));

    ref.listen<AsyncValue<Position>>(liveLocProvider, (previous, next) {
      print("$previous, $next");
      final linkData = next.value;

      if (linkData != null) {
        GeoFirePoint geoFirePoint = GeoFlutterFire()
            .point(latitude: linkData.latitude, longitude: linkData.longitude);
        ref.watch(onboardingrepositoryProvider).signInAnonymously();
        String user = FirebaseAuth.instance.currentUser!.uid;
        print("$user from _init method.");
        FirebaseFirestore.instance.collection('users').doc(user).set(
            {'position': geoFirePoint.data, 'message_token': token},
            SetOptions(merge: true));
      }
    });
  }
}

final liveLocationServiceProvider = Provider<LiveLocationService>((ref) {
  return LiveLocationService(ref);
});

void main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    if (await Geolocator.checkPermission() == LocationPermission.denied) {
      LocationPermission per = await Geolocator.requestPermission();
      print(per);
    }

    final messaging = FirebaseMessaging.instance;

    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      provisional: false,
      sound: true,
    );
    var token = await messaging.getToken();
    print("Messaging Token: $token");
    final container = ProviderContainer();
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
      playSound: true,
      enableLights: true,
      enableVibration: true,
      showBadge: true,
    );

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    container.read(liveLocationServiceProvider);
    runApp(
      UncontrolledProviderScope(
        container: container,
        child: const MyApp(),
      ),
    );
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
}
