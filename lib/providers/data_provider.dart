import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:poke_dex/api/api.dart';
import 'package:poke_dex/model/pokemon_data_model.dart';
import 'package:poke_dex/model/pokemons_list_model.dart';

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
}
