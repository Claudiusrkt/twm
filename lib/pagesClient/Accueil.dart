import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:twm/pages/LoginPage.dart';
import 'package:twm/pages/EtreConnecte.dart';
import '../pages/ArViewer.dart';
import '../providers/UserProvider.dart';
import '../model/bien.dart';
import 'EnvoyeRdv.dart';

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
  final Set<int> favoris = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    searchController.addListener(onSearchChanged);
    fetchAnnonces();

    final user = Provider.of<UserProvider>(context, listen: false).utilisateur;
    if (user != null) {
      fetchFavoris(user.id);
    }
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

  Future<void> fetchAnnonces() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.176:3000/api/properties'));

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

  Future<void> fetchFavoris(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.176:3000/api/favorites?userId=$userId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        setState(() {
          favoris.clear();
          for (var fav in data) {
            favoris.add(fav['propertyId']);
          }
        });
      }
    } catch (e) {
      print('Erreur lors du chargement des favoris : $e');
    }
  }

  Future<void> toggleFavoris(int propertyId) async {
    final user = Provider.of<UserProvider>(context, listen: false).utilisateur;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Connectez-vous pour gérer les favoris.')),
      );
      return;
    }

    final alreadyFavori = favoris.contains(propertyId);
    final url = Uri.parse('http://192.168.1.176:3000/api/favorites');

    try {
      http.Response response;
      if (alreadyFavori) {
        response = await http.delete(
          url,
          body: jsonEncode({
            'userId': user.id,
            'propertyId': propertyId,
          }),
          headers: {'Content-Type': 'application/json'},
        );
      } else {
        response = await http.post(
          url,
          body: jsonEncode({
            'userId': user.id,
            'propertyId': propertyId,
          }),
          headers: {'Content-Type': 'application/json'},
        );
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          if (alreadyFavori) {
            favoris.remove(propertyId);
          } else {
            favoris.add(propertyId);
          }
        });
      } else {
        print('Erreur lors de la mise à jour des favoris : ${response.body}');
      }
    } catch (e) {
      print('Erreur toggleFavoris : $e');
    }
  }

  void lancer3D(Bien annonce) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ARViewPage()),
    );
  }




  void contacterAgent(Bien annonce) {
    if (annonce.agentId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EnvoyerRdvPage(
            propertyId: annonce.id,
            agentId: annonce.agentId!,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("L'agent de ce bien est inconnu.")),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    final utilisateur = Provider.of<UserProvider>(context).utilisateur;

    return Scaffold(
      appBar: AppBar(
        title: Text(utilisateur != null ? 'Bienvenue ${utilisateur.fullName}' : 'Accueil'),
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
                      onPressed: () => performSearch(searchController.text),
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
                final isFavori = favoris.contains(annonce.id);

                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(annonce.title),
                        subtitle: Text(
                          '${annonce.description}\nPrix: ${annonce.price} Ar\nSurface: ${annonce.surface} m²\nType: ${annonce.type}',
                        ),
                        isThreeLine: true,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8.0, bottom: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(
                                isFavori ? Icons.favorite : Icons.favorite_border,
                                color: isFavori ? Colors.red : Colors.grey,
                              ),
                              onPressed: () => toggleFavoris(annonce.id),
                              tooltip: 'Ajouter aux favoris',
                            ),
                            IconButton(
                              icon: const Icon(Icons.threed_rotation, color: Colors.blue),
                              onPressed: () => lancer3D(annonce),
                              tooltip: 'Vue 3D',
                            ),
                            IconButton(
                              icon: const Icon(Icons.phone, color: Colors.green),
                              onPressed: () => contacterAgent(annonce),
                              tooltip: 'Contacter l\'agent',
                            ),
                          ],
                        ),
                      )
                    ],
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
