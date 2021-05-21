// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marine_watch/features/l10n/l10n.dart';
import 'package:marine_watch/injection_container.dart';
import 'package:marine_watch/utils/nav/navgiation_manager.dart';
import 'package:mocktail/mocktail.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    List<NavigatorObserver> navObservers = const <NavigatorObserver>[],
  }) {
    return pumpWidget(
      MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: widget,
        navigatorObservers: navObservers,
        navigatorKey: navObservers.isNotEmpty
            ? sl<NavigationManager>().navigatorKey
            : null,
      ),
    );
  }
}
