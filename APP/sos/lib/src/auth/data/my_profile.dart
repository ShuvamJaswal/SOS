import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';
part 'my_profile.g.dart';

class MyProfile {
  Future<UserCredential> signInAnonymously() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final UserCredential userCredential = await auth.signInAnonymously();
    return userCredential;
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
  FirebaseAuth.instance.signInAnonymously();
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
