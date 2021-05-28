import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marine_watch/features/sighting/presentation/cubit/toggle_sighting_cubit.dart';
import 'package:marine_watch/features/sighting/presentation/widgets/sighting_preview_card.dart';
import 'package:marine_watch/features/sightings/domain/models/sighting.dart';
import 'package:marine_watch/features/sightings/presentation/widgets/toggle_sighting_widget.dart';
import 'package:marine_watch/injection_container.dart';
import 'package:mocktail/mocktail.dart';
import '../../../helpers/helpers.dart';

class MockToggleSightingCubit extends MockCubit<ToggleSightingState>
    implements ToggleSightingCubit {}

class ToggleSightingStateFake extends Fake implements ToggleSightingState {}

void main() {
  late ToggleSightingCubit toggleSightingCubit;

  setUp(() async {
    await init(isTesting: true);
    registerFallbackValue<ToggleSightingState>(ToggleSightingStateFake());
    toggleSightingCubit = MockToggleSightingCubit();
  });

  tearDown(() {
    toggleSightingCubit.close();
    sl.reset();
  });

  Future<void> _setupToggleSightingsWidget(WidgetTester tester) async {
    await tester.pumpApp(
      BlocProvider.value(
        value: toggleSightingCubit,
        child: ToggleSightingWidget(),
      ),
    );
  }

  testWidgets(
    'renders SizedBox when the sighting is null',
    (tester) async {
      when(() => toggleSightingCubit.sighting).thenAnswer((invocation) => null);
      await _setupToggleSightingsWidget(tester);
      expect(find.byType(SizedBox), findsOneWidget);
    },
  );

  testWidgets(
    'renders SightingPreviewCard when the sighting has a value',
    (tester) async {
      when(() => toggleSightingCubit.sighting)
          .thenAnswer((invocation) => Sighting.defaultSighting);
      await _setupToggleSightingsWidget(tester);
      expect(find.byType(SightingPreviewCard), findsOneWidget);
    },
  );
}
