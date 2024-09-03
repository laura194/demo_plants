import 'package:flutter/material.dart';
import 'models/plant_wiki_model.dart';

class PlantWikiDetailScreen extends StatelessWidget {
  final PlantWikiModel plant;

  PlantWikiDetailScreen({required this.plant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(plant.commonName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Hauptbild der Pflanze
            Image.network(
              plant.originalImageUrl,
              fit: BoxFit.cover,
              height: 250,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.local_florist, size: 250);
              },
            ),
            SizedBox(height: 16),
            Text(
              'Common Name: ${plant.commonName}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 8),
            Text(
              'Scientific Name: ${plant.scientificName.join(', ')}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 8),
            Text(
              'Cycle: ${plant.cycle}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 8),
            Text(
              'Watering: ${plant.watering}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 8),
            Text(
              'Sunlight: ${plant.sunlight.join(', ')}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
