import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PublierAnnonce extends StatefulWidget {
  const PublierAnnonce({super.key});

  @override
  State<PublierAnnonce> createState() => _PublierAnnonceState();
}

class _PublierAnnonceState extends State<PublierAnnonce> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _adresseController = TextEditingController();
  final TextEditingController _longueurController = TextEditingController();
  final TextEditingController _largeurController = TextEditingController();

  String? _selectedType;
  final List<String> _types = ['Villa', 'Maison', 'Meublé'];
  final int agentId = 3;

  Future<void> publierAnnonce() async {
    double? longueur = double.tryParse(_longueurController.text);
    double? largeur = double.tryParse(_largeurController.text);
    double? surface = (longueur != null && largeur != null) ? longueur * largeur : null;

    if (surface == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Dimensions invalides")),
      );
      return;
    }

    final url = Uri.parse("http://10.0.2.2:3000/api/properties");

    final body = jsonEncode({
      "title": _titleController.text.trim(),
      "description": _descriptionController.text.trim(),
      "price": double.tryParse(_priceController.text.trim()) ?? 0.0,
      "surface": surface,
      "type": _selectedType,
      "address": _adresseController.text.trim(),
      "agentId": agentId,
    });

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Annonce publiée avec succès")),
        );
        Navigator.pop(context, true); // ✅ renvoyer "true"
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur: ${response.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur réseau: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Publier une annonce'),
        backgroundColor: Colors.blue.shade300,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Titre',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Titre requis' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Description requise' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Prix',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Prix requis' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _adresseController,
                decoration: const InputDecoration(
                  labelText: 'Adresse',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Adresse requise' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _longueurController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Longueur (m)',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Longueur requise' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _largeurController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Largeur (m)',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Largeur requise' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: const InputDecoration(
                  labelText: 'Type de bien',
                  border: OutlineInputBorder(),
                ),
                items: _types.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedType = newValue;
                  });
                },
                validator: (value) => value == null ? 'Veuillez sélectionner un type' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    publierAnnonce();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Publier', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
