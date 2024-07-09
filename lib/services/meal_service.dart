import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/meal.dart';
import 'authentication_services.dart';
import 'base_url.dart';

class MealService {
  final String urlMeals = '$baseUrl/meals';

  Future<List<Meal>> getAll({int? mealsId}) async {
    List<Meal> meals = [];

    final response = await http.get(Uri.parse(urlMeals),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${AuthenticationServices.getBearerToken()}',
      },);
    if (response.statusCode != 200) {
      throw Exception('Unexpected response code ${response.statusCode}');
    }
    // print('RECIPE: >>>${response.body}');

    final Map<String, dynamic> data = jsonDecode(response.body);

    for (int i = 0; i < data['data'].length; i++) {
      final meal = Meal(
        id: data['data'][i]['id'],
        name: data['data'][i]['name'],
        description: data['data'][i]['description'],
      );
      meals.add(meal);
    }

    return meals;
  }
}
