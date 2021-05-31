import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marine_watch/features/favorites/presentation/screens/favorites_screen.dart';
import 'package:marine_watch/features/home/presentation/bloc/home_bloc.dart';
import 'package:marine_watch/features/sightings/presentation/screens/sightings_screen.dart';
import 'package:marine_watch/injection_container.dart';
import 'package:marine_watch/utils/widgets/bottom_navigation_bar.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<HomeBloc>()..add(GetFavoriteSightingsEvent()),
      child: HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  final _bottomNavigationItems = [
    SightingsScreen(),
    FavoritesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    context.select((HomeBloc c) => c.state);
    return Scaffold(
      bottomNavigationBar: _buildBottomNavigationBar(context),
      body: _bottomNavigationItems[context.read<HomeBloc>().index],
    );
  }

  CustomBottomNavigationBar _buildBottomNavigationBar(BuildContext context) {
    return CustomBottomNavigationBar(
      currentIndex: context.read<HomeBloc>().index,
      onTap: (index) {
        context.read<HomeBloc>().add(
              ChangeTabBarIndexEvent(index: index),
            );
      },
    );
  }
}
