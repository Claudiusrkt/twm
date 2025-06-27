class Bien {
  final int id;
  final String title;
  final String description;
  final double price;
  final double surface;
  final String type;

  Bien({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.surface,
    required this.type,
  });

  factory Bien.fromJson(Map<String, dynamic> json) {
    return Bien(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'].toDouble(),
      surface: json['surface'].toDouble(),
      type: json['type'],
    );
  }
}
