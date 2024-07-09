import 'package:flutter/material.dart';
import 'package:recipe_management/pages/recipe_create_page.dart';
import 'package:recipe_management/services/meal_service.dart';
import 'package:recipe_management/services/recipe_service.dart';
import '../components/recipes-drawer.dart';
import '../models/meal.dart';
import '../models/recipe.dart';

class RecipeIndexPage extends StatefulWidget {
  final void Function(bool status) setAutenticatiestatus;
  const RecipeIndexPage({Key? key, required this.setAutenticatiestatus}) : super(key: key);

  @override
  State<RecipeIndexPage> createState() => _RecipeIndexPageState();
}

class _RecipeIndexPageState extends State<RecipeIndexPage> {
  late Future<List<Recipe>> _recipes;
  Meal? _selectedMeal;
  List<Meal> _meals = [];

  @override
  void initState() {
    _recipes = RecipeService().getAll(mealId : _selectedMeal?.id);

    MealService().getAll().then(
        (value){
          for (int i = 0; i < value.length; i++){
            _meals.add(value[i]);
          }
          _selectedMeal = _meals.isEmpty ? null : _meals.first;
          _recipes =
              RecipeService().getAll(mealId: _selectedMeal?.id);
          setState(() {

          });
        },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe - Index'),
        actions: [_uitloggen()],
      ),
      drawer: RecipesDrawer(),
      floatingActionButton: _createRecipe(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _mealSelection(),
          SizedBox(height: 20),
          Expanded(child: _recipesIndex()),
        ],
      ),
    );
  }

  Widget _mealSelection() {
    return DropdownButton<Meal>(
      value: _selectedMeal,
      items: _meals.map((meal) {
        return DropdownMenuItem<Meal>(
          child: Text(meal.name),
          value: meal,
        );
      }).toList(),
      onChanged: (Meal? meal) {
        _selectedMeal = meal;
        _recipes =
            RecipeService().getAll(mealId: _selectedMeal?.id);
        setState(() {

        });
      },
    );
  }

  Widget _recipesIndex() {
    return FutureBuilder(
      future: _recipes,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: Colors.purple));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No recipes found.'));
        }


        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(Icons.receipt),
              title: Text(snapshot.data![index].name),
              subtitle: Text(snapshot.data![index].instructions),
              trailing: _deleteRecipe(snapshot.data![index].id, context),
            );
            }
            );
          },
        );
  }

  Widget _uitloggen() {
    return IconButton(
      onPressed: () {
        widget.setAutenticatiestatus(false);
      },
      icon: Icon(Icons.logout),
    );
  }

  Widget _createRecipe() {
    return FloatingActionButton(
      child: Icon(Icons.add, color: Colors.purple),
      onPressed: () async {
        bool? result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeCreatePage(
              meals: _meals,
              selectedMeal: _selectedMeal!,
            ),
          ),
        );
        if (result == true) {
          setState(() {
            _recipes = RecipeService().getAll(mealId: _selectedMeal?.id);
          });
        }
      },
    );
  }

  Widget _deleteRecipe(int id, BuildContext context) {
    return GestureDetector(
      onTap: () async {
        bool gelukt = await RecipeService().delete(id);
        if (gelukt) {
          _recipes =
              RecipeService().getAll(mealId: _selectedMeal?.id);
          setState(() {
          });
        } else {
          if (context.mounted) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Character - Delete'),
                  content: const Text('Verwijderen is mislukt'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Ok'))
                  ],
                );
              },
            );
          }
        }
      },
      child: const Icon(Icons.delete_outline),
    );
  }

}

