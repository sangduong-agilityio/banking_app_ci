// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$lazaApiClientHash() => r'65daa475ce9cf0d4dad45ecdeb114996cacd717f';

/// See also [lazaApiClient].
@ProviderFor(lazaApiClient)
final lazaApiClientProvider = Provider<LazaApiClient>.internal(
  lazaApiClient,
  name: r'lazaApiClientProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$lazaApiClientHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef LazaApiClientRef = ProviderRef<LazaApiClient>;
String _$brandRepositoryHash() => r'dc8395e771943af63d423675ab4c73ec2926c363';

/// See also [brandRepository].
@ProviderFor(brandRepository)
final brandRepositoryProvider = Provider<BrandRepository>.internal(
  brandRepository,
  name: r'brandRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$brandRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef BrandRepositoryRef = ProviderRef<BrandRepository>;
String _$brandHash() => r'05d0e42995a2dd3e630c87ff1c78e61da46377e5';

/// See also [brand].
@ProviderFor(brand)
final brandProvider = FutureProvider<List<Brand>>.internal(
  brand,
  name: r'brandProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$brandHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef BrandRef = FutureProviderRef<List<Brand>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
