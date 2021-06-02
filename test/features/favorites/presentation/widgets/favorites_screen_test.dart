import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marine_watch/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:marine_watch/features/favorites/presentation/screens/favorites_screen.dart';
import 'package:marine_watch/features/sightings/domain/models/sighting.dart';
import 'package:marine_watch/core/injection_container.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../helpers/helpers.dart';

class FavoritesStateFake extends Fake implements FavoritesState {}

class FavoritesEventFake extends Fake implements FavoritesEvent {}

class MockFavoritesBloc extends MockBloc<FavoritesEvent, FavoritesState>
    implements FavoritesBloc {}

// class MockToggleSightingCubit extends MockCubit<ToggleSightingState>
//     implements ToggleSightingCubit {}

// class ToggleSightingStateFake extends Fake implements ToggleSightingState {}

void main() {
  late FavoritesBloc favoritesBloc;
  // late ToggleSightingCubit toggleSightingCubit;
  setUp(() async {
    await init(isTesting: true);
    // registerFallbackValue<ToggleSightingState>(ToggleSightingStateFake());
    registerFallbackValue<FavoritesState>(FavoritesStateFake());
    registerFallbackValue<FavoritesEvent>(FavoritesEventFake());
    favoritesBloc = MockFavoritesBloc();
    // toggleSightingCubit = MockToggleSightingCubit();
  });

  tearDown(() {
    favoritesBloc.close();
    sl.reset();
  });

  void _setupInitialState() {
    when(() => favoritesBloc.state).thenReturn(FavoritesInitial());
  }

  void _setupLoadingState() {
    when(() => favoritesBloc.state).thenReturn(FavoritesLoading());
  }

  void _setupErrorState() {
    when(() => favoritesBloc.state).thenReturn(FavoritesError(message: ''));
  }

  void _setupLoadedState() {
    when(() => favoritesBloc.favoriteSightings).thenReturn(
      List.generate(3, (index) => Sighting.defaultSighting),
    );
    when(() => favoritesBloc.state).thenReturn(FavoritesLoaded());
  }

  void _setupEmptyState() {
    when(() => favoritesBloc.favoriteSightings).thenReturn([]);
    when(() => favoritesBloc.state).thenReturn(FavoritesEmpty());
  }

  Future<void> _setupSightingsView(WidgetTester tester) async {
    await tester.pumpApp(
      BlocProvider<FavoritesBloc>(
        create: (context) => favoritesBloc,
        child: BlocBuilder<FavoritesBloc, FavoritesState>(
          builder: (context, state) {
            return FavoritesView();
          },
        ),
      ),
    );
  }

  group('FavoritesScreen', () {
    testWidgets('renders FavoritesView', (tester) async {
      await tester.pumpApp(FavoritesScreen());
      expect(find.byType(FavoritesView), findsOneWidget);
    });
  });

  group('FavoritesView', () {
    testWidgets('renders Container on FavoritesInitial', (tester) async {
      _setupInitialState();
      await _setupSightingsView(tester);
      await tester.pumpAndSettle();
      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('renders ErrorState on FavoritesError', (tester) async {
      _setupErrorState();
      await _setupSightingsView(tester);
      await tester.pumpAndSettle();
      expect(find.byType(ErrorState), findsOneWidget);
    });

    testWidgets('renders ErrorState and calls Event on retry', (tester) async {
      const favoritesRetryButton = Key(
        'favorites_retry_button',
      );
      _setupErrorState();
      await _setupSightingsView(tester);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(favoritesRetryButton));
      await tester.pumpAndSettle();
      verify(() => favoritesBloc.add(GetCachedSightingsEvent())).called(1);
    });

    testWidgets('renders EmptyState on FavoritesEmpty', (tester) async {
      _setupEmptyState();
      await _setupSightingsView(tester);
      expect(find.byType(EmptyState), findsOneWidget);
    });

    testWidgets('renders LoadingState on FavoritesLoading', (tester) async {
      _setupLoadingState();
      await _setupSightingsView(tester);
      expect(find.byType(LoadingState), findsOneWidget);
    });

    testWidgets('renders LoadedState on FavoritesLoaded', (tester) async {
      _setupLoadedState();
      await _setupSightingsView(tester);
      await tester.pumpAndSettle();
      expect(find.byType(LoadedState), findsOneWidget);
    });
  });
}
