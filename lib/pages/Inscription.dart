import 'package:flutter/material.dart';
import 'package:twm/widget/footer.dart';

class Inscription extends StatefulWidget {
  const Inscription({super.key});

  @override
  State<Inscription> createState() => _InscriptionState();
}

class _InscriptionState extends State<Inscription> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nomController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mdpController = TextEditingController();
  final TextEditingController confirmMdpController = TextEditingController();

  @override
  void dispose() {
    nomController.dispose();
    emailController.dispose();
    mdpController.dispose();
    confirmMdpController.dispose();
    super.dispose();
  }

  void _validerInscription() {
    if (formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inscription réussie !')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inscription'),
        backgroundColor: Colors.blue.shade300,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nomController,
                decoration: const InputDecoration(labelText: 'Nom'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Entrez votre nom' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Entrez votre email';
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Email invalide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: mdpController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Mot de passe'),
                validator: (value) =>
                value != null && value.length >= 6
                    ? null
                    : 'Minimum 6 caractères',
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: confirmMdpController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Confirmer mot de passe'),
                validator: (value) =>
                value == mdpController.text ? null : 'Les mots de passe ne correspondent pas',
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _validerInscription,
                child: const Text('Valider'),
              ),
            ],
          ),
        ),
      ),
        bottomNavigationBar: const MonFooter()
    );
  }
}
