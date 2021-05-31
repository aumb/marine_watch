// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marine_watch/features/favorites/presentation/screens/favorites_screen.dart';
import 'package:marine_watch/features/home/presentation/bloc/home_bloc.dart';
import 'package:marine_watch/features/home/presentation/home_screen.dart';
import 'package:marine_watch/features/sightings/presentation/screens/sightings_screen.dart';
import 'package:marine_watch/injection_container.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/helpers.dart';

class HomeStateFake extends Fake implements HomeState {}

class HomeEventFake extends Fake implements HomeEvent {}

class MockHomeBloc extends MockBloc<HomeEvent, HomeState> implements HomeBloc {}

void main() {
  group('Home', () {
    late HomeBloc homeBloc;

    setUpAll(() async {
      await init(isTesting: true);
    });

    setUp(() {
      registerFallbackValue<HomeState>(HomeStateFake());
      registerFallbackValue<HomeEvent>(HomeEventFake());
      homeBloc = MockHomeBloc();
    });

    testWidgets('renders HomeView', (tester) async {
      await tester.pumpApp(HomeScreen());
      await tester.pumpAndSettle();
      expect(find.byType(HomeView), findsOneWidget);
    });

    testWidgets('renders SightingsScreen when Bloc index is 0', (tester) async {
      when(() => homeBloc.state).thenAnswer((invocation) => HomeLoaded());
      when(() => homeBloc.index).thenAnswer((invocation) => 0);
      await tester.pumpApp(BlocProvider(
        create: (context) => homeBloc,
        child: HomeView(),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(SightingsScreen), findsOneWidget);
    });

    testWidgets('renders FavoritesScreen when Bloc index is 1', (tester) async {
      when(() => homeBloc.state).thenAnswer((invocation) => HomeLoaded());
      when(() => homeBloc.index).thenAnswer((invocation) => 1);
      await tester.pumpApp(BlocProvider(
        create: (context) => homeBloc,
        child: HomeView(),
      ));
      expect(find.byType(FavoritesScreen), findsOneWidget);
    });
  });
}
