import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final apiKey = '92141f9056b8482da23148c47342f96a';
  final TextEditingController _ingredientController = TextEditingController();
  List<Map<String, dynamic>> _recipes = [];

  Future<void> _getRecipes() async {
    final ingredient = _ingredientController.text;
    final url = Uri.parse(
        'https://api.spoonacular.com/recipes/findByIngredients?ingredients=$ingredient&apiKey=$apiKey');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        _recipes = List<Map<String, dynamic>>.from(json.decode(response.body));
      });
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recetas con Spoonacular'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _ingredientController,
              decoration: const InputDecoration(
                hintText: 'Ingrediente',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _getRecipes,
              child: const Text('Buscar Recetas'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _recipes.length,
                itemBuilder: (context, index) {
                  final recipe = _recipes[index];
                  return ListTile(
                    title: Text(recipe['title']),
                    subtitle: Text(recipe['image']),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
