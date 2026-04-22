import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:poke_dex/providers/color_provider.dart';
import 'package:poke_dex/providers/data_provider.dart';
import 'package:poke_dex/view/screens/pokemon_details_screen.dart';
import 'package:poke_dex/view/assets/pokedex_assets.dart';
import 'package:poke_dex/view/screens/pokedex_home.dart';
import 'package:provider/provider.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PokemonProvider>(context);
    final colorProvider = Provider.of<ColorProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: Stack(
        children: [
          // Gradient bg
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1A0A0F), Color(0xFF0D0D1A)],
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
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.favorite_rounded,
                              color: Color(0xFFFF4D6D), size: 28),
                          const SizedBox(width: 10),
                          const Text(
                            'Favourites',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF4D6D)
                                  .withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFFFF4D6D)
                                    .withValues(alpha: 0.35),
                              ),
                            ),
                            child: Text(
                              '${provider.favourites.length}',
                              style: const TextStyle(
                                color: Color(0xFFFF4D6D),
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        provider.favourites.isEmpty
                            ? 'Your favourites are empty'
                            : 'Swipe left to remove a Pokémon',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.45),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // List
                Expanded(
                  child: provider.favourites.isEmpty
                      ? _EmptyState(
                          icon: Icons.favorite_border_rounded,
                          title: 'No favourites yet',
                          subtitle:
                              'Open a Pokémon\'s details and tap ♥ to save it here',
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                          itemCount: provider.favourites.length,
                          itemBuilder: (context, index) {
                            final item = provider.favourites[index];
                            final typeColor = item.types.isNotEmpty
                                ? colorProvider.getColorForType(item.types.first.type)
                                : Colors.grey;
                            final pokemonIndex = provider.pokemonList
                                .indexWhere((p) => p.id == item.pokemonId);
                            final pokemon = pokemonIndex >= 0
                                ? provider.pokemonList[pokemonIndex]
                                : null;

                            return Dismissible(
                              key: ValueKey(item.pokemonId),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 24),
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade700
                                      .withValues(alpha: 0.85),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(Icons.delete_rounded,
                                    color: Colors.white, size: 26),
                              ),
                              onDismissed: (_) async {
                                await provider.removeFavourite(item.pokemonId);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          '${item.name.toCapitalized} removed from favourites'),
                                      action: SnackBarAction(
                                        label: 'Undo',
                                        onPressed: () => provider
                                            .addFavourite(item.pokemonId),
                                      ),
                                      backgroundColor:
                                          const Color(0xFF1E1E2E),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(14),
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: GestureDetector(
                                onTap: () {
                                  if (pokemon != null) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => PokemonDetailsScreen(
                                          pokemonData: pokemon,
                                          pokemonIndex: pokemonIndex,
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        typeColor.withValues(alpha: 0.65),
                                        typeColor.withValues(alpha: 0.35),
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color:
                                          Colors.white.withValues(alpha: 0.18),
                                    ),
                                  ),
                                  child: ListTile(
                                    contentPadding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                    leading: CachedNetworkImage(
                                      imageUrl: item.frontSprite ??
                                          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${item.pokemonId}.png',
                                      height: 55,
                                      width: 55,
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
                                    title: Text(
                                      item.name.toCapitalized,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                      ),
                                    ),
                                    subtitle: Wrap(
                                      spacing: 4,
                                      children: item.types
                                          .map<Widget>(
                                            (t) => Container(
                                              margin:
                                                  const EdgeInsets.only(top: 4),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 2),
                                              decoration: BoxDecoration(
                                                color: Colors.white
                                                    .withValues(alpha: 0.20),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                t.type.toCapitalized,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                    trailing: const Icon(
                                      Icons.favorite_rounded,
                                      color: Color(0xFFFF4D6D),
                                      size: 20,
                                    ),
                                  ),
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

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 72, color: Colors.white.withValues(alpha: 0.18)),
            const SizedBox(height: 20),
            Text(
              title,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.60),
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.35),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
