import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twm/pages/LoginPage.dart';
import 'package:twm/pages/EtreConnecte.dart';
import '../providers/UserProvider.dart';

class Accueil extends StatefulWidget {
  const Accueil({super.key});

  @override
  State<Accueil> createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  final TextEditingController searchController = TextEditingController();
  bool showSearchField = false;
  bool showSearchButton = false;

  @override
  void initState() {
    super.initState();
    searchController.addListener(onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  void onSearchChanged() {
    setState(() {
      showSearchButton = searchController.text.isNotEmpty;
    });
  }

  void performSearch(String query) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Recherche lancée pour : "$query"')),
    );
  }

  void onAccountPressed() {
    final utilisateur = Provider.of<UserProvider>(context, listen: false).utilisateur;

    if (utilisateur != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EtreConnecte(utilisateur: utilisateur),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final utilisateur = Provider.of<UserProvider>(context).utilisateur;

    return Scaffold(
      appBar: AppBar(
        title: Text(utilisateur != null
            ? 'Bienvenue ${utilisateur.fullName}'
            : 'Accueil'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade300,
        actions: [
          IconButton(
            icon: Icon(showSearchField ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                showSearchField = !showSearchField;
                if (!showSearchField) {
                  searchController.clear();
                  showSearchButton = false;
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: onAccountPressed,
          ),
        ],
      ),
      body: Column(
        children: [
          if (showSearchField)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Rechercher...',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (showSearchButton)
                    ElevatedButton(
                      onPressed: () {
                        performSearch(searchController.text);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade100,
                        foregroundColor: Colors.black54,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      ),
                      child: const Text('Rechercher'),
                    ),
                ],
              ),
            ),
          Expanded(
            child: Center(
              child: Text('Contenu de la page d’accueil'),
            ),
          ),
        ],
      ),
    );
  }
}
