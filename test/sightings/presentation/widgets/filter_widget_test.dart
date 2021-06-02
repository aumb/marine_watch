import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marine_watch/features/sightings/domain/models/species.dart';
import 'package:marine_watch/features/sightings/presentation/bloc/sightings_bloc.dart';
import 'package:marine_watch/features/sightings/presentation/screens/sightings_filter_screen.dart';
import 'package:marine_watch/features/sightings/presentation/widgets/filter_widget.dart';
import 'package:marine_watch/injection_container.dart';
import 'package:mocktail/mocktail.dart';
import '../../../helpers/helpers.dart';

class SightingsStateFake extends Fake implements SightingsState {}

class SightingsEventFake extends Fake implements SightingsEvent {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockSightingsBloc extends MockBloc<SightingsEvent, SightingsState>
    implements SightingsBloc {}

void main() {
  late SightingsBloc sightingsBloc;
  late MockNavigatorObserver navigatorObserver;
  setUp(() async {
    await init(isTesting: true);
    registerFallbackValue<SightingsState>(SightingsStateFake());
    registerFallbackValue<SightingsEvent>(SightingsEventFake());
    sightingsBloc = MockSightingsBloc();
    navigatorObserver = MockNavigatorObserver();
  });

  tearDown(() {
    sightingsBloc.close();
    sl.reset();
  });

  Future<void> _setupFilterWidget(WidgetTester tester) async {
    await tester.pumpApp(
      MultiBlocProvider(
        providers: [
          BlocProvider<SightingsBloc>(
            create: (BuildContext context) => sightingsBloc,
          ),
        ],
        child: FilterWidget(
          onShowResults: (results) => null,
        ),
      ),
      navObservers: [navigatorObserver],
    );
  }

  group('FilterWidget', () {
    testWidgets('renders AccentColor FilterWidget when sighting is not null',
        (tester) async {
      when(() => sightingsBloc.species)
          .thenReturn(Species.atlanticWhiteSidedDolphin);
      await _setupFilterWidget(tester);
      await tester.pumpAndSettle();
      expect(find.byType(Container), findsOneWidget);
    });
  });

  group('SightingsFilterScreen', () {
    testWidgets('renders SightingsFilterScreen when FilterWidget is tapped',
        (tester) async {
      const filterButtonKey = Key(
        'sightings_filter_button',
      );
      await _setupFilterWidget(tester);
      await tester.tap(find.byKey(filterButtonKey));
      await tester.pumpAndSettle();
      expect(find.byType(SightingsFilterScreen), findsOneWidget);
    });
  });
}
