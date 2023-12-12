import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:remake_simple_app/screens/nutritional_facts.dart';

class RecommendationsScreen extends StatefulWidget {
  const RecommendationsScreen({super.key, required String searchQuery});

  @override
  State<RecommendationsScreen> createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {
  final String apiKey = '92141f9056b8482da23148c47342f96a';
  late List<Map<String, dynamic>> recommendedSlider;
  late List<Map<String, dynamic>> recommendedRecipes;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    recommendedSlider = [];
    recommendedRecipes = [];
    _getRecommendedSlider();
    _getRecommendations('');
  }

  Future<void> _getRecommendations(String query) async {
    final response = await http.get(
      Uri.parse(
        'https://api.spoonacular.com/recipes/complexSearch?query=$query&apiKey=$apiKey',
      ),
    );

    if (response.statusCode == 200) {
      setState(() {
        recommendedRecipes = List<Map<String, dynamic>>.from(
          json.decode(response.body)['results'],
        );
      });
    } else {
      throw Exception('Failed to load recommendations');
    }
  }

  Future<void> _getRecommendedSlider() async {
    final response = await http.get(
      Uri.parse(
        'https://api.spoonacular.com/recipes/complexSearch?number=5&apiKey=$apiKey',
      ),
    );

    if (response.statusCode == 200) {
      setState(() {
        recommendedSlider = List<Map<String, dynamic>>.from(
          json.decode(response.body)['results'],
        );
      });
    } else {
      throw Exception('Failed to load recommended slider recipes');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Looking for a good Meal'),
        ),
        body: Column(
          children: [
            _buildSearchBar(),
            _buildRecipeList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Type your main ingredient here...',
                    border: InputBorder.none,
                  ),
                  onSubmitted: (value) {
                    _getRecommendations(value);
                  },
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                _getRecommendations(_searchController.text);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeList() {
    return Expanded(
      child: ListView.builder(
        itemCount: recommendedRecipes.length,
        itemBuilder: (context, index) {
          final recommendation = recommendedRecipes[index];
          return _recommendationTile(
            recommendation['title'].toString(),
            recommendation['image'].toString(),
            recommendation['id'],
          );
        },
      ),
    );
  }

  void _navigateToNutritionalFactsPage(String searchQuery, int recipeId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NutritionalFactsPage(
          searchQuery: searchQuery,
          recipeId: recipeId,
        ),
      ),
    );
  }

  Widget _recommendationTile(String title, String imageUrl, int recipeId) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(title),
        leading: imageUrl.isNotEmpty
            ? Image.network(
                imageUrl,
                width: 100,
                height: 50,
                fit: BoxFit.cover,
              )
            : Container(),
        onTap: () {
          _navigateToNutritionalFactsPage(title, recipeId);
        },
      ),
    );
  }
}

class RecipesDetailsPage extends StatelessWidget {
  const RecipesDetailsPage(
      {super.key, required this.searchQuery, required int recipeId});

  final String searchQuery;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(searchQuery),
      ),
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
