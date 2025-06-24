import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twm/pagesAgent/AccueilAgent.dart';
import 'package:twm/pagesClient/Accueil.dart';
import 'package:twm/pagesClient/Inscription.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/utilisateur.dart';
import '../providers/UserProvider.dart';

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


      final baseUrl = "http://10.0.2.2:3000/api/auth/login";
      // final baseUrl = "http://10.192.23.164:3000/api/auth/login";

      final url = Uri.parse(baseUrl);
      try {
        final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "email": email,
            "password": motDePasse,
            "role": typeConnexion,
          })
        );
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);

          final String token = data['token'];

          final Map<String, dynamic> utilisateur = data['user'];

          final int id = utilisateur['id'];
          final String email = utilisateur['email'];
          final String role = utilisateur['role'];

          print("Token : $token");
          print("ID : $id");
          print("Email : $email");
          print("Role : $role");

          if (role.toLowerCase() == 'agent') {
            try{
              final urlGetUser=Uri.parse("http://10.0.2.2:3000/api/agents/$id");
              final rst = await http.get(
                  urlGetUser,
                  headers: {"Content-Type": "application/json"}
              );
              final user = jsonDecode(rst.body);
              user['role'] = 'agent';
              final utilisateur = Utilisateur.fromJson(user);
              final userProvider = Provider.of<UserProvider>(context, listen: false);
              userProvider.setUtilisateur(utilisateur);
              print(user);
              print("nety lelelenaaaaaaaaaaaaaaaaaaaaaaaaa");
            }catch(e){
              print("Tsy metyyyyyyyyyyyyy$e");
            }

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AccueilAgent()),
            );
          } else {
            try{
              final urlGetUser=Uri.parse("http://10.0.2.2:3000/api/users/$id");
              final rst = await http.get(
                  urlGetUser,
                  headers: {"Content-Type": "application/json"}
              );
              final user = jsonDecode(rst.body);
              user['role'] = 'client';
              final utilisateur = Utilisateur.fromJson(user);
              final userProvider = Provider.of<UserProvider>(context, listen: false);
              userProvider.setUtilisateur(utilisateur);
              print(user);
              print("nety lelelenaaaaaaaaaaaaaaaaaaaaaaaaa");
            }catch(e){
              print("lelenaaaaaaaaaaaaaa$e");
            }
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Accueil()),
            );
          }

        } else {
          final erreur = jsonDecode(response.body)['message'];
          print("Erreur : $erreur");
          _afficherMsg("Erreur",erreur);
        }
      } catch (e) {
        print("Erreur de connexion : $e");
        _afficherMsg("Erreur","Impossible de se connecter au serveur.");
      }
    }
  }

  void _afficherMsg(String title,String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
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
                keyboardType: TextInputType.emailAddress,
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
