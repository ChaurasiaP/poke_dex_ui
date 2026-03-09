import 'dart:developer';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poke_dex/providers/color_provider.dart';
import 'package:poke_dex/providers/data_provider.dart';
import 'package:poke_dex/view/assets/pokedex_assets.dart';
import 'package:poke_dex/view/screens/pokemon_details_screen.dart';
import 'package:poke_dex/view/utils/progress_indicator.dart';
import 'package:provider/provider.dart';

extension StringCasingExtension on String {
  String get toCapitalized =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String get toTitleCase => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized)
      .join(' ');
}

class PokedexHome extends StatefulWidget {
  const PokedexHome({super.key});

  @override
  State<PokedexHome> createState() => _PokedexHomeState();
}

class _PokedexHomeState extends State<PokedexHome> {
  int? _focusedIndex;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    var dataProvider = Provider.of<PokemonProvider>(context, listen: false);
    Future.microtask(() async {
      try {
        if (dataProvider.pokemonList.isEmpty) {
          await dataProvider.fetchPokemonList();
        }
      } catch (e) {
        log('Failed to fetch Pokémon list: $e');
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<PokemonProvider>(context);
    final colorProvider = Provider.of<ColorProvider>(context);

    final filtered = _searchQuery.isEmpty
        ? dataProvider.pokemonList
        : dataProvider.pokemonList
            .where((p) => (p.name ?? '')
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()))
            .toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0D0D1A), Color(0xFF1A1535)],
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset(PokedexAssets.coloredPokeball,
                              height: 32),
                          const SizedBox(width: 10),
                          const Text(
                            'Pokédex',
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
                        '${dataProvider.pokemonList.length} Pokémon available',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                // Search bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.20),
                          ),
                        ),
                        child: TextField(
                          controller: _searchController,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 15),
                          onChanged: (val) =>
                              setState(() => _searchQuery = val),
                          decoration: InputDecoration(
                            hintText: 'Search Pokémon…',
                            hintStyle: TextStyle(
                              color: Colors.white.withValues(alpha: 0.45),
                              fontSize: 15,
                            ),
                            prefixIcon: Icon(
                              Icons.search_rounded,
                              color: Colors.white.withValues(alpha: 0.55),
                              size: 20,
                            ),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? GestureDetector(
                                    onTap: () {
                                      _searchController.clear();
                                      setState(() => _searchQuery = '');
                                    },
                                    child: Icon(
                                      Icons.clear_rounded,
                                      color:
                                          Colors.white.withValues(alpha: 0.55),
                                      size: 18,
                                    ),
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Grid
                Expanded(
                  child: dataProvider.isLoading
                      ? const Center(
                          child: RotatingPokeball(),
                        )
                      : filtered.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.search_off_rounded,
                                    size: 60,
                                    color: Colors.white.withValues(alpha: 0.3),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'No Pokémon found',
                                    style: TextStyle(
                                      color:
                                          Colors.white.withValues(alpha: 0.5),
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : GridView.builder(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 0, 16, 120),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 1.35,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                              ),
                              itemCount: filtered.length,
                              itemBuilder: (context, index) {
                                final pokemon = filtered[index];
                                final realIndex =
                                    dataProvider.pokemonList.indexOf(pokemon);
                                final typeColor = colorProvider
                                    .getColorForType(pokemon.types.first.type);
                                return GestureDetector(
                                  onLongPress: () {
                                    setState(() {
                                      _focusedIndex = realIndex;
                                    });
                                  },
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PokemonDetailsScreen(
                                          pokemonData: pokemon,
                                          pokemonIndex: realIndex,
                                        ),
                                      ),
                                    );
                                  },
                                  child: _PokemonCard(
                                    pokemon: pokemon,
                                    index: realIndex,
                                    typeColor: typeColor,
                                  ),
                                );
                              },
                            ),
                ),
              ],
            ),
          ),

          // Long-press focus overlay
          if (_focusedIndex != null)
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: GestureDetector(
                onTap: () => setState(() => _focusedIndex = null),
                child: Container(
                  color: Colors.black.withValues(alpha: 0.65),
                  child: Center(
                    child: _QuickView(
                      index: _focusedIndex!,
                      pokemon: dataProvider.pokemonList[_focusedIndex!],
                      colorProvider: colorProvider,
                      onClose: () => setState(() => _focusedIndex = null),
                      onViewDetails: () {
                        final idx = _focusedIndex!;
                        setState(() => _focusedIndex = null);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PokemonDetailsScreen(
                              pokemonData: dataProvider.pokemonList[idx],
                              pokemonIndex: idx,
                            ),
                          ),
                        );
                      },
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

class _PokemonCard extends StatelessWidget {
  final dynamic pokemon;
  final int index;
  final Color typeColor;

  const _PokemonCard({
    required this.pokemon,
    required this.index,
    required this.typeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            typeColor.withValues(alpha: 0.80),
            typeColor.withValues(alpha: 0.50),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.22),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: typeColor.withValues(alpha: 0.35),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Pokeball background watermark
          Positioned(
            right: -20,
            bottom: -20,
            child: Opacity(
              opacity: 0.15,
              child: Image.asset(
                PokedexAssets.pokeball,
                height: 95,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '#${(index + 1).toString().padLeft(3, '0')}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.65),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  pokemon.name.toString().toCapitalized,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 4,
                  children: pokemon.types
                      .map<Widget>(
                        (t) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.22),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            t.type,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),

          // Pokemon image
          Positioned(
            bottom: 2,
            right: 4,
            child: CachedNetworkImage(
              imageUrl:
                  'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${index + 1}.png',
              height: 75,
              width: 75,
              fit: BoxFit.contain,
              placeholder: (context, url) => Image.asset(
                PokedexAssets.coloredPokeball,
                height: 40,
                color: Colors.white.withValues(alpha: 0.4),
              ),
              errorWidget: (context, url, error) => Image.asset(
                PokedexAssets.coloredPokeball,
                height: 60,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickView extends StatelessWidget {
  final int index;
  final dynamic pokemon;
  final ColorProvider colorProvider;
  final VoidCallback onClose;
  final VoidCallback onViewDetails;

  const _QuickView({
    required this.index,
    required this.pokemon,
    required this.colorProvider,
    required this.onClose,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    final typeColor = colorProvider.getColorForType(pokemon.types.first.type);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 28),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            typeColor.withValues(alpha: 0.90),
            typeColor.withValues(alpha: 0.60),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.30),
        ),
        boxShadow: [
          BoxShadow(
            color: typeColor.withValues(alpha: 0.4),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '#${(index + 1).toString().padLeft(3, '0')}',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 13,
            ),
          ),
          Text(
            pokemon.name.toString().toCapitalized ?? '',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          SvgPicture.network(
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/dream-world/${index + 1}.svg',
            height: 130,
            placeholderBuilder: (_) => const RotatingPokeball(),
          ),
          const SizedBox(height: 16),
          Text(
            'Ability: ${pokemon.abilities[0].name.toString().toCapitalized ?? ''}',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onClose,
                  style: OutlinedButton.styleFrom(
                    side:
                        BorderSide(color: Colors.white.withValues(alpha: 0.5)),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Close'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: onViewDetails,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: typeColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Details',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
