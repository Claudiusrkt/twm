import 'package:flutter/material.dart';

class PublierAnnonce extends StatefulWidget {
  const PublierAnnonce({super.key});

  @override
  State<PublierAnnonce> createState() => _PublierAnnonceState();
}

class _PublierAnnonceState extends State<PublierAnnonce> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _adresseController = TextEditingController();
  final TextEditingController _longueurController = TextEditingController();
  final TextEditingController _largeurController = TextEditingController();
  final TextEditingController _vrLinkController = TextEditingController();

  String? _selectedType;

  final List<String> _types = ['Maison', 'Meublé'];

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
              // Adresse
              TextFormField(
                controller: _adresseController,
                decoration: const InputDecoration(
                  labelText: 'Adresse',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? 'Adresse requise' : null,
              ),
              const SizedBox(height: 16),

              // Dimensions
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
                      validator: (value) =>
                      value == null || value.isEmpty ? 'Longueur requise' : null,
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
                      validator: (value) =>
                      value == null || value.isEmpty ? 'Largeur requise' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Type (Dropdown)
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
                validator: (value) =>
                value == null ? 'Veuillez sélectionner un type' : null,
              ),
              const SizedBox(height: 16),

              // Lien VR
              TextFormField(
                controller: _vrLinkController,
                decoration: const InputDecoration(
                  labelText: 'Lien VR',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? 'Lien VR requis' : null,
              ),
              const SizedBox(height: 24),

              // Bouton de soumission
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Traitement ou envoi des données
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text("Annonce publiée"),
                        content: Text(
                          "Adresse: ${_adresseController.text}\n"
                              "Dimension: ${_longueurController.text}m x ${_largeurController.text}m\n"
                              "Type: $_selectedType\n"
                              "Lien VR: ${_vrLinkController.text}",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Fermer"),
                          ),
                        ],
                      ),
                    );
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
