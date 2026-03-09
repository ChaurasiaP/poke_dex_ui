import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poke_dex/model/pokemon_data_model.dart';
import 'package:poke_dex/providers/color_provider.dart';
import 'package:poke_dex/providers/data_provider.dart';
import 'package:poke_dex/view/assets/pokedex_assets.dart';
import 'package:poke_dex/view/screens/pokedex_home.dart';
import 'package:provider/provider.dart';

class PokemonDetailsScreen extends StatefulWidget {
  const PokemonDetailsScreen({
    super.key,
    required this.pokemonData,
    required this.pokemonIndex,
  });

  final Pokemon pokemonData;
  final int pokemonIndex;

  @override
  State<PokemonDetailsScreen> createState() => _PokemonDetailsScreenState();
}

class _PokemonDetailsScreenState extends State<PokemonDetailsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showAddToTeamDialog(BuildContext context, PokemonProvider provider) {
    final nicknameController =
        TextEditingController(text: widget.pokemonData.name?.toCapitalized);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E30),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          'Add ${widget.pokemonData.name?.toCapitalized} to Team',
          style: const TextStyle(color: Colors.white, fontSize: 17),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Give it a nickname (optional)',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: nicknameController,
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: widget.pokemonData.name?.toCapitalized ?? '',
                hintStyle: TextStyle(
                    color: Colors.white.withValues(alpha: 0.35)),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.08),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel',
                style:
                    TextStyle(color: Colors.white.withValues(alpha: 0.5))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6F35FC),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              final nick = nicknameController.text.trim();
              final result = await provider.addToTeam(
                widget.pokemonData,
                nickname: nick.isNotEmpty ? nick : null,
              );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(result.message),
                    backgroundColor: result.success
                        ? const Color(0xFF1E3040)
                        : Colors.red.shade900,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                );
              }
            },
            child: const Text('Add!',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorProvider = Provider.of<ColorProvider>(context);
    final provider = Provider.of<PokemonProvider>(context);
    final pokemon = widget.pokemonData;
    final typeColor = colorProvider.getColorForType(pokemon.types.first.type);
    final isFav = provider.isFavourite(pokemon.id);
    final inTeam = provider.isInTeam(pokemon.id);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: Stack(
        children: [
          // Type colour bg splash
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.50,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    typeColor.withValues(alpha: 0.88),
                    typeColor.withValues(alpha: 0.40),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // Pokeball watermark
          Positioned(
            top: -30,
            right: -40,
            child: Opacity(
              opacity: 0.12,
              child: Image.asset(PokedexAssets.pokeball, height: 220),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // App bar
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                      const Spacer(),
                      // Favourite button
                      GestureDetector(
                        onTap: () async {
                          if (isFav) {
                            await provider.removeFavourite(pokemon.id!);
                          } else {
                            await provider.addFavourite(pokemon);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isFav
                                ? const Color(0xFFFF4D6D)
                                    .withValues(alpha: 0.25)
                                : Colors.white.withValues(alpha: 0.18),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isFav
                                  ? const Color(0xFFFF4D6D)
                                      .withValues(alpha: 0.55)
                                  : Colors.white.withValues(alpha: 0.30),
                            ),
                          ),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            child: Icon(
                              isFav
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              key: ValueKey(isFav),
                              color: isFav
                                  ? const Color(0xFFFF4D6D)
                                  : Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: FadeTransition(
                    opacity: _fadeAnim,
                    child: SlideTransition(
                      position: _slideAnim,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(bottom: 32),
                        child: Column(
                          children: [
                            // Pokemon name & number
                            Text(
                              '#${(widget.pokemonIndex + 1).toString().padLeft(3, '0')}',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.65),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              pokemon.name?.toCapitalized ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 34,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 6),

                            // Type chips
                            Wrap(
                              spacing: 8,
                              children: pokemon.types.map((t) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 5),
                                  decoration: BoxDecoration(
                                    color:
                                        Colors.white.withValues(alpha: 0.22),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.white
                                          .withValues(alpha: 0.40),
                                    ),
                                  ),
                                  child: Text(
                                    t.type.toCapitalized,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),

                            const SizedBox(height: 24),

                            // Pokemon image
                            SvgPicture.network(
                              'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/dream-world/${widget.pokemonIndex + 1}.svg',
                              height: 190,
                              placeholderBuilder: (_) =>
                                  CachedNetworkImage(
                                imageUrl:
                                    'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${widget.pokemonIndex + 1}.png',
                                height: 190,
                              ),
                            ),

                            const SizedBox(height: 28),

                            // Info card (glass)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(28),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                      sigmaX: 20, sigmaY: 20),
                                  child: Container(
                                    padding: const EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.white.withValues(alpha: 0.08),
                                      borderRadius: BorderRadius.circular(28),
                                      border: Border.all(
                                        color: Colors.white
                                            .withValues(alpha: 0.16),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        // Basic stats row
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            _StatPill(
                                              label: 'Height',
                                              value:
                                                  '${((pokemon.height ?? 0) * 0.1).toStringAsFixed(1)}m',
                                              icon: Icons
                                                  .height_rounded,
                                            ),
                                            Container(
                                                height: 40,
                                                width: 1,
                                                color: Colors.white
                                                    .withValues(alpha: 0.15)),
                                            _StatPill(
                                              label: 'ID',
                                              value:
                                                  '#${pokemon.id}',
                                              icon: Icons
                                                  .tag_rounded,
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 20),
                                        Divider(
                                            color: Colors.white
                                                .withValues(alpha: 0.10)),
                                        const SizedBox(height: 16),

                                        // Abilities
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Abilities',
                                            style: TextStyle(
                                              color: Colors.white
                                                  .withValues(alpha: 0.55),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 1.2,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          children: pokemon.abilities
                                              .map((a) => Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                            horizontal: 14,
                                                            vertical: 8),
                                                    decoration: BoxDecoration(
                                                      color: typeColor
                                                          .withValues(alpha: 0.22),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      border: Border.all(
                                                        color: typeColor
                                                            .withValues(alpha: 0.40),
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                          a.name?.toCapitalized ??
                                                              '',
                                                          style: const TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 13,
                                                          ),
                                                        ),
                                                        if (a.isHidden ==
                                                            true) ...[
                                                          const SizedBox(
                                                              width: 6),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal: 5,
                                                                    vertical: 2),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors.white
                                                                  .withValues(
                                                                      alpha: 0.15),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6),
                                                            ),
                                                            child: const Text(
                                                              'Hidden',
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.white,
                                                                fontSize: 9,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ],
                                                    ),
                                                  ))
                                              .toList(),
                                        ),

                                        const SizedBox(height: 20),
                                        Divider(
                                            color: Colors.white
                                                .withValues(alpha: 0.10)),
                                        const SizedBox(height: 20),

                                        // Action buttons
                                        Row(
                                          children: [
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () async {
                                                  if (isFav) {
                                                    await provider
                                                        .removeFavourite(
                                                            pokemon.id!);
                                                  } else {
                                                    await provider
                                                        .addFavourite(pokemon);
                                                  }
                                                },
                                                child: AnimatedContainer(
                                                  duration: const Duration(
                                                      milliseconds: 250),
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                          vertical: 14),
                                                  decoration: BoxDecoration(
                                                    color: isFav
                                                        ? const Color(
                                                                0xFFFF4D6D)
                                                            .withValues(
                                                                alpha: 0.25)
                                                        : Colors.white
                                                            .withValues(
                                                                alpha: 0.08),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                    border: Border.all(
                                                      color: isFav
                                                          ? const Color(
                                                                  0xFFFF4D6D)
                                                              .withValues(
                                                                  alpha: 0.55)
                                                          : Colors.white
                                                              .withValues(
                                                                  alpha: 0.15),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        isFav
                                                            ? Icons
                                                                .favorite_rounded
                                                            : Icons
                                                                .favorite_border_rounded,
                                                        color: isFav
                                                            ? const Color(
                                                                0xFFFF4D6D)
                                                            : Colors.white,
                                                        size: 18,
                                                      ),
                                                      const SizedBox(width: 6),
                                                      Text(
                                                        isFav
                                                            ? 'Saved'
                                                            : 'Favourite',
                                                        style: TextStyle(
                                                          color: isFav
                                                              ? const Color(
                                                                  0xFFFF4D6D)
                                                              : Colors.white,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: inTeam
                                                    ? null
                                                    : () =>
                                                        _showAddToTeamDialog(
                                                            context, provider),
                                                child: AnimatedContainer(
                                                  duration: const Duration(
                                                      milliseconds: 250),
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                          vertical: 14),
                                                  decoration: BoxDecoration(
                                                    gradient: inTeam
                                                        ? null
                                                        : LinearGradient(
                                                            colors: [
                                                              const Color(
                                                                  0xFF6F35FC),
                                                              const Color(
                                                                  0xFF9B5FED),
                                                            ],
                                                          ),
                                                    color: inTeam
                                                        ? Colors.white
                                                            .withValues(
                                                                alpha: 0.08)
                                                        : null,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                    border: Border.all(
                                                      color: inTeam
                                                          ? const Color(
                                                                  0xFF6F35FC)
                                                              .withValues(
                                                                  alpha: 0.45)
                                                          : Colors.transparent,
                                                    ),
                                                    boxShadow: inTeam
                                                        ? null
                                                        : [
                                                            BoxShadow(
                                                              color: const Color(
                                                                      0xFF6F35FC)
                                                                  .withValues(
                                                                      alpha:
                                                                          0.40),
                                                              blurRadius: 14,
                                                              offset:
                                                                  const Offset(
                                                                      0, 4),
                                                            ),
                                                          ],
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        inTeam
                                                            ? Icons
                                                                .shield_rounded
                                                            : Icons
                                                                .add_rounded,
                                                        color: inTeam
                                                            ? const Color(
                                                                0xFF6F35FC)
                                                            : Colors.white,
                                                        size: 18,
                                                      ),
                                                      const SizedBox(width: 6),
                                                      Text(
                                                        inTeam
                                                            ? 'In Team'
                                                            : 'Add to Team',
                                                        style: TextStyle(
                                                          color: inTeam
                                                              ? const Color(
                                                                  0xFF6F35FC)
                                                              : Colors.white,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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

class _StatPill extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatPill({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white.withValues(alpha: 0.55), size: 20),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.50),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
