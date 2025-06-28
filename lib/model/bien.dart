class Bien {
  final int id;
  final String title;
  final String description;
  final double price;
  final double surface;
  final String type;
  final int agentId;

  Bien({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.surface,
    required this.type,
    required this.agentId,
  });

  factory Bien.fromJson(Map<String, dynamic> json) {
    return Bien(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      surface: (json['surface'] as num).toDouble(),
      type: json['type'],
      agentId: json['agentId'],
    );
  }
}
