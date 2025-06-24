import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twm/pagesClient/Accueil.dart';
import 'providers/UserProvider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade100),
      ),
      home: const Accueil(),
    );
  }
}
