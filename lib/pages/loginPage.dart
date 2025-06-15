import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nomController = TextEditingController();
  final TextEditingController motDePasseController = TextEditingController();

  void seConnecter() {
    if (_formKey.currentState!.validate()) {
      final nom = nomController.text;
      final motDePasse = motDePasseController.text;

      print('Connexion avec: $nom / $motDePasse');
    }
  }

  void allerVersInscription() {
    print('Redirection vers la page de création de compte...');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connexion')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: nomController,
                decoration: const InputDecoration(labelText: 'Nom d\'utilisateur'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Entrez votre nom' : null,
              ),
              const SizedBox(height: 16),
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
                onPressed: allerVersInscription,
                child: const Text('Créer un compte'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
