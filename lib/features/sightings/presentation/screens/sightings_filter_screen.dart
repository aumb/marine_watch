import 'package:flutter/material.dart';
import 'package:marine_watch/features/sightings/domain/models/species.dart';
import 'package:marine_watch/features/sightings/domain/usecases/get_sightings.dart';
import 'package:marine_watch/features/sightings/presentation/bloc/sightings_bloc.dart';
import 'package:marine_watch/injection_container.dart';
import 'package:marine_watch/utils/color_utils.dart';
import 'package:marine_watch/utils/nav/navgiation_manager.dart';
import 'package:marine_watch/utils/string_utils.dart';
import 'package:marine_watch/utils/widgets/custom_elevated_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marine_watch/features/l10n/l10n.dart';

class SightingsFilterScreen extends StatefulWidget {
  const SightingsFilterScreen({
    required this.onShowResults,
  });

  final Function(GetSightingsParams?)? onShowResults;

  @override
  _SightingsFilterScreenState createState() => _SightingsFilterScreenState();
}

class _SightingsFilterScreenState extends State<SightingsFilterScreen> {
  late GetSightingsParams params;

  bool get hasActiveFilters => params.species != null;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    params = GetSightingsParams(species: context.read<SightingsBloc>().species);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.filter),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FilterOptionTitle(
                      label: l10n.species,
                    ),
                    ..._buildSpeciesOptions()
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            child: CustomElevatedButton(
              label: l10n.showResults,
              onPressed: () {
                if (widget.onShowResults != null) widget.onShowResults!(params);
                sl<NavigationManager>().goBack(hasActiveFilters);
              },
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _buildSpeciesOptions() {
    final speciesOptions = [...Species.values]
      ..removeWhere((element) => element == Species.none);
    final speciesOptionsValues = <Widget>[];

    for (var specie in speciesOptions) {
      speciesOptionsValues.add(_FilterCheckMarkOptionWidget(
        label: specie.value,
        value: params.species?.value == specie.value,
        onChanged: (checked) {
          if (checked ?? false) {
            params = params.copyWith(species: specie);
          } else {
            params = params.copyWith(species: null);
          }
          if (mounted) setState(() {});
        },
      ));
    }

    return speciesOptionsValues;
  }
}

class _FilterOptionTitle extends StatelessWidget {
  const _FilterOptionTitle({
    required this.label,
  });

  final String label;
  @override
  Widget build(BuildContext context) {
    final titleTextTheme = Theme.of(context).textTheme.headline5;
    return Column(
      children: [
        const SizedBox(height: 28),
        Text(
          label,
          style: titleTextTheme,
        ),
        const SizedBox(height: 28),
      ],
    );
  }
}

class _FilterCheckMarkOptionWidget extends StatelessWidget {
  const _FilterCheckMarkOptionWidget({
    required this.label,
    required this.value,
    required this.onChanged,
  });
  final String label;
  final Function(bool?)? onChanged;
  final bool value;

  @override
  Widget build(BuildContext context) {
    final textSyle = const TextStyle(
      fontSize: 16,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(StringUtils.capitalizeFirstofEach(label), style: textSyle),
        Theme(
          data: ThemeData(unselectedWidgetColor: ColorUtils.white87),
          child: Checkbox(
            value: value,
            onChanged: onChanged!,
          ),
        )
      ],
    );
  }
}
