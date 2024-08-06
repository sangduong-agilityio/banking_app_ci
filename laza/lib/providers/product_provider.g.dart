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
String _$productsNotifierHash() => r'014c1e4bca73d960bf3b1d77b3bb626e9f66eec9';

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

abstract class _$ProductsNotifier
    extends BuildlessAsyncNotifier<List<Product>> {
  late final String query;

  FutureOr<List<Product>> build(
    String query,
  );
}

/// See also [ProductsNotifier].
@ProviderFor(ProductsNotifier)
const productsNotifierProvider = ProductsNotifierFamily();

/// See also [ProductsNotifier].
class ProductsNotifierFamily extends Family<AsyncValue<List<Product>>> {
  /// See also [ProductsNotifier].
  const ProductsNotifierFamily();

  /// See also [ProductsNotifier].
  ProductsNotifierProvider call(
    String query,
  ) {
    return ProductsNotifierProvider(
      query,
    );
  }

  @override
  ProductsNotifierProvider getProviderOverride(
    covariant ProductsNotifierProvider provider,
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
  String? get name => r'productsNotifierProvider';
}

/// See also [ProductsNotifier].
class ProductsNotifierProvider
    extends AsyncNotifierProviderImpl<ProductsNotifier, List<Product>> {
  /// See also [ProductsNotifier].
  ProductsNotifierProvider(
    String query,
  ) : this._internal(
          () => ProductsNotifier()..query = query,
          from: productsNotifierProvider,
          name: r'productsNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$productsNotifierHash,
          dependencies: ProductsNotifierFamily._dependencies,
          allTransitiveDependencies:
              ProductsNotifierFamily._allTransitiveDependencies,
          query: query,
        );

  ProductsNotifierProvider._internal(
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
    covariant ProductsNotifier notifier,
  ) {
    return notifier.build(
      query,
    );
  }

  @override
  Override overrideWith(ProductsNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: ProductsNotifierProvider._internal(
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
  AsyncNotifierProviderElement<ProductsNotifier, List<Product>>
      createElement() {
    return _ProductsNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductsNotifierProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ProductsNotifierRef on AsyncNotifierProviderRef<List<Product>> {
  /// The parameter `query` of this provider.
  String get query;
}

class _ProductsNotifierProviderElement
    extends AsyncNotifierProviderElement<ProductsNotifier, List<Product>>
    with ProductsNotifierRef {
  _ProductsNotifierProviderElement(super.provider);

  @override
  String get query => (origin as ProductsNotifierProvider).query;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
