import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:poke_dex/model/pokemon_data_model.dart';
import 'package:poke_dex/providers/color_provider.dart';
import 'package:poke_dex/view/assets/pokedex_assets.dart';
import 'package:poke_dex/view/screens/pokedex_home.dart';
import 'package:poke_dex/view/screens/pokemon_details_screen.dart';
import 'package:provider/provider.dart';

class PokemonTypeScreen extends StatelessWidget {
  const PokemonTypeScreen({
    super.key,
    required this.pokemonTypeList,
    required this.pokemonType,
  });
  final List<Pokemon> pokemonTypeList;
  final String pokemonType;

  @override
  Widget build(BuildContext context) {
    final colorProvider = Provider.of<ColorProvider>(context);
    return Scaffold(
      backgroundColor: colorProvider.getColorForType(pokemonType),
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              // _focusedIndex = -1;
              // setState(() {});
            },
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 45, 16, 12),
                  child: Image.asset(PokedexAssets.bannerImg),
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.4,
                      mainAxisSpacing: 6,
                      crossAxisSpacing: 8,
                    ),
                    itemCount: pokemonTypeList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onLongPress: () {
                          // setState(() {
                          //   _focusedIndex = index;
                          // });
                        },
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PokemonDetailsScreen(
                                pokemonData: pokemonTypeList[index],
                              ),
                            ),
                          );
                        },
                        child: Card(
                          color: Colors.white,
                          child: Stack(
                            children: [
                              Positioned(
                                right: -25,
                                bottom: -30,
                                child: Transform.rotate(
                                  angle: 6,
                                  child: Image.asset(
                                    scale: 1.4,
                                    PokedexAssets.pokeball,
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 12, 16, 16),
                                child: Text(
                                  pokemonTypeList[index].name!.toCapitalized,
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 5,
                                child: CachedNetworkImage(
                                    placeholder: (context, string) {
                                      return Image.asset(
                                        PokedexAssets.coloredPokeball,
                                        scale: 10,
                                      );
                                    },
                                    errorWidget: (context, url, error) {
                                      return Image.asset(
                                        PokedexAssets.coloredPokeball,
                                        height: 80,
                                        width: 80,
                                      );
                                    },
                                    fit: BoxFit.contain,
                                    scale: 5,
                                    imageUrl:
                                        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${pokemonTypeList[index].id!}.png'),
                              ),
                              const Positioned(
                                bottom: 16,
                                left: -6,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(16, 12, 16, 16),
                                  child: Text("Ability: "),
                                ),
                              ),
                              Positioned(
                                bottom: 2,
                                left: -6,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(16, 12, 16, 16),
                                  child: Text(pokemonTypeList[index]
                                      .abilities[0]
                                      .name!
                                      .toCapitalized),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
