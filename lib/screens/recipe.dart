import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:remake_simple_app/screens/recommendations.dart';

class RecipeDetailsPage extends StatefulWidget {
  final int recipeId;

  const RecipeDetailsPage({
    super.key,
    required this.recipeId,
  });

  @override
  State<RecipeDetailsPage> createState() => _RecipeDetailsPageState();
}

class _RecipeDetailsPageState extends State<RecipeDetailsPage> {
  late List<Map<String, dynamic>> instructions;
  late List<Map<String, dynamic>> videos;

  @override
  void initState() {
    super.initState();
    instructions = [];
    videos = [];
    fetchRecipeInstructions();
    fetchRecipeVideos();
  }

  Future<void> fetchRecipeInstructions() async {
    const apiKey = '92141f9056b8482da23148c47342f96a';

    try {
      final response = await http.get(
        Uri.parse(
          'https://api.spoonacular.com/recipes/${widget.recipeId}/analyzedInstructions?apiKey=$apiKey',
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          instructions = data
              .map<Map<String, dynamic>>((item) => {
                    'name': item['name'],
                    'steps': item['steps'],
                    'time': item['time'],
                  })
              .toList();
        });
      } else {
        throw Exception('Failed to load recipe instructions');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> fetchRecipeVideos() async {
    const apiKey = '92141f9056b8482da23148c47342f96a';

    try {
      final response = await http.get(
        Uri.parse(
          'https://api.spoonacular.com/food/videos/search?apiKey=$apiKey&query=${widget.recipeId}',
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          videos = data
              .map<Map<String, dynamic>>((item) => {
                    'title': item['title'],
                    'url': item['url'],
                  })
              .toList();
        });
      } else {
        throw Exception('Failed to load recipe videos');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Step by Step'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Instructions:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: instructions.length,
                itemBuilder: (context, index) {
                  final Map<String, dynamic> section = instructions[index];
                  final String sectionName = section['name'] ?? '';
                  final List<dynamic> steps = section['steps'] ?? [];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        sectionName.isNotEmpty ? '$sectionName:' : '',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ...steps.asMap().entries.map<Widget>((entry) {
                        final int stepNumber = entry.key + 1;
                        final Map<String, dynamic> step = entry.value;
                        final String stepText = step['step'] ?? '';

                        return ListTile(
                          title: Text(
                            'Step $stepNumber',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            stepText,
                            style: const TextStyle(fontSize: 16),
                          ),
                        );
                      })
                    ],
                  );
                },
              ),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '"Bon appétit!"',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const RecommendationsScreen(searchQuery: ''),
                  ),
                );
              },
              child: const Text('Back to Recommendations'),
            ),
          ],
        ),
      ),
    );
  }
}
