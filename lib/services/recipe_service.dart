import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:recipe_management/services/authentication_services.dart';
import '../models/recipe.dart';
import 'base_url.dart';

class RecipeService {
  List<Recipe> _recipes = [];

  Future<List<Recipe>> getAll({int? mealId,}) async {
    List<Recipe> recipes = [];

    String url = mealId == null
        ? '$baseUrl/recipes'
        : '$baseUrl/meals/$mealId/recipes';

    final response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${AuthenticationServices.getBearerToken()}',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load recipes: ${response.statusCode}');
    }

    final Map<String, dynamic> data = jsonDecode(response.body);

    for (var recipeData in data['data']) {
      final recipe = Recipe.fromJson(recipeData);
      recipes.add(recipe);
    }

    _recipes = recipes;

    return recipes;
  }

  Future<Recipe> post({
    required int mealId,
    required String name,
    required String instructions,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/recipes/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${AuthenticationServices.getBearerToken()}',
      },
      body: jsonEncode({
        "meal_id": mealId,
        "name": name,
        "instructions": instructions,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Unexpected status code (${response.statusCode}) while adding a recipe');
    }

    final Map<String, dynamic> json = jsonDecode(response.body);

    final recipe = Recipe(
      id: json['data']['id'],
      mealId: json['data']['meal_id'],
      name: json['data']['name'],
      instructions: json['data']['instructions'],
    );

    _recipes.add(recipe);

    return recipe;
  }

  Future<bool> delete( int recipeId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/recipes/$recipeId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${AuthenticationServices.getBearerToken()}',
      },
    );
    return response.statusCode == 200;
  }

  List<Recipe> get recipes => _recipes;
}
