import 'package:flutter/material.dart';

class Bienvenu extends StatefulWidget {
  const Bienvenu({super.key, required this.title});

  final String title;

  @override
  State<Bienvenu> createState() => BienvenuState();
}

class BienvenuState extends State<Bienvenu> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Bienvenue sur notre application'),

          ],
        ),
      ),
    );
  }
}