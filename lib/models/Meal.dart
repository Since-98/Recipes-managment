class Meal {
  final int id;
  final String name;
  final String description;

  Meal({
    required this.id,
    required this.name,
    required this.description,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'],
      name: json['name'],
      description: json['description'],  // Fix the key here
    );
  }
}
