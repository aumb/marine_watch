import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marine_watch/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:marine_watch/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:mocktail/mocktail.dart';
import '../../../helpers/helpers.dart';

class MockOnboardingCubit extends MockCubit<OnboardingState>
    implements OnboardingCubit {}

class OnboardingStateFake extends Fake implements OnboardingState {}

void main() {
  group('OnboardingScreen', () {
    testWidgets('renders OnboardingView', (tester) async {
      await tester.pumpApp(OnboardingScreen());
      expect(find.byType(OnboardingView), findsOneWidget);
    });
  });

  group('OnboardingView', () {
    const skipButtonKey = Key(
      'onboardingView_skip_button',
    );

    late OnboardingCubit onboardingCubit;

    setUp(() {
      registerFallbackValue<OnboardingState>(OnboardingStateFake());
      onboardingCubit = MockOnboardingCubit();
    });

    testWidgets('calls cacheIsFreshInstall when skip button is tapped',
        (tester) async {
      when(() => onboardingCubit.cacheIsFreshInstallEvent()).thenReturn(null);
      await tester.pumpApp(
        BlocProvider.value(
          value: onboardingCubit,
          child: OnboardingView(),
        ),
      );
      await tester.tap(find.byKey(skipButtonKey));
      verify(() => onboardingCubit.cacheIsFreshInstallEvent()).called(1);
    });
  });
}
