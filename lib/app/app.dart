// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:marine_watch/injection_container.dart';
import 'package:marine_watch/l10n/l10n.dart';
import 'package:marine_watch/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:marine_watch/utils/nav/navgiation_manager.dart';
import 'package:marine_watch/utils/theme_utils.dart';

class App extends StatelessWidget {
  App({Key? key, required this.navigationKey}) : super(key: key);

  final GlobalKey<NavigatorState> navigationKey;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigationKey,
      theme: ThemeUtils().themeData,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: OnboardingScreen(),
    );
  }
}
