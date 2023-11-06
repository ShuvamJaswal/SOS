import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:sos/src/auth/data/my_profile.dart';
part 'onboarding_provider.g.dart';

@Riverpod(keepAlive: true)
StreamController appState(AppStateRef ref) {
  return StreamController<int>.broadcast();
}

class OnboardingRepository {
  final MyProfile profile;
  final FirebaseFirestore firestore;
  OnboardingRepository({required this.profile, required this.firestore});
  Future<UserCredential> signInAnonymously() async {
    UserCredential user = await profile.signInAnonymously();
    if (user.user!.displayName.toString() == 'null' ||
        user.user!.displayName.toString() == '') {
      await firestore
          .collection('users')
          .doc(user.user!.uid)
          .set({'user': 'user' + user.user!.uid.toString().substring(0, 4)});
      user.user!.updateDisplayName(
          'user${user.user!.uid.toString().substring(0, 4)}');
    }
    FirebaseCrashlytics.instance.setUserIdentifier(user.user!.uid);
    return user;
  }

  Future<bool> onBoardingComplete() async {
    return (await Geolocator.isLocationServiceEnabled() &&
        (await Geolocator.checkPermission() == LocationPermission.whileInUse ||
            await Geolocator.checkPermission() == LocationPermission.always) &&
        FirebaseAuth.instance.currentUser != null);
  }
}

@Riverpod(keepAlive: true)
OnboardingRepository onboardingrepository(OnboardingrepositoryRef ref) {
  final myProfile = ref.watch(myProfileProvider);
  final firestore = ref.watch(firestoreInstanceProvider);

  return OnboardingRepository(profile: myProfile, firestore: firestore);
}
