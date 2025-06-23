import 'package:flutter/material.dart';
import 'package:twm/model/utilisateur.dart';

class EtreConnecte extends StatelessWidget {
  final Utilisateur utilisateur;

  const EtreConnecte({super.key, required this.utilisateur});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenue'),
        backgroundColor: Colors.blue.shade300,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.account_circle, size: 80, color: Colors.blue),
                const SizedBox(height: 20),
                Text(
                  utilisateur.fullName,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ListTile(
                  leading: const Icon(Icons.email),
                  title: Text(utilisateur.email),
                ),
                ListTile(
                  leading: const Icon(Icons.phone),
                  title: Text(utilisateur.phone),
                ),
                ListTile(
                  leading: const Icon(Icons.badge),
                  title: Text(utilisateur.role),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
