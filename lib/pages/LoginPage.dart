import 'package:flutter/material.dart';
import 'package:twm/pagesClient/Inscription.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController motDePasseController = TextEditingController();

  String? typeConnexion = 'client';

  void seConnecter() async {
    if (_formKey.currentState!.validate()) {
      final email = emailController.text;
      final motDePasse = motDePasseController.text;

      final url = Uri.parse("http://127.0.0.1:3000/api/auth/login");
      final body = jsonEncode({
        "email": email,
        "password": motDePasse,
        "role": typeConnexion,
      });

      try {
        final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: body,
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final token = data['token'];
          final user = data['user'];

          print("Connexion réussie !");
          print("Token : $token");
          print("Utilisateur : $user");

          // Tu peux naviguer ici selon le rôle
          // Exemple :
          // if (typeConnexion == 'agent') {
          //   Navigator.push(... vers page agent ...)
          // } else {
          //   Navigator.push(... vers page client ...)
          // }

        } else {
          final erreur = jsonDecode(response.body)['message'];
          print("Erreur : $erreur");
          _afficherErreur(erreur);
        }
      } catch (e) {
        print("Erreur de connexion : $e");
        _afficherErreur("Impossible de se connecter au serveur.");
      }
    }
  }

  void _afficherErreur(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Erreur"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  void allerInscription() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Inscription()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text('Connexion')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: typeConnexion,
                decoration: const InputDecoration(
                  labelText: 'Se connecter en tant que',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'client', child: Text('Client')),
                  DropdownMenuItem(value: 'agent', child: Text('Agent')),
                ],
                onChanged: (value) {
                  setState(() {
                    typeConnexion = value;
                  });
                },
              ),
              const SizedBox(height: 24),

              // Champ email
              TextFormField(
                controller: emailController,
                decoration:
                const InputDecoration(labelText: 'Adresse email'),
                // keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Entrez votre email';
                  }
                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  if (!emailRegex.hasMatch(value)) {
                    return 'Email invalide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Champ mot de passe
              TextFormField(
                controller: motDePasseController,
                decoration: const InputDecoration(labelText: 'Mot de passe'),
                obscureText: true,
                validator: (value) =>
                value != null && value.length >= 6
                    ? null
                    : 'Mot de passe trop court',
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: seConnecter,
                child: const Text('Se connecter'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: allerInscription,
                child: const Text('Créer un compte'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
