import 'package:equatable/equatable.dart';

sealed class BrowseEvt extends Equatable {
  const BrowseEvt();

  @override
  List<Object> get props => [];
}

final class BrowseInitializeEvt extends BrowseEvt {
  const BrowseInitializeEvt();

  @override
  List<Object> get props => [];
}

final class BrowseSearchEvt extends BrowseEvt {
  const BrowseSearchEvt({
    required this.query,
  });

  final String query;

  @override
  List<Object> get props => [query];
}

class BrowseSortEvt extends BrowseEvt {
  const BrowseSortEvt({
    required this.sortBy,
  });

  final String sortBy;

  @override
  List<Object> get props => [sortBy];
}
