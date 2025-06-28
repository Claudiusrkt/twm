import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:twm/pages/LoginPage.dart';
import 'package:twm/pages/EtreConnecte.dart';
import '../providers/UserProvider.dart';
import '../model/bien.dart';

class Accueil extends StatefulWidget {
  const Accueil({super.key});

  @override
  State<Accueil> createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  final TextEditingController searchController = TextEditingController();
  bool showSearchField = false;
  bool showSearchButton = false;
  List<Bien> annonces = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    searchController.addListener(onSearchChanged);
    fetchAnnonces();
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
    // Ici tu peux filtrer la liste annonces selon query si tu veux
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

  Future<void> fetchAnnonces() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:3000/api/properties'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        setState(() {
          annonces = data.map((json) => Bien.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          annonces = [];
          isLoading = false;
        });
      }
    } catch (e) {
      print("Erreur de récupération : $e");
      setState(() {
        annonces = [];
        isLoading = false;
      });
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
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : annonces.isEmpty
                ? Center(
              child: Text(
                utilisateur == null
                    ? 'Connectez-vous pour voir les annonces.'
                    : 'Aucune annonce disponible.',
                style: const TextStyle(fontSize: 16),
              ),
            )
                : ListView.builder(
              itemCount: annonces.length,
              itemBuilder: (context, index) {
                final annonce = annonces[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(annonce.title),
                    subtitle: Text(
                      '${annonce.description}\nPrix: ${annonce.price} Ar\nSurface: ${annonce.surface} m²\nType: ${annonce.type}',
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
