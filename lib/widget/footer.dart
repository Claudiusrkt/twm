import 'package:flutter/material.dart';

class MonFooter extends StatelessWidget {
  const MonFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.blue.shade300,
      child: SizedBox(
        height: 50.0, // Hauteur réduite ici
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.home, color: Colors.white),
              iconSize: 50.0,
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.account_circle, color: Colors.white),
              iconSize: 50.0,
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.info_outline, color: Colors.white),
              iconSize: 50.0,
            ),
          ],
        ),
      ),
    );
  }
}
