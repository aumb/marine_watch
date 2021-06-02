import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marine_watch/features/home/presentation/home_screen.dart';
import 'package:marine_watch/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:marine_watch/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:marine_watch/core/injection_container.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../helpers/helpers.dart';

class MockOnboardingCubit extends MockCubit<OnboardingState>
    implements OnboardingCubit {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class OnboardingStateFake extends Fake implements OnboardingState {}

void main() {
  late OnboardingCubit onboardingCubit;
  late MockNavigatorObserver navigatorObserver;

  setUp(() async {
    await init(isTesting: true);
    registerFallbackValue<OnboardingState>(OnboardingStateFake());
    onboardingCubit = MockOnboardingCubit();
    navigatorObserver = MockNavigatorObserver();
  });

  tearDown(sl.reset);
  group('OnboardingScreen', () {
    testWidgets('renders OnboardingView', (tester) async {
      when(() => onboardingCubit.state).thenReturn(OnboardingLoaded());

      await tester.pumpApp(OnboardingScreen());
      await tester.pumpAndSettle();
      expect(find.byType(OnboardingView), findsOneWidget);
    });
  });

  group('OnboardingView', () {
    const skipButtonKey = Key(
      'onboardingView_skip_button',
    );

    testWidgets('calls cacheIsFreshInstall when skip button is tapped',
        (tester) async {
      when(() => onboardingCubit.cacheIsFreshInstallEvent())
          .thenAnswer((invocation) async => null);
      await tester.pumpApp(
        BlocProvider.value(
          value: onboardingCubit,
          child: OnboardingView(),
        ),
        navObservers: [navigatorObserver],
      );
      await tester.tap(find.byKey(skipButtonKey));
      await tester.pumpAndSettle();
      verify(() => onboardingCubit.cacheIsFreshInstallEvent()).called(1);
      expect(find.byType(HomeScreen), findsOneWidget);
    });
  });
}
