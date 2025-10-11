import 'package:banking_app/features/search/blocs/search_bloc.dart';
import 'package:banking_app/features/search/blocs/search_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/widget_test_app.dart';
import '../mocks/mock_search_bloc.dart';
import 'search_test_setup.dart';

Widget createSearchTestWidget({
  required Widget child,
  Size surfaceSize = const Size(800, 1400),
}) {
  return BAWidgetTestApp(surfaceSize: surfaceSize, child: child);
}

Widget createSearchTestWidgetWithBloc({
  required Widget child,
  required MockSearchBloc mockBloc,
  Size surfaceSize = const Size(800, 1400),
}) {
  when(() => mockBloc.state).thenReturn(const SearchState());
  when(
    () => mockBloc.stream,
  ).thenAnswer((_) => Stream.value(const SearchState()));
  when(() => mockBloc.add(any())).thenReturn(null);
  when(() => mockBloc.close()).thenAnswer((_) async {});
  setupSearchServiceLocator(mockBloc);

  return createSearchTestWidget(
    surfaceSize: surfaceSize,
    child: BlocProvider<SearchBloc>.value(value: mockBloc, child: child),
  );
}
