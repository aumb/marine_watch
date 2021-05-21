import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marine_watch/features/home/presentation/home_screen.dart';
import 'package:marine_watch/injection_container.dart';
import 'package:marine_watch/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:marine_watch/utils/color_utils.dart';
import 'package:marine_watch/utils/image_utils.dart';
import 'package:marine_watch/features/l10n/l10n.dart';
import 'package:marine_watch/utils/nav/navgiation_manager.dart';
import 'package:marine_watch/utils/widgets/custom_outlined_button.dart';
import 'package:pedantic/pedantic.dart';

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
                // BouncingDotLoader(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  CustomOutlinedButton _buildSkipButton(
      BuildContext context, AppLocalizations l10n) {
    return CustomOutlinedButton(
      key: const Key(
        'onboardingView_skip_button',
      ),
      onPressed: () async {
        await context.read<OnboardingCubit>().cacheIsFreshInstallEvent();
        unawaited(sl<NavigationManager>().navgivateAndReplace(HomeScreen()));
      },
      label: l10n.skip,
    );
  }
}
