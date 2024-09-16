import 'package:flutter/material.dart';
import 'package:poke_dex/providers/color_provider.dart';
import 'package:poke_dex/providers/data_provider.dart';
import 'package:poke_dex/view/my_app.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PokemonProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ColorProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
