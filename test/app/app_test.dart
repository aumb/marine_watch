// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marine_watch/app/app.dart';
import 'package:marine_watch/app/presentation/bloc/app_bloc.dart';
import 'package:marine_watch/features/home/presentation/home_screen.dart';
import 'package:marine_watch/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:marine_watch/injection_container.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/helpers.dart';

class AppStateFake extends Fake implements AppState {}

class AppEventFake extends Fake implements AppEvent {}

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

void main() {
  group('App', () {
    late AppBloc appBloc;

    setUpAll(() async {
      await init(isTesting: true);
    });

    setUp(() {
      registerFallbackValue<AppState>(AppStateFake());
      registerFallbackValue<AppEvent>(AppEventFake());
      appBloc = MockAppBloc()..add(GetIsFreshInstallEvent());
    });

    tearDown(() {
      appBloc.close();
    });

    testWidgets('renders App', (tester) async {
      final navigationKey = GlobalKey<NavigatorState>();
      await tester.pumpWidget(App(
        navigationKey: navigationKey,
      ));
      expect(find.byType(AppView), findsOneWidget);
    });

    testWidgets('renders OnboardingScreen if isFreshInstall is true',
        (tester) async {
      when(() => appBloc.state).thenReturn(AppLoaded());
      when(() => appBloc.isFreshInstall).thenReturn(true);
      await tester.pumpApp(
        BlocProvider.value(
          value: appBloc,
          child: AppView(),
        ),
      );
      expect(find.byType(OnboardingScreen), findsOneWidget);
    });

    testWidgets('renders HomeScreen if isFreshInstall is false',
        (tester) async {
      when(() => appBloc.state).thenReturn(AppLoaded());
      when(() => appBloc.isFreshInstall).thenReturn(false);
      await tester.pumpApp(
        BlocProvider.value(
          value: appBloc,
          child: AppView(),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(HomeScreen), findsOneWidget);
    });
  });
}
