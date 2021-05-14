// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marine_watch/app/app.dart';
import 'package:marine_watch/onboarding/presentation/screens/onboarding_screen.dart';

void main() {
  group('App', () {
    testWidgets('renders CounterPage', (tester) async {
      final navigationKey = GlobalKey<NavigatorState>();
      await tester.pumpWidget(App(
        navigationKey: navigationKey,
      ));
      expect(find.byType(OnboardingScreen), findsOneWidget);
    });
  });
}
