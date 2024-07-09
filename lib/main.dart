import 'package:flutter/material.dart';
import 'package:recipe_management/pages/inloggen_page.dart';
import 'package:recipe_management/pages/recipes_app_page.dart';

void main() {
  runApp(const MainPage());
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool _geautenticeerd = false;  // Initialize to false to show login page first

  void _autenticatieStatus(bool status) {
    setState(() {
      _geautenticeerd = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipes App Page',
      debugShowCheckedModeBanner: false,  // Add this line to remove the debug banner
      home: _geautenticeerd
          ? RecipesAppPage(setAutenticatiestatus: _autenticatieStatus)
          : InloggenPage(setAutenticatiestatus: _autenticatieStatus),
    );
  }
}
