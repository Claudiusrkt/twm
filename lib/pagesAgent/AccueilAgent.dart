import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../pages/EtreConnecte.dart';
import '../pages/LoginPage.dart';
import '../providers/UserProvider.dart';
import '../model/bien.dart';
import 'PublierAnnonce.dart';
import 'ModifierAnnonce.dart';

class AccueilAgent extends StatefulWidget {
  const AccueilAgent({super.key});

  @override
  State<AccueilAgent> createState() => _AccueilAgentState();
}

class _AccueilAgentState extends State<AccueilAgent> {
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
  }

  void onLoginPressed() {
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
      final response = await http.get(Uri.parse('http://127.0.0.1:3000/api/properties'));

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

  void modifierAnnonce(Bien annonce) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ModifierAnnonce(annonce: annonce)),
    );

    if (result == true) {
      fetchAnnonces();
    }
  }

  void supprimerAnnonce(Bien annonce) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirmation"),
        content: const Text("Voulez-vous vraiment supprimer cette annonce ?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Non")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Oui")),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final response = await http.delete(
          Uri.parse('http://127.0.0.1:3000/api/properties/${annonce.id}'),
        );
        if (response.statusCode == 200) {
          setState(() {
            annonces.removeWhere((a) => a.id == annonce.id);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Annonce supprimée')),
          );
        } else {
          print("Erreur suppression : ${response.statusCode}");
        }
      } catch (e) {
        print("Erreur suppression : $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final utilisateur = Provider.of<UserProvider>(context).utilisateur;

    return Scaffold(
      appBar: AppBar(
        title: Text(utilisateur != null
            ? 'Agent : ${utilisateur.fullName}'
            : 'Accueil Agent'),
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
            onPressed: onLoginPressed,
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
                ? const Center(child: Text('Aucune annonce publiée'))
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
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => modifierAnnonce(annonce),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => supprimerAnnonce(annonce),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PublierAnnonce()),
          );
        },
        child: const Icon(Icons.add),
        tooltip: 'Ajouter une annonce',
      ),
    );
  }
}
