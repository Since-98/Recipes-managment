import 'package:flutter/material.dart';
import 'package:recipe_management/services/meal_service.dart';
import '../components/recipes-drawer.dart';
import '../models/meal.dart';

class MealIndexPage extends StatefulWidget {
  final void Function(bool status) setAutenticatiestatus;
  const MealIndexPage({Key? key, required this.setAutenticatiestatus}) : super(key: key);

  @override
  State<MealIndexPage> createState() => _MealIndexPageState();
}

class _MealIndexPageState extends State<MealIndexPage> {
  late Future<List<Meal>> _meals;

  @override
  void initState() {
    _meals = MealService().getAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal - Index'),
        actions: [_uitloggen()],
      ),
      drawer: RecipesDrawer(),
      body: FutureBuilder<List<Meal>>(
        future: _meals,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: Colors.purple),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No meals found.'));
          }

          return _mealsIndex(snapshot.data!);
        },
      ),
    );
  }

  Widget _mealsIndex(List<Meal> data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        final meal = data[index];
        return ListTile(
          leading: Icon(Icons.food_bank),
          title: Text(meal.name),
          subtitle: Text(meal.description),
        );
      },
    );
  }

  Widget _uitloggen() {
    return IconButton(
        onPressed:(){
          widget.setAutenticatiestatus(false);

        },
        icon: Icon(Icons.logout));
  }
}
