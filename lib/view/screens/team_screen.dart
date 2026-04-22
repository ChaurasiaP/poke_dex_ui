import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:poke_dex/model/api_models/team_model.dart';
import 'package:poke_dex/providers/color_provider.dart';
import 'package:poke_dex/providers/data_provider.dart';
import 'package:poke_dex/view/assets/pokedex_assets.dart';
import 'package:poke_dex/view/screens/pokemon_details_screen.dart';
import 'package:poke_dex/view/screens/pokedex_home.dart';
import 'package:provider/provider.dart';

class TeamScreen extends StatelessWidget {
  const TeamScreen({super.key});

  void _showEditNicknameDialog(
    BuildContext context,
    ApiTeamEntry entry,
    PokemonProvider provider,
  ) {
    final controller = TextEditingController(text: entry.nickname);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E30),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Rename ${entry.name.toCapitalized}',
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter nickname…',
            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.08),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.5))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6F35FC),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              final nick = controller.text.trim();
              if (nick.isNotEmpty) {
                await provider.updateTeamNickname(entry.pokemonId, nick);
              }
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Save',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

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
                colors: [Color(0xFF0A1020), Color(0xFF0D0D1A)],
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
                          const Icon(Icons.shield_rounded,
                              color: Color(0xFF6F35FC), size: 28),
                          const SizedBox(width: 10),
                          const Text(
                            'My Team',
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
                              color: const Color(0xFF6F35FC)
                                  .withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFF6F35FC)
                                    .withValues(alpha: 0.35),
                              ),
                            ),
                            child: Text(
                              '${provider.team.length}/6',
                              style: const TextStyle(
                                color: Color(0xFF6F35FC),
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        provider.team.isEmpty
                            ? 'Build your dream team of 6!'
                            : 'Long-press to rename · Tap × to remove',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.45),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Team grid
                Expanded(
                  child: provider.team.isEmpty
                      ? _buildEmptyTeam()
                      : GridView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.1,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                          ),
                          itemCount: provider.team.length,
                          itemBuilder: (context, index) {
                            final entry = provider.team[index];
                            final typeColor = entry.types.isNotEmpty
                                ? colorProvider.getColorForType(entry.types.first.type)
                                : Colors.grey;
                            final pokemonIndex = provider.pokemonList
                                .indexWhere((p) => p.id == entry.pokemonId);
                            final pokemon = pokemonIndex >= 0
                                ? provider.pokemonList[pokemonIndex]
                                : null;

                            return GestureDetector(
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
                              onLongPress: () => _showEditNicknameDialog(
                                  context, entry, provider),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      typeColor.withValues(alpha: 0.80),
                                      typeColor.withValues(alpha: 0.45),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(22),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.22),
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
                                    // Pokeball watermark
                                    Positioned(
                                      right: -15,
                                      bottom: -15,
                                      child: Opacity(
                                        opacity: 0.12,
                                        child: Image.asset(
                                          PokedexAssets.pokeball,
                                          height: 80,
                                        ),
                                      ),
                                    ),
                                    // Remove button
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: GestureDetector(
                                        onTap: () async {
                                          await provider.removeFromTeam(entry.pokemonId);
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    '${entry.nickname} removed from team'),
                                                backgroundColor:
                                                    const Color(0xFF1E1E2E),
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: Colors.black
                                                .withValues(alpha: 0.30),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.close_rounded,
                                            color: Colors.white,
                                            size: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Content
                                    Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Pokemon image
                                          Expanded(
                                            child: Center(
                                              child: CachedNetworkImage(
                                                imageUrl: entry.frontSprite ??
                                                    'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${entry.pokemonId}.png',
                                                fit: BoxFit.contain,
                                                placeholder: (_, __) =>
                                                    Image.asset(
                                                  PokedexAssets.coloredPokeball,
                                                  height: 30,
                                                ),
                                                errorWidget: (_, __, ___) =>
                                                    Image.asset(
                                                  PokedexAssets.coloredPokeball,
                                                  height: 40,
                                                ),
                                              ),
                                            ),
                                          ),
                                          // Nickname
                                          Text(
                                            entry.nickname.toCapitalized,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 13,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          if (entry.nickname.toLowerCase() !=
                                              entry.name.toLowerCase())
                                            Text(
                                              entry.name.toCapitalized,
                                              style: TextStyle(
                                                color: Colors.white
                                                    .withValues(alpha: 0.55),
                                                fontSize: 10,
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

  Widget _buildEmptyTeam() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 2x3 empty slot grid
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: List.generate(
                6,
                (i) => Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.12),
                    ),
                  ),
                  child: Icon(
                    Icons.add_rounded,
                    color: Colors.white.withValues(alpha: 0.20),
                    size: 28,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'Your team is empty',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.60),
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Open a Pokémon\'s details and tap "Add to Team"\nto build your squad of 6',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.35),
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
