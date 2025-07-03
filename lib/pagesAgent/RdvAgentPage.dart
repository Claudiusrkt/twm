import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RdvAgentPage extends StatefulWidget {
  final int agentId;

  const RdvAgentPage({Key? key, required this.agentId}) : super(key: key);

  @override
  State<RdvAgentPage> createState() => _RdvAgentPageState();
}

class _RdvAgentPageState extends State<RdvAgentPage> {
  List<dynamic> rdvs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRdvs();
  }

  Future<void> fetchRdvs() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.176:3000/api/appointments/agent/${widget.agentId}'),
      );

      if (response.statusCode == 200) {
        setState(() {
          rdvs = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          rdvs = [];
          isLoading = false;
        });
      }
    } catch (e) {
      print("Erreur lors de la récupération : $e");
      setState(() {
        rdvs = [];
        isLoading = false;
      });
    }
  }

  Future<void> updateStatus(int rdvId, String newStatus) async {
    try {
      final response = await http.put(
        Uri.parse('http://192.168.1.176:3000/api/appointments/$rdvId/status'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'status': newStatus}),
      );

      if (response.statusCode == 200) {
        fetchRdvs(); // refresh après mise à jour
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Statut mis à jour : ${traduireStatut(newStatus)}')),
        );
      } else {
        print("Erreur mise à jour statut: ${response.body}");
      }
    } catch (e) {
      print("Erreur mise à jour statut: $e");
    }
  }

  String traduireStatut(String status) {
    switch (status) {
      case 'confirmed':
        return 'Confirmé';
      case 'canceled':
        return 'Annulé';
      default:
        return 'En attente';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Demandes de rendez-vous")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : rdvs.isEmpty
          ? const Center(child: Text("Aucun rendez-vous"))
          : ListView.builder(
        itemCount: rdvs.length,
        itemBuilder: (context, index) {
          final rdv = rdvs[index];
          final property = rdv['property'];
          final user = rdv['user'];
          final status = rdv['status'];

          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text("${property['title']} - ${user['fullName']}"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Date : ${rdv['date'].toString().substring(0, 10)}"),
                  Text("Note : ${rdv['note']}"),
                  Text("Téléphone : ${user['phone']}"),
                  Text("Statut : ${traduireStatut(status)}"),
                ],
              ),
              trailing: status == 'pending'
                  ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.check, color: Colors.green),
                    tooltip: 'Confirmer',
                    onPressed: () => updateStatus(rdv['id'], 'confirmed'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    tooltip: 'Annuler',
                    onPressed: () => updateStatus(rdv['id'], 'canceled'),
                  ),
                ],
              )
                  : null,
            ),
          );
        },
      ),
    );
  }
}
