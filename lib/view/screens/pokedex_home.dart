import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:poke_dex/providers/color_provider.dart';
import 'package:poke_dex/providers/data_provider.dart';
import 'package:poke_dex/style/responsive_var.dart';
import 'package:poke_dex/view/assets/pokedex_assets.dart';
import 'package:poke_dex/view/screens/filters/filter_by_type.dart';
import 'package:poke_dex/view/screens/pokemon_details_screen.dart';
import 'package:poke_dex/view/utils/progress_indicator.dart';
import 'package:provider/provider.dart';

class PokedexHome extends StatefulWidget {
  const PokedexHome({super.key});

  @override
  State<PokedexHome> createState() => _PokedexHomeState();
}

class _PokedexHomeState extends State<PokedexHome> {
  // Variable to track the index of the focused card
  int? _focusedIndex;

  @override
  void initState() {
    var dataProvider = Provider.of<PokemonProvider>(context, listen: false);
    Future.microtask(() async {
      try {
        await dataProvider.fetchPokemonList();
      } catch (e) {
        print('Failed to fetch Pokémon list: $e');
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<PokemonProvider>(context);
    final colorProvider = Provider.of<ColorProvider>(context);

    return Scaffold(
      backgroundColor: Colors.yellow.shade200,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
            child: dataProvider.pokemonList.isEmpty
                ? Center(
                    child: CircularProgressIndicator(
                      color: Colors.amber[300],
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      // _focusedIndex = -1;
                      setState(() {});
                    },
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 45, 16, 12),
                          child: Image.asset(PokedexAssets.bannerImg),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => FilterByType(),
                              ),
                            );
                          },
                          child: const Chip(
                            label: Text(
                              "Go to filters",
                            ),
                          ),
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
                            itemCount: dataProvider.pokemonList.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onLongPress: () {
                                  setState(() {
                                    _focusedIndex = index;
                                  });
                                },
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PokemonDetailsScreen(
                                        pokemonData:
                                            dataProvider.pokemonList[index],
                                      ),
                                    ),
                                  );
                                },
                                child: Card(
                                  color: colorProvider.getColorForType(
                                      dataProvider
                                          .pokemonList[index].types.first.type),
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
                                            EdgeInsets.fromLTRB(16, 12, 16, 16),
                                        child: Text(
                                          dataProvider.pokemonList[index].name!
                                              .toCapitalized,
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
                                                'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${index + 1}.png'),
                                      ),
                                      const Positioned(
                                        bottom: 16,
                                        left: -6,
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              16, 12, 16, 16),
                                          child: Text("Ability: "),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 2,
                                        left: -6,
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              16, 12, 16, 16),
                                          child: Text(dataProvider
                                              .pokemonList[index]
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
          ),
          if (_focusedIndex != null)
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: GestureDetector(
                onTap: () {
                  _focusedIndex = null;
                  setState(() {});
                },
                child: Container(
                  color: Colors.black.withOpacity(0.6),
                  child: Center(
                    child: Container(
                      width: Screen.width(context) * 0.8,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: colorProvider.getColorForType(dataProvider
                            .pokemonList[_focusedIndex ?? 0].types.last.type),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            dataProvider.pokemonList[_focusedIndex!].name!
                                .toCapitalized,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          SvgPicture.network(
                            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/dream-world/${_focusedIndex! + 1}.svg',
                            height: 120,
                            width: 120,
                            placeholderBuilder: (BuildContext context) =>
                                Center(
                              child: RotatingPokeball(),
                            ),
                          ),
                          // CachedNetworkImage(
                          //   imageUrl:
                          //       'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${_focusedIndex! + 1}.png',
                          //   height: 100,
                          //   width: 100,
                          //   placeholder: (context, url) =>
                          //       CircularProgressIndicator(),
                          //   errorWidget: (context, url, error) =>
                          //       Icon(Icons.error),
                          // ),
                          SizedBox(height: 10),
                          Text(
                            "Ability: ${dataProvider.pokemonList[_focusedIndex!].abilities[0].name!.toCapitalized}",
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PokemonDetailsScreen(
                                    pokemonData: dataProvider
                                        .pokemonList[_focusedIndex!],
                                  ),
                                ),
                              );
                            },
                            child: Text('View Details'),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _focusedIndex = null;
                              });
                            },
                            child: Text('Close'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

extension StringCasingExtension on String {
  String get toCapitalized =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String get toTitleCase => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized)
      .join(' ');
}
