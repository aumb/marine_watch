import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marine_watch/features/sighting/presentation/cubit/toggle_sighting_cubit.dart';
import 'package:marine_watch/features/sightings/domain/models/sighting.dart';
import 'package:marine_watch/features/sightings/domain/models/species.dart';
import 'package:marine_watch/features/sightings/presentation/bloc/sightings_bloc.dart';
import 'package:marine_watch/features/sightings/presentation/screens/sightings_screen.dart';
import 'package:marine_watch/features/sightings/presentation/widgets/filter_widget.dart';
import 'package:marine_watch/features/sightings/presentation/widgets/map_widget.dart';
import 'package:marine_watch/features/sightings/presentation/widgets/toggle_sighting_widget.dart';
import 'package:marine_watch/injection_container.dart';
import 'package:marine_watch/utils/widgets/bouncing_dot_loader.dart';
import 'package:mocktail/mocktail.dart';
import '../../../helpers/helpers.dart';

class SightingsStateFake extends Fake implements SightingsState {}

class SightingsEventFake extends Fake implements SightingsEvent {}

class MockSightingsBloc extends MockBloc<SightingsEvent, SightingsState>
    implements SightingsBloc {}

class MockToggleSightingCubit extends MockCubit<ToggleSightingState>
    implements ToggleSightingCubit {}

class ToggleSightingStateFake extends Fake implements ToggleSightingState {}

void main() {
  late SightingsBloc sightingsBloc;
  late ToggleSightingCubit toggleSightingCubit;
  setUp(() async {
    await init(isTesting: true);
    registerFallbackValue<ToggleSightingState>(ToggleSightingStateFake());
    registerFallbackValue<SightingsState>(SightingsStateFake());
    registerFallbackValue<SightingsEvent>(SightingsEventFake());
    sightingsBloc = MockSightingsBloc();
    toggleSightingCubit = MockToggleSightingCubit();
  });

  tearDown(() {
    sightingsBloc.close();
    toggleSightingCubit.close();
    sl.reset();
  });

  void _setupLoadedState() {
    when(() => sightingsBloc.state).thenReturn(SightingsLoaded());
  }

  void _setupLoadingState() {
    when(() => sightingsBloc.state).thenReturn(SightingsLoading());
  }

  Future<void> _setupSightingsView(WidgetTester tester) async {
    await tester.pumpApp(
      MultiBlocProvider(
        providers: [
          BlocProvider<SightingsBloc>(
            create: (context) => sightingsBloc,
          ),
          BlocProvider<ToggleSightingCubit>(
            create: (context) => toggleSightingCubit,
          ),
        ],
        child: SightingsView(),
      ),
    );
  }

  group('SightingsScreen', () {
    testWidgets('renders Sightings screen', (tester) async {
      await tester.pumpApp(SightingsScreen());
      await tester.pumpAndSettle();
      expect(find.byType(SightingsView), findsOneWidget);
    });
  });

  group('SightingsView', () {
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
    testWidgets('renders MapWidget', (tester) async {
      _setupLoadedState();
      await _setupSightingsView(tester);
      await tester.pumpAndSettle();
      expect(find.byType(MapWidget), findsOneWidget);
    });

    testWidgets('renders FilterWidget', (tester) async {
      _setupLoadedState();
      await _setupSightingsView(tester);
      await tester.pumpAndSettle();
      expect(find.byType(FilterWidget), findsOneWidget);
    });

    testWidgets('renders CircularProgressIndicator when state is Loading',
        (tester) async {
      _setupLoadingState();
      await _setupSightingsView(tester);
      expect(find.byType(BouncingDotLoader), findsOneWidget);
    });

    testWidgets(
      'renders ToggleSightingWidget when user selects marker',
      (tester) async {
        when(() => sightingsBloc.selectedSighting)
            .thenAnswer((invocation) => sighting);
        _setupLoadedState();
        await _setupSightingsView(tester);
        expect(find.byType(ToggleSightingWidget), findsOneWidget);
      },
    );
  });
}
