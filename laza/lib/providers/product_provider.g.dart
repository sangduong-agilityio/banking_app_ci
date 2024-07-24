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
String _$productsHash() => r'8d6ab241fafa8eb28266db6bc769217565746fb9';

/// See also [products].
@ProviderFor(products)
final productsProvider = FutureProvider<List<Product>>.internal(
  products,
  name: r'productsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$productsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ProductsRef = FutureProviderRef<List<Product>>;
String _$productHash() => r'9f1a91f82d384807ef67a315645f4a9267da2609';

/// See also [product].
@ProviderFor(product)
final productProvider = FutureProvider<Product>.internal(
  product,
  name: r'productProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$productHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ProductRef = FutureProviderRef<Product>;
String _$searchProductsHash() => r'3b863327f9a509b736bbaeff360d7ed36913005c';

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

/// See also [searchProducts].
@ProviderFor(searchProducts)
const searchProductsProvider = SearchProductsFamily();

/// See also [searchProducts].
class SearchProductsFamily extends Family<AsyncValue<List<Product>>> {
  /// See also [searchProducts].
  const SearchProductsFamily();

  /// See also [searchProducts].
  SearchProductsProvider call(
    String query,
  ) {
    return SearchProductsProvider(
      query,
    );
  }

  @override
  SearchProductsProvider getProviderOverride(
    covariant SearchProductsProvider provider,
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
  String? get name => r'searchProductsProvider';
}

/// See also [searchProducts].
class SearchProductsProvider extends FutureProvider<List<Product>> {
  /// See also [searchProducts].
  SearchProductsProvider(
    String query,
  ) : this._internal(
          (ref) => searchProducts(
            ref as SearchProductsRef,
            query,
          ),
          from: searchProductsProvider,
          name: r'searchProductsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$searchProductsHash,
          dependencies: SearchProductsFamily._dependencies,
          allTransitiveDependencies:
              SearchProductsFamily._allTransitiveDependencies,
          query: query,
        );

  SearchProductsProvider._internal(
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
  Override overrideWith(
    FutureOr<List<Product>> Function(SearchProductsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchProductsProvider._internal(
        (ref) => create(ref as SearchProductsRef),
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
  FutureProviderElement<List<Product>> createElement() {
    return _SearchProductsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchProductsProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SearchProductsRef on FutureProviderRef<List<Product>> {
  /// The parameter `query` of this provider.
  String get query;
}

class _SearchProductsProviderElement
    extends FutureProviderElement<List<Product>> with SearchProductsRef {
  _SearchProductsProviderElement(super.provider);

  @override
  String get query => (origin as SearchProductsProvider).query;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
