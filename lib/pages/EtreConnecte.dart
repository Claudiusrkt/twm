import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:twm/model/utilisateur.dart';
import 'package:twm/pages/LoginPage.dart';
import '../providers/UserProvider.dart';

class EtreConnecte extends StatefulWidget {
  final Utilisateur utilisateur;

  const EtreConnecte({super.key, required this.utilisateur});

  @override
  State<EtreConnecte> createState() => _EtreConnecteState();
}

class _EtreConnecteState extends State<EtreConnecte> {
  late TextEditingController fullNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    fullNameController = TextEditingController(text: widget.utilisateur.fullName);
    emailController = TextEditingController(text: widget.utilisateur.email);
    phoneController = TextEditingController(text: widget.utilisateur.phone);
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void seDeconnecter(BuildContext context) {
    Provider.of<UserProvider>(context, listen: false).clearUtilisateur();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
    );
  }

  Future<void> enregistrerModifications(BuildContext context) async {
    setState(() {
      isSaving = true;
    });

    final updatedUser = Utilisateur(
      id: widget.utilisateur.id,
      fullName: fullNameController.text,
      email: emailController.text,
      phone: phoneController.text,
      role: widget.utilisateur.role,
    );

    // Construire l’URL selon le rôle
    final String baseUrl = 'http://10.0.2.2:3000/api';
    final String url = widget.utilisateur.role == 'agent'
        ? '$baseUrl/agents/${updatedUser.id}'
        : '$baseUrl/users/${updatedUser.id}';

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fullName': updatedUser.fullName,
          'phone': updatedUser.phone,
        }),
      );

      if (response.statusCode == 200) {
        Provider.of<UserProvider>(context, listen: false).setUtilisateur(updatedUser);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Modifications enregistrées avec succès')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Échec de la mise à jour : ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur de connexion : $e')),
      );
    }

    setState(() {
      isSaving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenue'),
        backgroundColor: Colors.blue.shade300,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Se déconnecter',
            onPressed: () => seDeconnecter(context),
          ),
        ],
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
                TextField(
                  controller: fullNameController,
                  decoration: const InputDecoration(labelText: 'Nom complet'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  enabled: false,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'Téléphone'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: isSaving ? null : () => enregistrerModifications(context),
                  child: isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Enregistrer les modifications'),
                ),
                const SizedBox(height: 10),
                Text(
                  'Rôle : ${widget.utilisateur.role}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
