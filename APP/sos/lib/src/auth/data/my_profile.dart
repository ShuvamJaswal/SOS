import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sos/src/onboarding/data/onboarding_provider.dart';
part 'my_profile.g.dart';

class MyProfile {
  Future<User> signInAnonymously() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    if (FirebaseAuth.instance.currentUser == null) {
      final UserCredential userCredential = await auth.signInAnonymously();
      return userCredential.user!;
    } else {
      return FirebaseAuth.instance.currentUser!;
    }
  }
}

@riverpod
Stream username(UsernameRef ref) {
  final firestore = ref.watch(firestoreInstanceProvider);
  return firestore
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .snapshots()
      .map((event) {
    return (event.data()?.containsKey('user') ?? false)
        ? event.data()!['user']
        : '';
  });
}

final userIdProvider = Provider<User>((ref) {
  ref.watch(onboardingrepositoryProvider).signInAnonymously();
  return FirebaseAuth.instance.currentUser!;
});
@Riverpod(keepAlive: true)
MyProfile myProfile(MyProfileRef ref) {
  return MyProfile();
}

@Riverpod(keepAlive: true)
FirebaseFirestore firestoreInstance(FirestoreInstanceRef ref) {
  return FirebaseFirestore.instance;
}
