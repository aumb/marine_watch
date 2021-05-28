import 'package:flutter/material.dart';
import 'package:marine_watch/features/sighting/presentation/cubit/toggle_sighting_cubit.dart';
import 'package:marine_watch/features/sighting/presentation/widgets/sighting_preview_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ToggleSightingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final showCard =
        context.select((ToggleSightingCubit c) => c.sighting != null);
    return showCard
        ? SafeArea(
            child: SightingPreviewCard(
              sighting: context.read<ToggleSightingCubit>().sighting,
              onDismiss: () =>
                  context.read<ToggleSightingCubit>().toggleSightingToNull(),
            ),
          )
        : const SizedBox.shrink();
  }
}
