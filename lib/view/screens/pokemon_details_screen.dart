import 'package:flutter/material.dart';
import 'package:poke_dex/model/pokemon_data_model.dart';
import 'package:poke_dex/providers/color_provider.dart';
import 'package:poke_dex/style/color_code.dart';
import 'package:poke_dex/view/screens/pokedex_home.dart';
import 'package:provider/provider.dart';

class PokemonDetailsScreen extends StatelessWidget {
  const PokemonDetailsScreen({
    super.key,
    required this.pokemonData,
  });

  final Pokemon pokemonData;

  @override
  Widget build(BuildContext context) {
    final colorProvider = Provider.of<ColorProvider>(context);
    return Scaffold(
      backgroundColor: colorProvider.getColorForType(pokemonData.types.first.type),
      body: Center(
        child: Text(pokemonData.name!.toCapitalized),
      ),
    );
  }
}
