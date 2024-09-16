import 'package:flutter/material.dart';
import 'package:poke_dex/view/assets/pokedex_assets.dart';

class RotatingPokeball extends StatefulWidget {
  @override
  _RotatingPokeballState createState() => _RotatingPokeballState();
}

class _RotatingPokeballState extends State<RotatingPokeball>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(); // This makes the animation repeat indefinitely
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: Image.asset(
        PokedexAssets.coloredPokeball, // Replace with your Pokeball PNG path
        width: 80,
        height: 80,
      ),
    );
  }
}
