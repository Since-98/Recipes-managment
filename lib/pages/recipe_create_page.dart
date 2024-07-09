import 'package:flutter/material.dart';
import 'package:recipe_management/models/meal.dart';
import 'package:recipe_management/services/recipe_service.dart';
class RecipeCreatePage extends StatefulWidget {
  final List<Meal> meals;
  final Meal selectedMeal;

  const RecipeCreatePage({
    Key? key,
    required this.meals,
    required this.selectedMeal,
  }) : super(key: key);

  @override
  State<RecipeCreatePage> createState() => _RecipeCreatePageState();
}

class _RecipeCreatePageState extends State<RecipeCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _instructionsController = TextEditingController();
  late Meal _selectedMeal;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedMeal = widget.selectedMeal;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  Future<void> _saveRecipe() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await RecipeService().post(
          mealId: _selectedMeal.id,
          name: _nameController.text,
          instructions: _instructionsController.text,
        );
        if (mounted){
          Navigator.pop(context, true); // Return true to indicate success
        }
      } catch (e) {
        // Handle error, show a dialog or a snackbar
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Failed to save the recipe. Please try again.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a Recipe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _mealSelection(),
                SizedBox(height: 20),
                _nameField(),
                SizedBox(height: 20),
                _instructionsField(),
                SizedBox(height: 20),
                _isLoading ? CircularProgressIndicator() : _actionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _mealSelection() {
    return DropdownButtonFormField<Meal>(
      value: _selectedMeal,
      items: widget.meals.map((meal) {
        return DropdownMenuItem<Meal>(
          value: meal,
          child: Text(meal.name),
        );
      }).toList(),
      onChanged: (meal) {
        setState(() {
          _selectedMeal = meal!;
        });
      },
      decoration: InputDecoration(
        labelText: 'Select Meal',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null) {
          return 'Please select a meal';
        }
        return null;
      },
    );
  }

  Widget _nameField() {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: 'Recipe Name',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.restaurant),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a recipe name';
        }
        return null;
      },
    );
  }

  Widget _instructionsField() {
    return TextFormField(
      controller: _instructionsController,
      decoration: InputDecoration(
        labelText: 'Instructions',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.description),
      ),
      maxLines: 5,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter instructions';
        }
        return null;
      },
    );
  }

  Widget _actionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _saveButton(),
        _cancelButton(),
      ],
    );
  }

  Widget _saveButton() {
    return ElevatedButton(
      onPressed: _saveRecipe,
      child: Text('Save'),
    );
  }

  Widget _cancelButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context, false); // Return false to indicate cancellation
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
      ),
      child: Text('Cancel'),
    );
  }
}
