import 'package:flutter/material.dart';
import 'package:marine_watch/features/sightings/domain/usecases/get_sightings.dart';
import 'package:marine_watch/features/sightings/presentation/bloc/sightings_bloc.dart';
import 'package:marine_watch/features/sightings/presentation/screens/sightings_filter_screen.dart';
import 'package:marine_watch/core/injection_container.dart';

import 'package:marine_watch/core/utils/color_utils.dart';
import 'package:marine_watch/features/l10n/l10n.dart';
import 'package:marine_watch/core/nav/navgiation_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilterWidget extends StatefulWidget {
  const FilterWidget({
    required this.onShowResults,
  });

  final Function(GetSightingsParams?)? onShowResults;

  @override
  _FilterWidgetState createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  bool get hasActiveFilters => context.read<SightingsBloc>().species != null;
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return GestureDetector(
      key: const Key('sightings_filter_button'),
      onTap: () {
        sl<NavigationManager>().navigateTo(
          BlocProvider.value(
            value: context.read<SightingsBloc>(),
            child: SightingsFilterScreen(
              onShowResults: widget.onShowResults,
            ),
          ),
          isFullScreenDialog: true,
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            decoration: BoxDecoration(
              color: hasActiveFilters
                  ? ColorUtils.accentColor
                  : ColorUtils.backgroundColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            child: Row(
              children: [
                Text(
                  l10n.filter,
                  style: TextStyle(
                    color:
                        hasActiveFilters ? Colors.black87 : ColorUtils.white87,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.filter_list,
                  color: hasActiveFilters ? Colors.black87 : ColorUtils.white87,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
