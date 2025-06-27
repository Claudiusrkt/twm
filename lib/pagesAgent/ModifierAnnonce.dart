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

  Future<void> modifierAnnonce() async {
    final url = Uri.parse("http://127.0.0.1:3000/api/properties/${widget.annonce.id}");
    final body = jsonEncode({
      'title': titleController.text,
      'description': descriptionController.text,
      'price': int.parse(priceController.text),
      'surface': double.parse(surfaceController.text),
      'type': typeController.text,
    });

    try {
      final response = await http.put(url,
          headers: {"Content-Type": "application/json"}, body: body);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Annonce modifiée')));
        Navigator.pop(context, true); // renvoie un succès
      } else {
        print("Erreur modification : ${response.statusCode}");
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Échec de la modification")));
      }
    } catch (e) {
      print("Erreur : $e");
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erreur réseau")));
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
          child: Column(children: [
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Titre'),
            ),
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextFormField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Prix'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: surfaceController,
              decoration: const InputDecoration(labelText: 'Surface'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: typeController,
              decoration: const InputDecoration(labelText: 'Type'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: modifierAnnonce,
              child: const Text("Enregistrer les modifications"),
            ),
          ]),
        ),
      ),
    );
  }
}
