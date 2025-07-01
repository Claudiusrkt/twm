import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../providers/UserProvider.dart';
import '../model/utilisateur.dart';

class EnvoyerRdvPage extends StatefulWidget {
  final int propertyId;
  final int agentId;

  const EnvoyerRdvPage({super.key, required this.propertyId , required this.agentId, });

  @override
  State<EnvoyerRdvPage> createState() => _EnvoyerRdvPageState();
}

class _EnvoyerRdvPageState extends State<EnvoyerRdvPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _messageController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedDateFormatted;
  late Utilisateur utilisateur;
  bool _isLoading = false;
  int? agentId;

  @override
  void initState() {
    super.initState();

    final user = Provider.of<UserProvider>(context, listen: false).utilisateur;
    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Utilisateur non connecté")),
        );
        Navigator.pop(context);
      });
    } else {
      utilisateur = user;
      fetchPropertyAgentId(widget.propertyId);
    }
  }

  Future<void> fetchPropertyAgentId(int propertyId) async {
    try {
      final url = Uri.parse('http://192.168.1.176:3000/api/properties/$propertyId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final propertyData = jsonDecode(response.body);
        setState(() {
          agentId = propertyData['agentId'];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur de chargement du bien')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      print("Erreur fetchPropertyAgentId : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur de connexion au serveur')),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _envoyerRdv() async {
    if (_selectedDate == null || agentId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez choisir une date et attendre le chargement de l\'agent')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final url = Uri.parse('http://192.168.1.176:3000/api/appointments');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': utilisateur.id,
        'agentId': widget.agentId,
        'propertyId': widget.propertyId,
        'date': _selectedDate!.toIso8601String(),
        'note': _messageController.text,
      }),
    );

    setState(() => _isLoading = false);

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('RDV envoyé avec succès')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'envoi du RDV (${response.statusCode})')),
      );
    }
  }

  void _selectDate() async {
    DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _selectedDateFormatted =
        "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prendre un RDV')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text('Nom : ${utilisateur.fullName}',
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Text('Téléphone : ${utilisateur.phone}',
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 16),

              // Sélection date
              ListTile(
                title: Text(
                  _selectedDateFormatted ?? 'Choisir une date',
                  style: const TextStyle(fontSize: 16),
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: _selectDate,
              ),

              // Champ note
              TextFormField(
                controller: _messageController,
                decoration: const InputDecoration(labelText: 'Note (facultatif)'),
                maxLines: 3,
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _isLoading ? null : _envoyerRdv,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Envoyer RDV'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
