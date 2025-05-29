import 'package:equatable/equatable.dart';

enum SortOrder { lowToHigh, highToLow }

class BrowseEvt extends Equatable {
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
    required this.sort,
  });

  final SortOrder sort;

  @override
  List<Object> get props => [sort];
}
