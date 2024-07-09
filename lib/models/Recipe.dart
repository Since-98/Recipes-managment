class Recipe {
  final int id;
  final int mealId;
  final String name;
  final String instructions;

  Recipe({
    required this.id,
    required this.mealId,
    required this.name,
    required this.instructions,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    print('FACTORY>>> $json');
    return Recipe(
      id: json['id'],
      mealId: json['meal_id'],
      name: json['name'],
      instructions: json['instructions'],
    );
  }
}
