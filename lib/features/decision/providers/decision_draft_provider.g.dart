// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'decision_draft_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$decisionDraftControllerHash() =>
    r'5e9786556244d957231f51d199f29438957da6ce';

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

abstract class _$DecisionDraftController
    extends BuildlessAutoDisposeAsyncNotifier<DecisionDraftState> {
  late final int sessionId;

  FutureOr<DecisionDraftState> build(
    int sessionId,
  );
}

/// See also [DecisionDraftController].
@ProviderFor(DecisionDraftController)
const decisionDraftControllerProvider = DecisionDraftControllerFamily();

/// See also [DecisionDraftController].
class DecisionDraftControllerFamily
    extends Family<AsyncValue<DecisionDraftState>> {
  /// See also [DecisionDraftController].
  const DecisionDraftControllerFamily();

  /// See also [DecisionDraftController].
  DecisionDraftControllerProvider call(
    int sessionId,
  ) {
    return DecisionDraftControllerProvider(
      sessionId,
    );
  }

  @override
  DecisionDraftControllerProvider getProviderOverride(
    covariant DecisionDraftControllerProvider provider,
  ) {
    return call(
      provider.sessionId,
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
  String? get name => r'decisionDraftControllerProvider';
}

/// See also [DecisionDraftController].
class DecisionDraftControllerProvider
    extends AutoDisposeAsyncNotifierProviderImpl<DecisionDraftController,
        DecisionDraftState> {
  /// See also [DecisionDraftController].
  DecisionDraftControllerProvider(
    int sessionId,
  ) : this._internal(
          () => DecisionDraftController()..sessionId = sessionId,
          from: decisionDraftControllerProvider,
          name: r'decisionDraftControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$decisionDraftControllerHash,
          dependencies: DecisionDraftControllerFamily._dependencies,
          allTransitiveDependencies:
              DecisionDraftControllerFamily._allTransitiveDependencies,
          sessionId: sessionId,
        );

  DecisionDraftControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.sessionId,
  }) : super.internal();

  final int sessionId;

  @override
  FutureOr<DecisionDraftState> runNotifierBuild(
    covariant DecisionDraftController notifier,
  ) {
    return notifier.build(
      sessionId,
    );
  }

  @override
  Override overrideWith(DecisionDraftController Function() create) {
    return ProviderOverride(
      origin: this,
      override: DecisionDraftControllerProvider._internal(
        () => create()..sessionId = sessionId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        sessionId: sessionId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<DecisionDraftController,
      DecisionDraftState> createElement() {
    return _DecisionDraftControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DecisionDraftControllerProvider &&
        other.sessionId == sessionId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, sessionId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin DecisionDraftControllerRef
    on AutoDisposeAsyncNotifierProviderRef<DecisionDraftState> {
  /// The parameter `sessionId` of this provider.
  int get sessionId;
}

class _DecisionDraftControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<DecisionDraftController,
        DecisionDraftState> with DecisionDraftControllerRef {
  _DecisionDraftControllerProviderElement(super.provider);

  @override
  int get sessionId => (origin as DecisionDraftControllerProvider).sessionId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
