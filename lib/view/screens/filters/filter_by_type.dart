import 'package:flutter/material.dart';
import 'package:poke_dex/providers/color_provider.dart';
import 'package:poke_dex/providers/data_provider.dart';
import 'package:poke_dex/view/screens/pokedex_home.dart';
import 'package:poke_dex/view/screens/specific_pokemon_list_screen.dart';
import 'package:provider/provider.dart';

class FilterByType extends StatelessWidget {
  const FilterByType({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PokemonProvider>(context);
    final colorProvider = Provider.of<ColorProvider>(context);
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
            child: Center(
              child: Column(
                children: [
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.4,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                      ),
                      itemCount: provider.pokemonTypes.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onLongPress: () {},
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PokemonTypeScreen(
                                  pokemonTypeList: provider.pokemonList
                                      .where(
                                        (type) => type.types.any(
                                          (test) =>
                                              test.type ==
                                              provider.pokemonTypes[index],
                                        ),
                                      )
                                      .toList(),
                                  pokemonType: provider.pokemonTypes[index],
                                ),
                              ),
                            );
                          },
                          child: Card(
                            color: colorProvider.getLight2ColorForType(
                              provider.pokemonTypes[index],
                            ),
                            child: Stack(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(80, 20, 18, 16),
                                  child: Align(
                                    alignment: AlignmentDirectional.bottomEnd,
                                    child: Container(
                                      // decoration: BoxDecoration(
                                      //   border: Border.all(
                                      //     color: Colors.black,
                                      //   ),
                                      // ),
                                      height: 155,
                                      width: 155,
                                      child: Image.asset(
                                        scale: 1,
                                        provider.getTypeAsset(
                                          provider.pokemonTypes[index],
                                        ),
                                        color:
                                            colorProvider.getLight1ColorForType(
                                                provider.pokemonTypes[index]),
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: AlignmentDirectional.centerStart,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 12, left: 16),
                                    child: Text(
                                      "${provider.pokemonTypes[index].toCapitalized}\nType",
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w500,
                                        foreground: Paint()
                                          ..style = PaintingStyle.stroke
                                          ..strokeWidth = 1
                                          ..color =
                                              colorProvider.getColorForType(
                                                  provider.pokemonTypes[index]),
                                      ),
                                    ),
                                  ),
                                ),
                                // Align(
                                //   alignment: AlignmentDirectional.bottomStart,
                                //   child: Padding(
                                //     padding: const EdgeInsets.only(
                                //       bottom: 12,
                                //       left: 16,
                                //     ),
                                //     child: Text(
                                //       "Type",
                                //       style: TextStyle(
                                //         fontSize: 22,
                                //         fontWeight: FontWeight.w500,
                                //         foreground: Paint()
                                //           ..style = PaintingStyle.stroke
                                //           ..strokeWidth = 1.2
                                //           ..color =
                                //               colorProvider.getColorForType(
                                //                   provider.pokemonTypes[index]),
                                //       ),
                                //     ),
                                //   ),
                                // ),
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
          // SizedBox(
          //   height: Screen.height(context),
          //   child:
          //    ListView.builder(
          //     itemCount: provider.pokemonTypes.length,
          //     itemBuilder: (context, index) {
          //       return ListTile(
          //         dense: true,
          //         visualDensity: const VisualDensity(
          //           horizontal: VisualDensity.minimumDensity,
          //         ),
          //         minLeadingWidth: -4,
          //         leading: Text(
          //           "${index + 1}.",
          //           textScaleFactor: 1,
          //           style: TextStyle(
          //             fontSize: 16,
          //           ),
          //         ),
          //         trailing: Checkbox(
          //           value: false,
          //           onChanged: (value) {},
          //         ),
          //         title: Text(
          //           provider.pokemonTypes[index].toCapitalized,
          //           textScaleFactor: 1,
          //           style: TextStyle(
          //             fontSize: 16,
          //           ),
          //         ),
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
