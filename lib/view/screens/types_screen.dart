import 'package:flutter/material.dart';
import 'package:poke_dex/providers/color_provider.dart';
import 'package:poke_dex/providers/data_provider.dart';
import 'package:poke_dex/view/screens/pokedex_home.dart';
import 'package:poke_dex/view/screens/specific_pokemon_list_screen.dart';
import 'package:provider/provider.dart';

class TypesScreen extends StatelessWidget {
  const TypesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PokemonProvider>(context);
    final colorProvider = Provider.of<ColorProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF100D20), Color(0xFF0D0D1A)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.auto_awesome_mosaic_rounded,
                              color: Color(0xFFF7D02C), size: 28),
                          SizedBox(width: 10),
                          Text(
                            'Types',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tap a type to browse its Pokémon',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.45),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: provider.pokemonTypes.isEmpty
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFF7D02C),
                          ),
                        )
                      : GridView.builder(
                          padding:
                              const EdgeInsets.fromLTRB(16, 0, 16, 120),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.4,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                          ),
                          itemCount: provider.pokemonTypes.length,
                          itemBuilder: (context, index) {
                            final type = provider.pokemonTypes[index];
                            final typeColor =
                                colorProvider.getColorForType(type);
                            final light1 =
                                colorProvider.getLight1ColorForType(type);
                            final light2 =
                                colorProvider.getLight2ColorForType(type);

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PokemonTypeScreen(
                                      pokemonTypeList: provider.pokemonList
                                          .where((p) => p.types
                                              .any((t) => t.type == type))
                                          .toList(),
                                      pokemonType: type,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      light2.withValues(alpha: 0.90),
                                      light1.withValues(alpha: 0.65),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color:
                                        Colors.white.withValues(alpha: 0.20),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: typeColor.withValues(alpha: 0.25),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  children: [
                                    // Type icon watermark
                                    Positioned(
                                      right: -10,
                                      bottom: -10,
                                      child: Opacity(
                                        opacity: 0.25,
                                        child: Image.asset(
                                          provider.getTypeAsset(type),
                                          height: 85,
                                          color: typeColor,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            type.toCapitalized,
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w800,
                                              color: typeColor,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${provider.pokemonList.where((p) => p.types.any((t) => t.type == type)).length} Pokémon',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: typeColor
                                                  .withValues(alpha: 0.75),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
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
