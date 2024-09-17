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



   Color getLight1ColorForType(String type) {
  switch (type) {
    case "fire":
      return PokemonColors.fireLight1;
    case "water":
      return PokemonColors.waterLight1;
    case "grass":
      return PokemonColors.grassLight1;
    case "electric":
      return PokemonColors.electricLight1;
    case "ice":
      return PokemonColors.iceLight1;
    case "fighting":
      return PokemonColors.fightingLight1;
    case "poison":
      return PokemonColors.poisonLight1;
    case "ground":
      return PokemonColors.groundLight1;
    case "flying":
      return PokemonColors.flyingLight1;
    case "psychic":
      return PokemonColors.psychicLight1;
    case "bug":
      return PokemonColors.bugLight1;
    case "rock":
      return PokemonColors.rockLight1;
    case "ghost":
      return PokemonColors.ghostLight1;
    case "dragon":
      return PokemonColors.dragonLight1;
    case "dark":
      return PokemonColors.darkLight1;
    case "steel":
      return PokemonColors.steelLight1;
    case "fairy":
      return PokemonColors.fairyLight1;
    default:
      return PokemonColors.normalLight1; // Default light1 color
  }
}

Color getLight2ColorForType(String type) {
  switch (type) {
    case "fire":
      return PokemonColors.fireLight2;
    case "water":
      return PokemonColors.waterLight2;
    case "grass":
      return PokemonColors.grassLight2;
    case "electric":
      return PokemonColors.electricLight2;
    case "ice":
      return PokemonColors.iceLight2;
    case "fighting":
      return PokemonColors.fightingLight2;
    case "poison":
      return PokemonColors.poisonLight2;
    case "ground":
      return PokemonColors.groundLight2;
    case "flying":
      return PokemonColors.flyingLight2;
    case "psychic":
      return PokemonColors.psychicLight2;
    case "bug":
      return PokemonColors.bugLight2;
    case "rock":
      return PokemonColors.rockLight2;
    case "ghost":
      return PokemonColors.ghostLight2;
    case "dragon":
      return PokemonColors.dragonLight2;
    case "dark":
      return PokemonColors.darkLight2;
    case "steel":
      return PokemonColors.steelLight2;
    case "fairy":
      return PokemonColors.fairyLight2;
    default:
      return PokemonColors.normalLight2; // Default light2 color
  }
}

}
