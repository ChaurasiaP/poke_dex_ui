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
    final typeColor = colorProvider.getColorForType(pokemonType);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: Stack(
        children: [
          // Gradient bg with type colour splash
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  typeColor.withValues(alpha: 0.55),
                  const Color(0xFF0D0D1A),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.45],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.30),
                            ),
                          ),
                          child: const Icon(Icons.arrow_back_ios_rounded,
                              color: Colors.white, size: 18),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${pokemonType.toCapitalized} Type',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            '${pokemonTypeList.length} Pokémon',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.55),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.35,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                    ),
                    itemCount: pokemonTypeList.length,
                    itemBuilder: (context, index) {
                      final pokemon = pokemonTypeList[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PokemonDetailsScreen(
                                pokemonData: pokemon,
                                pokemonIndex: pokemon.id != null
                                    ? pokemon.id! - 1
                                    : index,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                typeColor.withValues(alpha: 0.75),
                                typeColor.withValues(alpha: 0.40),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.18),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: typeColor.withValues(alpha: 0.30),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                right: -18,
                                bottom: -18,
                                child: Opacity(
                                  opacity: 0.12,
                                  child: Image.asset(
                                    PokedexAssets.pokeball,
                                    height: 80,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '#${pokemon.id.toString().padLeft(3, '0')}',
                                      style: TextStyle(
                                        color:
                                            Colors.white.withValues(alpha: 0.60),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      pokemon.name?.toCapitalized ?? '',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const Spacer(),
                                    Text(
                                      pokemon.abilities.isNotEmpty
                                          ? pokemon.abilities[0].name
                                                  ?.toCapitalized ??
                                              ''
                                          : '',
                                      style: TextStyle(
                                        color:
                                            Colors.white.withValues(alpha: 0.65),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                right: 6,
                                bottom: 4,
                                child: CachedNetworkImage(
                                  imageUrl:
                                      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${pokemon.id}.png',
                                  height: 72,
                                  width: 72,
                                  fit: BoxFit.contain,
                                  placeholder: (_, __) => Image.asset(
                                    PokedexAssets.coloredPokeball,
                                    height: 30,
                                  ),
                                  errorWidget: (_, __, ___) => Image.asset(
                                    PokedexAssets.coloredPokeball,
                                    height: 40,
                                  ),
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
