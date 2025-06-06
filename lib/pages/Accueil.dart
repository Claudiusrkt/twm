import 'package:flutter/material.dart';

class Accueil extends StatefulWidget {
  const Accueil({super.key});

  @override
  State<Accueil> createState() => AccueilState();
}

class AccueilState extends State<Accueil> {
  bool isSearching = false;
  final TextEditingController searchController = TextEditingController();
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
    print('Recherche lancée pour : "$query"');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Recherche lancée pour : "$query"')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? TextField(
          controller: searchController,
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          decoration: const InputDecoration(
            hintText: 'Rechercher...',
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
          autofocus: true,
        )
            : const Text('Accueil'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade300,
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) {
                  searchController.clear();
                  showSearchButton = false;
                }
              });
            },
          ),
          if (isSearching && showSearchButton)
            TextButton(
              onPressed: () {
                performSearch(searchController.text);
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue.shade100, // Fond blanc semi-transparent
                foregroundColor: Colors.white, // Couleur du texte et des icônes (blanc)
                shape: RoundedRectangleBorder( // Définit la forme du bouton
                  borderRadius: BorderRadius.circular(8), // Bords arrondis de 8 pixels
                  side: const BorderSide(color: Colors.white, width: 1), // Bordure fine blanche
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Rembourrage interne
              ),
              child: const Text(
                'Rechercher',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: Container(),
    );
  }
}