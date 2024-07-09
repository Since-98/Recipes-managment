  import 'package:flutter/material.dart';
  import 'package:recipe_management/pages/recipe_index_page.dart';
  import 'home_page.dart';
  import 'meal_index_page.dart';

  class RecipesAppPage extends StatelessWidget {
    void Function(bool status) setAutenticatiestatus;
     RecipesAppPage({Key? key, required this. setAutenticatiestatus}) : super(key: key);

    @override
    Widget build(BuildContext context) {
      return  DefaultTabController(
          length: 3,
          child: Scaffold(
            bottomNavigationBar: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.home)),
                Tab(icon: Icon(Icons.menu_book)),
                Tab(icon: Icon(Icons.fastfood)),
              ],
            ),
            body: TabBarView(
              children: [
                HomePage(),
                RecipeIndexPage(setAutenticatiestatus:setAutenticatiestatus),
                MealIndexPage(setAutenticatiestatus:setAutenticatiestatus),
              ],
            ),
          ),

      );
    }
  }