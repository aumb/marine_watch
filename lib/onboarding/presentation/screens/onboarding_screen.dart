import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:marine_watch/injection_container.dart';
import 'package:marine_watch/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:marine_watch/utils/color_utils.dart';
import 'package:marine_watch/utils/image_utils.dart';
import 'package:marine_watch/l10n/l10n.dart';

class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<OnboardingCubit>(),
      child: OnboardingView(),
    );
  }
}

class OnboardingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          _buildImage(context),
          _buildIntroductionText(context, l10n),
        ],
      ),
    );
  }

  ColorFiltered _buildImage(BuildContext context) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        ColorUtils.secondaryColor.withOpacity(0.4),
        BlendMode.xor,
      ),
      child: Image.asset(
        ImageUtils.onBoardingImage,
        fit: BoxFit.cover,
      ),
    );
  }

  Padding _buildIntroductionText(BuildContext context, dynamic l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(child: SizedBox()),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.onboardingTitle,
                  style: Theme.of(context).textTheme.headline4,
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.onboardingSubtitle,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                const SizedBox(height: 16),
                _buildSkipButton(context, l10n),
              ],
            ),
          ),
        ],
      ),
    );
  }

  OutlinedButton _buildSkipButton(BuildContext context, dynamic l10n) {
    return OutlinedButton(
      key: const Key(
        'onboardingView_skip_button',
      ),
      style: OutlinedButton.styleFrom(
        primary: Colors.grey,
        side: BorderSide(
          color: ColorUtils.white87,
        ),
      ),
      onPressed: () =>
          context.read<OnboardingCubit>().cacheIsFreshInstallEvent(),
      child: Text(
        l10n.skip,
        style: Theme.of(context).textTheme.button!.copyWith(
              color: ColorUtils.white87,
            ),
      ),
    );
  }
}
