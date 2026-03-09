import 'package:flutter/material.dart';
import 'package:poke_dex/view/screens/favourites_screen.dart';
import 'package:poke_dex/view/screens/pokedex_home.dart';
import 'package:poke_dex/view/screens/team_screen.dart';
import 'package:poke_dex/view/screens/types_screen.dart';
import 'package:poke_dex/widgets/liquid_glass_nav_bar.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final _pages = const [
    PokedexHome(),
    FavouritesScreen(),
    TypesScreen(),
    TeamScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: LiquidGlassNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
