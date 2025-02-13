import 'dart:developer';
import 'package:poke_dex/api/json/poke_data_json.dart';
import 'package:poke_dex/model/pokemon_data_model.dart';

class Api {

// METHOD TO FETCH LIST OF ALL POKEMONS
  static Future<PokemonDataModel?> fetchPokemonList() async {
    try {
        var convertedBody = pokemonApiModelFromJson(PokeDataJson.pokeDataDetailsJsonBody);
        return convertedBody;
    } catch (e) {
      log("exception caught in fetchPokemonList: $e");
    } finally {
      log("inside finally");
    }
    return null;
  }

  // METHOD TO FETCH DATA OF SINGLE POKEMON
  // static Future<PokemonDataModel?> fetchPokemonData(String pokeId) async {
  //   try {
  //     var pokemonUrl = Uri.parse("https://pokeapi.co/api/v2/pokemon/$pokeId");

  //     var response = await http.get(pokemonUrl);

  //     if (response.statusCode == 200) {
  //       var convertedBody = pokemonApiModelFromJson(response.body);

  //       // PokemonApiModel pokeData = PokemonApiModel.fromJson(convertedBody);
  //       return convertedBody;
  //     } else {
  //       return null;
  //     }
  //   } catch (e) {
  //     log("exception caught in fetchPokemonList: $e");
  //   } finally {
  //     log("inside finally");
  //   }
  //   return null;
  // }
}
