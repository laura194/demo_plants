import 'dart:convert';
import 'package:demo/plant_wiki_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'models/plant_wiki_model.dart';

// PlantWikiScreen als StatefulWidget
class PlantWikiScreen extends StatefulWidget {
  @override
  _PlantWikiScreenState createState() => _PlantWikiScreenState();
}

// Der State für PlantWikiScreen
class _PlantWikiScreenState extends State<PlantWikiScreen> {
  int _currentPage = 1;
  late Future<List<PlantWikiModel>> _plants;

  @override
  void initState() {
    super.initState();
    _plants = fetchPlants(_currentPage);
  }

  Future<List<PlantWikiModel>> fetchPlants(int page) async {
    final url =
        'https://perenual.com/api/species-list?key=sk-ID7O66ce3a65b79276641&indoor=1&page=$page';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Fetched data for page $page: $data'); // Überprüfe die Struktur der Daten
        final List<dynamic> plantsJson = data['data'] ?? [];
        return plantsJson.map((json) => PlantWikiModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load plants, Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching plants for page $page: $e');
      throw Exception('Error fetching plants');
    }
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
      _plants = fetchPlants(_currentPage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plant Wiki - Page $_currentPage'),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: _currentPage > 1
                ? () => _onPageChanged(_currentPage - 1)
                : null,
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: _currentPage < 13
                ? () => _onPageChanged(_currentPage + 1)
                : null,
          ),
        ],
      ),
      body: FutureBuilder<List<PlantWikiModel>>(
        future: _plants,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No plants found.'));
          } else {
            final plants = snapshot.data!;
            return ListView.builder(
              itemCount: plants.length,
              itemBuilder: (context, index) {
                final plant = plants[index];
                return ListTile(
                  leading: Image.network(
                    plant.thumbnailUrl,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.local_florist, size: 50); // Dein Fallback-Icon
                    },
                  ),
                  title: Text(plant.commonName),
                  subtitle: Text(plant.scientificName.join(', ')),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlantWikiDetailScreen(plant: plant),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

