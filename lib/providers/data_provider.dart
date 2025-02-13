import 'dart:developer';
import 'package:poke_dex/view/assets/pokedex_assets.dart';
import 'package:flutter/material.dart';
import 'package:poke_dex/api/api.dart';
import 'package:poke_dex/model/pokemon_data_model.dart';

class PokemonProvider extends ChangeNotifier {
  List<Pokemon> pokemonList = [];
  // List<Home> pokeImgsList =[];

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Method to fetch the Pokemon list
  Future<void> fetchPokemonList() async {
    _isLoading = true;
    notifyListeners();

    try {
      pokemonList.clear();
      // pokeImgsList.clear();

      var data = await Api.fetchPokemonList();

      if (data != null) {
        pokemonList.addAll(data.results);

        if (pokemonList.isNotEmpty) {
          fetchUniquePokemonTypes();
        }

        // if(data.sprites.other.home.frontSDefault.isNotEmpty){
        //   pokeImgsList.add(data.sprites.other.home);
        // }
        log("data fetched");
      }
    } catch (e) {
      // Handle any errors
      log("Error fetching Pokemon list: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Method to fetch the Pokemon list
  Future<void> fetchPokemonData(String pokeId) async {
    _isLoading = true;
    notifyListeners();

    try {
      var data = await Api.fetchPokemonList();

      if (data != null) {
        log("data fetched");
      }
    } catch (e) {
      // Handle any errors
      log("Error fetching Pokemon list: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<String> pokemonTypes = [];

  fetchUniquePokemonTypes() {
    try {
      pokemonTypes.clear();

      for (var i in pokemonList) {
        for (var type in i.types) {
          if (pokemonTypes.contains(type.type)) {
          } else {
            pokemonTypes.add(type.type);
          }
        }
      }
    } finally {
      notifyListeners();
    }
  }

  String getTypeAsset(String type) {
  switch (type) {
    case "fire":
      return PokedexAssets.fireType;
    case "water":
      return PokedexAssets.waterType;
    case "grass":
      return PokedexAssets.grassType;
    case "electric":
      return PokedexAssets.electricType;
    case "ice":
      return PokedexAssets.iceType;
    case "fighting":
      return PokedexAssets.fightingType;
    case "poison":
      return PokedexAssets.poisonType;
    case "ground":
      return PokedexAssets.groundType;
    case "flying":
      return PokedexAssets.flyingType;
    case "psychic":
      return PokedexAssets.psychicType;
    case "bug":
      return PokedexAssets.bugType;
    case "rock":
      return PokedexAssets.rockType;
    case "ghost":
      return PokedexAssets.ghostType;
    case "dragon":
      return PokedexAssets.dragonType;
    case "dark":
      return PokedexAssets.darkType;
    case "steel":
      return PokedexAssets.steelType;
    case "fairy":
      return PokedexAssets.fairyType;
    default:
      return PokedexAssets.normalType;
  }
}

}
