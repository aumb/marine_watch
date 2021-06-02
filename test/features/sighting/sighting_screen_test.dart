import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marine_watch/features/sighting/presentation/bloc/sighting_bloc.dart';
import 'package:marine_watch/features/sighting/presentation/screens/sighting_screen.dart';
import 'package:marine_watch/features/sightings/domain/models/sighting.dart';
import 'package:marine_watch/features/sightings/domain/models/species.dart';
import 'package:marine_watch/features/sightings/presentation/widgets/map_widget.dart';
import 'package:marine_watch/core/injection_container.dart';
import 'package:marine_watch/widgets/custom_elevated_button.dart';
import 'package:mocktail/mocktail.dart';
import '../../.../../helpers/helpers.dart';

class SightingStateFake extends Fake implements SightingState {}

class SightingEventFake extends Fake implements SightingEvent {}

class MockSightingBloc extends MockBloc<SightingEvent, SightingState>
    implements SightingBloc {}

void main() {
  late SightingBloc sightingBloc;
  final sighting = Sighting(
    id: '1',
    species: Species.atlanticWhiteSidedDolphin,
    quantity: 1,
    description: 'test',
    url: 'test',
    latitude: 123.2,
    longitude: 123.2,
    location: 'test',
    sightedAt: DateTime.now(),
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
  setUp(() async {
    await init(isTesting: true);
    registerFallbackValue<SightingState>(SightingStateFake());
    registerFallbackValue<SightingEvent>(SightingEventFake());
    sightingBloc = MockSightingBloc();
  });

  tearDown(() {
    sightingBloc.close();
    sl.reset();
  });

  void _setupSightingInitalSightingState() {
    when(() => sightingBloc.state).thenReturn(SightingInitial());
  }

  Future<void> _setupSightingScreen(WidgetTester tester,
      {bool returnSighting = true, bool isFavorite = true}) async {
    when(() => sightingBloc.sighting)
        .thenAnswer((invocation) => returnSighting ? sighting : null);
    when(() => sightingBloc.isFavorite).thenAnswer((invocation) => isFavorite);
    await tester.pumpApp(
      BlocProvider.value(
        value: sightingBloc,
        child: SightingScreen(),
      ),
    );
  }

  group('SightingScreen', () {
    group('SliverAppBar', () {
      testWidgets('renders SliverAppBar', (tester) async {
        _setupSightingInitalSightingState();
        await _setupSightingScreen(tester);
        await tester.pumpAndSettle();
        expect(find.byType(SliverAppBar), findsOneWidget);
      });

      testWidgets('renders MapWidget', (tester) async {
        _setupSightingInitalSightingState();
        await _setupSightingScreen(tester);
        await tester.pumpAndSettle();
        expect(find.byType(MapWidget), findsOneWidget);
      });

      group('FavoriteIconButton', () {
        testWidgets('renders FavoriteIcon', (tester) async {
          final key = const Key('favorite_icon_button_key');
          _setupSightingInitalSightingState();
          await _setupSightingScreen(tester);
          await tester.pumpAndSettle();
          expect(find.byKey(key), findsOneWidget);
        });

        testWidgets('adds ToggleFavoriteSightingEvent when tapped ',
            (tester) async {
          const favoriteButtonKey = Key('favorite_icon_button_key');
          _setupSightingInitalSightingState();
          await _setupSightingScreen(tester);
          await tester.pumpAndSettle();
          await tester.tap(find.byKey(favoriteButtonKey));
          await tester.pumpAndSettle(const Duration(milliseconds: 500));
          verify(() => sightingBloc.add(ToggleFavoriteSightingEvent()));
        });
      });
    });
    testWidgets('renders 2 SightingInfoWidget', (tester) async {
      _setupSightingInitalSightingState();
      await _setupSightingScreen(tester);
      await tester.pumpAndSettle();
      expect(find.byType(SightingInfoWidget), findsNWidgets(2));
    });

    testWidgets('renders Description Card', (tester) async {
      _setupSightingInitalSightingState();
      await _setupSightingScreen(tester);
      await tester.pumpAndSettle();
      expect(find.byType(Card), findsOneWidget);
    });
    testWidgets('renders TrackButton', (tester) async {
      _setupSightingInitalSightingState();
      await _setupSightingScreen(tester);
      await tester.pumpAndSettle();
      expect(find.byType(CustomElevatedButton), findsOneWidget);
    });

    testWidgets('Navigates to maps when pressed', (tester) async {
      final trackButtonKey = const Key('track_button_key');
      _setupSightingInitalSightingState();
      await _setupSightingScreen(tester, isFavorite: false);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(trackButtonKey));
      verify(() => sightingBloc.add(TrackButtonPressedEvent()));
    });
  });
}
