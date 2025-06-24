class Utilisateur {
  final String fullName;
  final String email;
  final String phone;
  final String role;

  Utilisateur({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
  });

  factory Utilisateur.fromJson(Map<String, dynamic> json) {
    return Utilisateur(
      fullName: json['fullName'],
      email: json['email'],
      phone: json['phone'],
      role: json['role'] ?? 'Client',
    );
  }
}
