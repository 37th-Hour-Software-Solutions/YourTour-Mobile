// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dioHash() => r'88c92e018b459d2a0754daeb73d9ed6b744e608c';

/// See also [dio].
@ProviderFor(dio)
final dioProvider = AutoDisposeProvider<Dio>.internal(
  dio,
  name: r'dioProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$dioHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DioRef = AutoDisposeProviderRef<Dio>;
String _$authServiceHash() => r'7d48cf00846532c54b1852c0fd0639bd8748ac8e';

/// See also [authService].
@ProviderFor(authService)
final authServiceProvider = AutoDisposeProvider<AuthService>.internal(
  authService,
  name: r'authServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthServiceRef = AutoDisposeProviderRef<AuthService>;
String _$profileServiceHash() => r'07598e8701da37c78a6941804e6e94d2fd90e8c6';

/// See also [profileService].
@ProviderFor(profileService)
final profileServiceProvider = AutoDisposeProvider<ProfileService>.internal(
  profileService,
  name: r'profileServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$profileServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProfileServiceRef = AutoDisposeProviderRef<ProfileService>;
String _$sharedPreferencesHash() => r'd22b545aefe95500327f9dce52c645d746349271';

/// See also [sharedPreferences].
@ProviderFor(sharedPreferences)
final sharedPreferencesProvider = FutureProvider<SharedPreferences>.internal(
  sharedPreferences,
  name: r'sharedPreferencesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sharedPreferencesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SharedPreferencesRef = FutureProviderRef<SharedPreferences>;
String _$sharedPreferencesServiceHash() =>
    r'323a75058b5fb3dc8a3bbe58c5e8892e2438503a';

/// See also [sharedPreferencesService].
@ProviderFor(sharedPreferencesService)
final sharedPreferencesServiceProvider =
    FutureProvider<SharedPreferencesService>.internal(
  sharedPreferencesService,
  name: r'sharedPreferencesServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sharedPreferencesServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SharedPreferencesServiceRef
    = FutureProviderRef<SharedPreferencesService>;
String _$secureStorageHash() => r'a4f75721472cf77465bf47f759c90de5ca30856e';

/// See also [secureStorage].
@ProviderFor(secureStorage)
final secureStorageProvider = Provider<FlutterSecureStorage>.internal(
  secureStorage,
  name: r'secureStorageProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$secureStorageHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SecureStorageRef = ProviderRef<FlutterSecureStorage>;
String _$secureStorageServiceHash() =>
    r'c76a08d2680d1e7d52105afdece8553fbbbcb50e';

/// See also [secureStorageService].
@ProviderFor(secureStorageService)
final secureStorageServiceProvider = Provider<SecureStorageService>.internal(
  secureStorageService,
  name: r'secureStorageServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$secureStorageServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SecureStorageServiceRef = ProviderRef<SecureStorageService>;
String _$currentLocationHash() => r'cfb68afbcbff562ef699a9aaf82d83a109136171';

/// See also [currentLocation].
@ProviderFor(currentLocation)
final currentLocationProvider = FutureProvider<Position?>.internal(
  currentLocation,
  name: r'currentLocationProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentLocationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentLocationRef = FutureProviderRef<Position?>;
String _$ttsServiceHash() => r'b806c3deb4ea2dd0d94639973b16c557eb39a588';

/// See also [ttsService].
@ProviderFor(ttsService)
final ttsServiceProvider = AutoDisposeProvider<TextToSpeech>.internal(
  ttsService,
  name: r'ttsServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$ttsServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TtsServiceRef = AutoDisposeProviderRef<TextToSpeech>;
String _$profileHash() => r'f1615a1483f6a7e9af02097d1c76e8a90e4af93a';

/// See also [Profile].
@ProviderFor(Profile)
final profileProvider =
    AutoDisposeAsyncNotifierProvider<Profile, User>.internal(
  Profile.new,
  name: r'profileProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$profileHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Profile = AutoDisposeAsyncNotifier<User>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
