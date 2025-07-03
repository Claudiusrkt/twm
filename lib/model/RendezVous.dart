import 'bien.dart';

class RendezVous {
  final int id;
  final String status;
  final DateTime date;
  final String note;
  final Bien property;
  final String agentName;
  final String agentPhone;

  RendezVous({
    required this.id,
    required this.status,
    required this.date,
    required this.note,
    required this.property,
    required this.agentName,
    required this.agentPhone,
  });

  factory RendezVous.fromJson(Map<String, dynamic> json) {
    return RendezVous(
      id: json['id'],
      status: json['status'],
      date: DateTime.parse(json['date']),
      note: json['note'] ?? '',
      property: Bien.fromJson(json['property']),
      agentName: json['agent']['fullName'],
      agentPhone: json['agent']['phone'],
    );
  }
}
