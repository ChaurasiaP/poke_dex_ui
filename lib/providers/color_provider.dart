import 'package:flutter/material.dart';
import 'package:poke_dex/style/color_code.dart'; // Adjust import based on your actual file structure

class ColorProvider extends ChangeNotifier {
  // Method to get the color for a given Pokémon type
  Color getColorForType(String type) {
    switch (type) {
      case "fire":
        return PokemonColors.fire;
      case "water":
        return PokemonColors.water;
      case "grass":
        return PokemonColors.grass;
      case "electric":
        return PokemonColors.electric;
      case "ice":
        return PokemonColors.ice;
      case "fighting":
        return PokemonColors.fighting;
      case "poison":
        return PokemonColors.poison;
      case "ground":
        return PokemonColors.ground;
      case "flying":
        return PokemonColors.flying;
      case "psychic":
        return PokemonColors.psychic;
      case "bug":
        return PokemonColors.bug;
      case "rock":
        return PokemonColors.rock;
      case "ghost":
        return PokemonColors.ghost;
      case "dragon":
        return PokemonColors.dragon;
      case "dark":
        return PokemonColors.dark;
      case "steel":
        return PokemonColors.steel;
      case "fairy":
        return PokemonColors.fairy;
      default:
        return PokemonColors.normal; // Default to 'normal' type color if no match
    }
  }
}
