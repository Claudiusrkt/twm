import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationsPage extends StatefulWidget {
  final int userId;

  const NotificationsPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<dynamic> appointments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAppointments();
  }

  Future<void> fetchAppointments() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.176:3000/api/appointments/user/${widget.userId}'),
      );
      if (response.statusCode == 200) {
        setState(() {
          appointments = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          appointments = [];
          isLoading = false;
        });
      }
    } catch (e) {
      print("Erreur lors de la récupération : $e");
      setState(() {
        appointments = [];
        isLoading = false;
      });
    }
  }

  String traduireStatut(String status) {
    switch (status) {
      case 'confirmed':
        return 'confirmé';
      case 'canceled':
        return 'annulé';
      case 'pending':
      default:
        return 'en attente';
    }
  }

  Color couleurStatut(String status) {
    switch (status) {
      case 'confirmed':
        return Colors.green;
      case 'canceled':
        return Colors.red;
      case 'pending':
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mes rendez-vous")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : appointments.isEmpty
          ? const Center(child: Text("Aucun rendez-vous trouvé."))
          : ListView.builder(
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final appt = appointments[index];
          final property = appt['property'];
          final agent = appt['agent'];
          final status = appt['status'];

          final statusLabel = traduireStatut(status);
          final statusColor = couleurStatut(status);

          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text("${property['title']} - ${agent['fullName']}"),
              subtitle: Text(
                "Date : ${appt['date'].toString().substring(0, 10)}\n"
                    "Note : ${appt['note']}",
              ),
              trailing: Chip(
                label: Text(statusLabel),
                backgroundColor: statusColor.withOpacity(0.2),
                labelStyle: TextStyle(color: statusColor),
              ),
            ),
          );
        },
      ),
    );
  }
}
