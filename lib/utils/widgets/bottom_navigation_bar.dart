import 'package:flutter/material.dart';
import 'package:marine_watch/features/l10n/l10n.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  CustomBottomNavigationBar({
    required this.currentIndex,
    required this.onTap,
  });

  ///The current page selected
  final int currentIndex;

  ///Action on the tap of a tab bar item
  final Function(int value) onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Theme.of(context).backgroundColor,
      unselectedItemColor: Colors.blueGrey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedItemColor: Theme.of(context).accentColor,
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.map),
          label: context.l10n.sightings,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.favorite),
          label: context.l10n.favorites,
        ),
      ],
    );
  }
}
