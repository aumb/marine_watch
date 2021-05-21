// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:marine_watch/app/presentation/bloc/app_bloc.dart';
import 'package:marine_watch/features/home/presentation/home_screen.dart';
import 'package:marine_watch/injection_container.dart';
import 'package:marine_watch/features/l10n/l10n.dart';
import 'package:marine_watch/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:marine_watch/utils/bitmap_utils.dart';
import 'package:marine_watch/utils/theme_utils.dart';

class App extends StatefulWidget {
  App({Key? key, required this.navigationKey}) : super(key: key);

  final GlobalKey<NavigatorState> navigationKey;

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  late AppBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = sl<AppBloc>();
    _bloc.add(GetIsFreshInstallEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: MaterialApp(
        navigatorKey: widget.navigationKey,
        theme: ThemeUtils().themeData,
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocBuilder<AppBloc, AppState>(
          builder: (context, state) {
            return AppView();
          },
        ),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    sl<BitmapManager>().init(context);
  }

  @override
  Widget build(BuildContext context) {
    return context.read<AppBloc>().isFreshInstall
        ? OnboardingScreen()
        : HomeScreen();
  }
}
