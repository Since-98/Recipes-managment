import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecipesDrawer extends StatelessWidget {
  const RecipesDrawer({Key? key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _aboutDialog(context),
          ],
        ),
      ),
    );
  }

  Widget _aboutDialog(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.info_outline_rounded, color: Colors.red),
      title: Text('About'),
      onTap: () {
        Navigator.pop(context);
        showAboutDialog(
          context: context,
          applicationIcon: Icon(Icons.fastfood_outlined),
          applicationLegalese: '2024 F&R',
          applicationVersion: '1.00',
          applicationName: 'Recipes App',
        );
      },
    );
  }
}
