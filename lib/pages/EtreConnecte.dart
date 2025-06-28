import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  void enregistrerModifications(BuildContext context) {
    final updatedUser = Utilisateur(
      id: widget.utilisateur.id,  // Important de garder l'id
      fullName: fullNameController.text,
      email: emailController.text,
      phone: phoneController.text,
      role: widget.utilisateur.role,
    );

    Provider.of<UserProvider>(context, listen: false).setUtilisateur(updatedUser);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Modifications enregistrées')),
    );
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
                  enabled: false, // Optionnel : désactive modification de l'email
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'Téléphone'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => enregistrerModifications(context),
                  child: const Text('Enregistrer les modifications'),
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
