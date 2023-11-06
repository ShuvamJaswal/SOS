// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_profile.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$usernameHash() => r'46432386876dba9bbbb8098a2b9ada3fcebceba6';

/// See also [username].
@ProviderFor(username)
final usernameProvider = AutoDisposeStreamProvider<dynamic>.internal(
  username,
  name: r'usernameProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$usernameHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UsernameRef = AutoDisposeStreamProviderRef<dynamic>;
String _$myProfileHash() => r'849b5b2bdb0d1e131c4df9dd94bf5ac76cadbd1c';

/// See also [myProfile].
@ProviderFor(myProfile)
final myProfileProvider = Provider<MyProfile>.internal(
  myProfile,
  name: r'myProfileProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$myProfileHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MyProfileRef = ProviderRef<MyProfile>;
String _$firestoreInstanceHash() => r'38d432709657f5f370efd64e60ea8d8971ec4599';

/// See also [firestoreInstance].
@ProviderFor(firestoreInstance)
final firestoreInstanceProvider = Provider<FirebaseFirestore>.internal(
  firestoreInstance,
  name: r'firestoreInstanceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$firestoreInstanceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FirestoreInstanceRef = ProviderRef<FirebaseFirestore>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
