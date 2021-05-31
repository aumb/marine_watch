import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marine_watch/features/favorites/presentation/widgets/favorite_button.dart';
import 'package:marine_watch/features/favorites/presentation/widgets/favorite_sighting_card.dart';
import 'package:marine_watch/features/sighting/presentation/bloc/sighting_bloc.dart';
import 'package:marine_watch/features/sightings/domain/models/sighting.dart';
import 'package:marine_watch/features/sightings/domain/models/species.dart';
import 'package:marine_watch/injection_container.dart';
import 'package:marine_watch/utils/widgets/custom_outlined_button.dart';
import 'package:mocktail/mocktail.dart';
import '../../../helpers/helpers.dart';

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

  Future<void> _setupSightingCardViewWidget(
    WidgetTester tester, {
    bool returnSighting = true,
  }) async {
    when(() => sightingBloc.sighting)
        .thenAnswer((invocation) => returnSighting ? sighting : null);
    when(() => sightingBloc.isFavorite).thenAnswer((invocation) => true);
    await tester.pumpApp(
      BlocProvider.value(
        value: sightingBloc,
        child: FavoriteSightingCardView(),
      ),
    );
  }

  group('FavoriteSightingCard', () {
    testWidgets('renders FavoriteSightingCard', (tester) async {
      await tester.pumpApp(FavoriteSightingCard(
        sighting: sighting,
      ));
      await tester.pumpAndSettle();
      expect(find.byType(FavoriteSightingCardView), findsOneWidget);
    });

    testWidgets('renders Card', (tester) async {
      _setupSightingInitalSightingState();
      await _setupSightingCardViewWidget(tester);
      await tester.pumpAndSettle();
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('renders FavoriteButton', (tester) async {
      _setupSightingInitalSightingState();
      await _setupSightingCardViewWidget(tester);
      await tester.pumpAndSettle();
      expect(find.byType(FavoriteButton), findsOneWidget);
    });

    testWidgets('renders DetialsButton', (tester) async {
      _setupSightingInitalSightingState();
      await _setupSightingCardViewWidget(tester);
      await tester.pumpAndSettle();
      expect(find.byType(CustomOutlinedButton), findsOneWidget);
    });

    testWidgets('adds ToggleFavoriteSightingEvent when tapped ',
        (tester) async {
      const favoriteButtonKey = Key('favorite_button_key');
      _setupSightingInitalSightingState();
      await _setupSightingCardViewWidget(tester);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(favoriteButtonKey));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));
      verify(() => sightingBloc.add(ToggleFavoriteSightingEvent()));
    });
  });
}
