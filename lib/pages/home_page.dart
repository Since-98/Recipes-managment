import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
              'lib/assets/images/Restaurant-Stock-Images-e1699951587809 (1).webp',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Text(
          'Recipe App',
          style: TextStyle(
            color: Colors.yellow,
            fontSize: 60,
            fontWeight: FontWeight.bold,

          ),
        ),
      ),
    );
  }
}
