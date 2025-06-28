import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/bien.dart';

class ModifierAnnonce extends StatefulWidget {
  final Bien annonce;

  const ModifierAnnonce({super.key, required this.annonce});

  @override
  State<ModifierAnnonce> createState() => _ModifierAnnonceState();
}

class _ModifierAnnonceState extends State<ModifierAnnonce> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;
  late TextEditingController surfaceController;
  late TextEditingController typeController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.annonce.title);
    descriptionController = TextEditingController(text: widget.annonce.description);
    priceController = TextEditingController(text: widget.annonce.price.toString());
    surfaceController = TextEditingController(text: widget.annonce.surface.toString());
    typeController = TextEditingController(text: widget.annonce.type);
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    surfaceController.dispose();
    typeController.dispose();
    super.dispose();
  }

  Future<void> modifierAnnonce() async {
    if (!_formKey.currentState!.validate()) return;

    final url = Uri.parse("http://10.0.2.2:3000/api/properties/${widget.annonce.id}");
    final body = jsonEncode({
      'title': titleController.text.trim(),
      'description': descriptionController.text.trim(),
      'price': double.tryParse(priceController.text.trim()) ?? 0.0,
      'surface': double.tryParse(surfaceController.text.trim()) ?? 0.0,
      'type': typeController.text.trim(),
    });

    try {
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Annonce modifiée')),
        );
        Navigator.pop(context, true);
      } else {
        print("Erreur modification : ${response.statusCode}");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Échec de la modification")),
        );
      }
    } catch (e) {
      print("Erreur : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur réseau")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Modifier l'annonce")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Titre'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Champ requis' : null,
              ),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Champ requis' : null,
              ),
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Prix'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Champ requis';
                  if (double.tryParse(value) == null) return 'Nombre décimal requis';
                  return null;
                },
              ),
              TextFormField(
                controller: surfaceController,
                decoration: const InputDecoration(labelText: 'Surface'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Champ requis';
                  if (double.tryParse(value) == null) return 'Nombre décimal requis';
                  return null;
                },
              ),
              TextFormField(
                controller: typeController,
                decoration: const InputDecoration(labelText: 'Type'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Champ requis' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: modifierAnnonce,
                child: const Text("Enregistrer les modifications"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
