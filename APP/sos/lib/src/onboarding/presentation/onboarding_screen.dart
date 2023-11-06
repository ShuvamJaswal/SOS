import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:sos/main.dart';
import 'package:sos/src/home_screen/data/location_data.dart';
import 'package:sos/src/onboarding/data/onboarding_provider.dart';
import 'package:sos/src/routing/app_router.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  void didChangeDependencies() {
    super.didChangeDependencies();
    onBoarding();
  }

  Future<void> onBoarding() async {
    await ref.read(onboardingrepositoryProvider).signInAnonymously();
  }

  @override
  Widget build(BuildContext context) {
    Geolocator.getServiceStatusStream().listen((event) => setState(() {}));
    return Scaffold(
      body: Container(
        color: Colors.blue,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder(
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      if (snapshot.data == LocationPermission.denied ||
                          snapshot.data == LocationPermission.deniedForever) {
                        return Center(
                          child: Row(
                            children: [
                              Text("Please enable Location permission"),
                              TextButton(
                                  onPressed: () async {
                                    if (snapshot.data ==
                                        LocationPermission.denied) {
                                      await Geolocator.requestPermission();
                                    } else {
                                      await Geolocator.openAppSettings();
                                    }
                                    setState(() {});
                                  },
                                  child: Text('Turn on'))
                            ],
                          ),
                        );
                      } else {
                        return Text('Location is on');
                      }
                    }
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
                future: Geolocator.checkPermission(),
              ),
              FutureBuilder(
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    final data = snapshot.data as bool;

                    if (!data) {
                      return Center(
                        child: Row(
                          children: [
                            Text("Please enable GPS"),
                            TextButton(
                                onPressed: () async {
                                  await Geolocator.openLocationSettings();
                                  setState(() {});
                                },
                                child: Text('Turn on'))
                          ],
                        ),
                      );
                    } else {
                      return Text('GPS is on');
                    }
                  } else {
                    return CircularProgressIndicator();
                  }
                },
                future: Geolocator.isLocationServiceEnabled(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
