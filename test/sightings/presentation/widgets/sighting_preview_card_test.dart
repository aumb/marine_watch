import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marine_watch/features/sighting/presentation/widgets/sighting_preview_card.dart';
import 'package:marine_watch/features/sightings/domain/models/sighting.dart';
import 'package:marine_watch/features/sightings/domain/models/species.dart';
import 'package:marine_watch/features/sightings/presentation/bloc/sightings_bloc.dart';
import 'package:marine_watch/injection_container.dart';
import 'package:marine_watch/features/sighting/presentation/widgets/sighting_card.dart';
import 'package:mocktail/mocktail.dart';
import '../../../helpers/helpers.dart';

class SightingsStateFake extends Fake implements SightingsState {}

class SightingsEventFake extends Fake implements SightingsEvent {}

class MockSightingsBloc extends MockBloc<SightingsEvent, SightingsState>
    implements SightingsBloc {}

void main() {
  late SightingsBloc sightingsBloc;
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
    registerFallbackValue<SightingsState>(SightingsStateFake());
    registerFallbackValue<SightingsEvent>(SightingsEventFake());
    sightingsBloc = MockSightingsBloc();
  });

  tearDown(() {
    sightingsBloc.close();
    sl.reset();
  });

  void _setupLoadedState() {
    when(() => sightingsBloc.state).thenReturn(SightingsLoaded());
  }

  Future<void> _setupSightingPreviewWidget(
    WidgetTester tester, {
    bool returnSighting = true,
  }) async {
    when(() => sightingsBloc.selectedSighting)
        .thenAnswer((invocation) => returnSighting ? sighting : null);
    await tester.pumpApp(
      BlocProvider.value(
        value: sightingsBloc,
        child: SightingPreviewCard(
          sighting: sightingsBloc.selectedSighting,
        ),
      ),
    );
  }

  group('SightingsPreviewWidget', () {
    testWidgets('renders SightingsPreviewWidget', (tester) async {
      _setupLoadedState();
      await _setupSightingPreviewWidget(tester);
      await tester.pumpAndSettle();
      expect(find.byType(SightingPreviewCard), findsOneWidget);
    });

    testWidgets('renders SightingsCard', (tester) async {
      _setupLoadedState();
      await _setupSightingPreviewWidget(tester);
      await tester.pumpAndSettle();
      expect(find.byType(SightingCard), findsOneWidget);
    });

    testWidgets('renders Card if sighting is not null', (tester) async {
      _setupLoadedState();
      await _setupSightingPreviewWidget(tester);
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('renders SizedBox if sighting is null', (tester) async {
      _setupLoadedState();
      await _setupSightingPreviewWidget(tester, returnSighting: false);
      expect(find.byType(SizedBox), findsOneWidget);
    });
  });
}
