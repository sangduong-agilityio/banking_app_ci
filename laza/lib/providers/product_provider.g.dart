// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_provider.dart';

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
String _$productRepositoryHash() => r'd78567550d3b380fc7babe15e05db2d10474cbdc';

/// See also [productRepository].
@ProviderFor(productRepository)
final productRepositoryProvider = Provider<ProductRepository>.internal(
  productRepository,
  name: r'productRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$productRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ProductRepositoryRef = ProviderRef<ProductRepository>;
String _$productServiceHash() => r'00d63fbde054884f41695f6434fd5e4aa43e046e';

/// See also [productService].
@ProviderFor(productService)
final productServiceProvider = Provider<ProductService>.internal(
  productService,
  name: r'productServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$productServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ProductServiceRef = ProviderRef<ProductService>;
String _$productsNotifierHash() => r'ac03c467f58b6a2f346603ec5b8cb43ffc688aca';

/// See also [ProductsNotifier].
@ProviderFor(ProductsNotifier)
final productsNotifierProvider =
    AsyncNotifierProvider<ProductsNotifier, List<Product>>.internal(
  ProductsNotifier.new,
  name: r'productsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$productsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ProductsNotifier = AsyncNotifier<List<Product>>;
String _$searchProductsNotifierHash() =>
    r'4297b88f3c0919afcc42c9c1c403c3cc81f51aa8';

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

abstract class _$SearchProductsNotifier
    extends BuildlessAsyncNotifier<List<Product>> {
  late final String query;

  FutureOr<List<Product>> build(
    String query,
  );
}

/// See also [SearchProductsNotifier].
@ProviderFor(SearchProductsNotifier)
const searchProductsNotifierProvider = SearchProductsNotifierFamily();

/// See also [SearchProductsNotifier].
class SearchProductsNotifierFamily extends Family<AsyncValue<List<Product>>> {
  /// See also [SearchProductsNotifier].
  const SearchProductsNotifierFamily();

  /// See also [SearchProductsNotifier].
  SearchProductsNotifierProvider call(
    String query,
  ) {
    return SearchProductsNotifierProvider(
      query,
    );
  }

  @override
  SearchProductsNotifierProvider getProviderOverride(
    covariant SearchProductsNotifierProvider provider,
  ) {
    return call(
      provider.query,
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
  String? get name => r'searchProductsNotifierProvider';
}

/// See also [SearchProductsNotifier].
class SearchProductsNotifierProvider
    extends AsyncNotifierProviderImpl<SearchProductsNotifier, List<Product>> {
  /// See also [SearchProductsNotifier].
  SearchProductsNotifierProvider(
    String query,
  ) : this._internal(
          () => SearchProductsNotifier()..query = query,
          from: searchProductsNotifierProvider,
          name: r'searchProductsNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$searchProductsNotifierHash,
          dependencies: SearchProductsNotifierFamily._dependencies,
          allTransitiveDependencies:
              SearchProductsNotifierFamily._allTransitiveDependencies,
          query: query,
        );

  SearchProductsNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
  }) : super.internal();

  final String query;

  @override
  FutureOr<List<Product>> runNotifierBuild(
    covariant SearchProductsNotifier notifier,
  ) {
    return notifier.build(
      query,
    );
  }

  @override
  Override overrideWith(SearchProductsNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: SearchProductsNotifierProvider._internal(
        () => create()..query = query,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
      ),
    );
  }

  @override
  AsyncNotifierProviderElement<SearchProductsNotifier, List<Product>>
      createElement() {
    return _SearchProductsNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchProductsNotifierProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SearchProductsNotifierRef on AsyncNotifierProviderRef<List<Product>> {
  /// The parameter `query` of this provider.
  String get query;
}

class _SearchProductsNotifierProviderElement
    extends AsyncNotifierProviderElement<SearchProductsNotifier, List<Product>>
    with SearchProductsNotifierRef {
  _SearchProductsNotifierProviderElement(super.provider);

  @override
  String get query => (origin as SearchProductsNotifierProvider).query;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
