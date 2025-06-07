import 'package:flutter/material.dart';

class MonFooter extends StatelessWidget {
  const MonFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.blue.shade300,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Text('© 2025 MonApp', style: TextStyle(color: Colors.white)),
            Icon(Icons.info, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
