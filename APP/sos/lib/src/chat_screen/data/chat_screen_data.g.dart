// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_screen_data.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$requestDataHash() => r'61bb17ded86607c8f4636d5ad889cd9d6ecc56f4';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

typedef RequestDataRef
    = AutoDisposeStreamProviderRef<DocumentSnapshot<Map<String, dynamic>>>;

/// See also [requestData].
@ProviderFor(requestData)
const requestDataProvider = RequestDataFamily();

/// See also [requestData].
class RequestDataFamily
    extends Family<AsyncValue<DocumentSnapshot<Map<String, dynamic>>>> {
  /// See also [requestData].
  const RequestDataFamily();

  /// See also [requestData].
  RequestDataProvider call({
    required String userId,
    required String requestId,
  }) {
    return RequestDataProvider(
      userId: userId,
      requestId: requestId,
    );
  }

  @override
  RequestDataProvider getProviderOverride(
    covariant RequestDataProvider provider,
  ) {
    return call(
      userId: provider.userId,
      requestId: provider.requestId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'requestDataProvider';
}

/// See also [requestData].
class RequestDataProvider
    extends AutoDisposeStreamProvider<DocumentSnapshot<Map<String, dynamic>>> {
  /// See also [requestData].
  RequestDataProvider({
    required this.userId,
    required this.requestId,
  }) : super.internal(
          (ref) => requestData(
            ref,
            userId: userId,
            requestId: requestId,
          ),
          from: requestDataProvider,
          name: r'requestDataProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$requestDataHash,
          dependencies: RequestDataFamily._dependencies,
          allTransitiveDependencies:
              RequestDataFamily._allTransitiveDependencies,
        );

  final String userId;
  final String requestId;

  @override
  bool operator ==(Object other) {
    return other is RequestDataProvider &&
        other.userId == userId &&
        other.requestId == requestId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);
    hash = _SystemHash.combine(hash, requestId.hashCode);

    return _SystemHash.finish(hash);
  }
}

String _$messagesDataHash() => r'032ff2f0fb9799b969a0b9a6739b6384c6e33f18';
typedef MessagesDataRef
    = AutoDisposeStreamProviderRef<QuerySnapshot<Map<String, dynamic>>>;

/// See also [messagesData].
@ProviderFor(messagesData)
const messagesDataProvider = MessagesDataFamily();

/// See also [messagesData].
class MessagesDataFamily
    extends Family<AsyncValue<QuerySnapshot<Map<String, dynamic>>>> {
  /// See also [messagesData].
  const MessagesDataFamily();

  /// See also [messagesData].
  MessagesDataProvider call({
    required String userId,
    required String requestId,
  }) {
    return MessagesDataProvider(
      userId: userId,
      requestId: requestId,
    );
  }

  @override
  MessagesDataProvider getProviderOverride(
    covariant MessagesDataProvider provider,
  ) {
    return call(
      userId: provider.userId,
      requestId: provider.requestId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'messagesDataProvider';
}

/// See also [messagesData].
class MessagesDataProvider
    extends AutoDisposeStreamProvider<QuerySnapshot<Map<String, dynamic>>> {
  /// See also [messagesData].
  MessagesDataProvider({
    required this.userId,
    required this.requestId,
  }) : super.internal(
          (ref) => messagesData(
            ref,
            userId: userId,
            requestId: requestId,
          ),
          from: messagesDataProvider,
          name: r'messagesDataProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$messagesDataHash,
          dependencies: MessagesDataFamily._dependencies,
          allTransitiveDependencies:
              MessagesDataFamily._allTransitiveDependencies,
        );

  final String userId;
  final String requestId;

  @override
  bool operator ==(Object other) {
    return other is MessagesDataProvider &&
        other.userId == userId &&
        other.requestId == requestId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);
    hash = _SystemHash.combine(hash, requestId.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
