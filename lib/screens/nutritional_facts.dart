import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:remake_simple_app/screens/recipe.dart';

class NutritionalFactsPage extends StatefulWidget {
  const NutritionalFactsPage({
    super.key,
    required this.recipeId,
    required String searchQuery,
  });

  final int recipeId;

  @override
  State<NutritionalFactsPage> createState() => _NutritionalFactsPageState();
}

class _NutritionalFactsPageState extends State<NutritionalFactsPage> {
  late Map<String, dynamic> nutritionalInformation = {};

  @override
  void initState() {
    super.initState();
    fetchNutritionalInformation();
  }

  Future<void> fetchNutritionalInformation() async {
    const apiKey = '92141f9056b8482da23148c47342f96a';
    final recipeId = widget.recipeId;

    try {
      final response = await http.get(
        Uri.parse(
            'https://api.spoonacular.com/recipes/$recipeId/nutritionWidget.json?apiKey=$apiKey'),
      );

      if (response.statusCode == 200) {
        setState(() {
          nutritionalInformation = json.decode(response.body) ?? {};
        });
      } else {
        throw Exception('Failed to load nutritional information');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutritional Facts'),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Nutritional Information',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildNutrientSection(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16), // Adjust the spacing as needed
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCaloricBreakdownSection(),
                        _buildPropertySection(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildGoToRecipesButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientSection() {
    final List<Widget> nutrientWidgets = [];

    for (final nutrient
        in nutritionalInformation['nutrients']?.cast<Map<String, dynamic>>() ??
            []) {
      nutrientWidgets.add(
        Text(
          '${nutrient['name'] ?? 'Unknown'}: ${nutrient['amount'] ?? 'N/A'} ${nutrient['unit'] ?? 'N/A'} (${nutrient['percentOfDailyNeeds'] ?? 'N/A'}%)',
          style: const TextStyle(fontSize: 13),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nutrients:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        ...nutrientWidgets,
      ],
    );
  }

  Widget _buildPropertySection() {
    final List<Widget> propertyWidgets = [];

    for (final property
        in nutritionalInformation['properties']?.cast<Map<String, dynamic>>() ??
            []) {
      propertyWidgets.add(
        Text(
          '${property['name'] ?? 'Unknown'}: ${property['amount'] ?? 'N/A'} ${property['unit'] ?? 'N/A'}',
          style: const TextStyle(fontSize: 18),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        const Text(
          'Properties:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        ...propertyWidgets,
      ],
    );
  }

  Widget _buildCaloricBreakdownSection() {
    final caloricBreakdown = nutritionalInformation['caloricBreakdown'];

    if (caloricBreakdown != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const Text(
            'Caloric Breakdown:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ListTile(
            title: Text(
              'Protein: ${caloricBreakdown['percentProtein'] ?? 'N/A'}%',
              style: const TextStyle(fontSize: 18),
            ),
          ),
          ListTile(
            title: Text(
              'Fat: ${caloricBreakdown['percentFat'] ?? 'N/A'}%',
              style: const TextStyle(fontSize: 18),
            ),
          ),
          ListTile(
            title: Text(
              'Carbs: ${caloricBreakdown['percentCarbs'] ?? 'N/A'}%',
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildGoToRecipesButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetailsPage(
              recipeId: widget.recipeId,
            ),
          ),
        );
      },
      child: const Text('Go to Recipe Detail Page'),
    );
  }
}
