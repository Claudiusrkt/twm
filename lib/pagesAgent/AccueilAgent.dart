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
import 'RdvAgentPage.dart';

class AccueilAgent extends StatefulWidget {
  const AccueilAgent({super.key});

  @override
  State<AccueilAgent> createState() => _AccueilAgentState();
}

class _AccueilAgentState extends State<AccueilAgent> {
  List<Bien> annonces = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAnnonces();
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

  void onNotificationsPressed() {
    final utilisateur = Provider.of<UserProvider>(context, listen: false).utilisateur;
    if (utilisateur != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => RdvAgentPage(agentId: utilisateur.id),
        ),
      );
    }
  }

  Future<void> fetchAnnonces() async {
    final utilisateur = Provider.of<UserProvider>(context, listen: false).utilisateur;

    if (utilisateur == null) return;

    try {
      final response = await http.get(Uri.parse('http://192.168.1.176:3000/api/properties'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        setState(() {
          annonces = data
              .map((json) => Bien.fromJson(json))
              .where((annonce) => annonce.agentId == utilisateur.id)
              .toList();
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
          Uri.parse('http://192.168.1.176:3000/api/properties/${annonce.id}'),
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
            icon: const Icon(Icons.notifications),
            onPressed: onNotificationsPressed,
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: onLoginPressed,
          ),
        ],
      ),
      body: isLoading
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PublierAnnonce()),
          );

          if (result == true) {
            fetchAnnonces();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Nouvelle annonce ajoutée')),
            );
          }
        },
        child: const Icon(Icons.add),
        tooltip: 'Ajouter une annonce',
      ),
    );
  }
}
