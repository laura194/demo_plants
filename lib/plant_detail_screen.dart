import 'dart:async';
import 'package:demo/models/plant_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PlantDetailScreen extends StatefulWidget {
  final Plant plant;
  final DatabaseReference dbRef;

  const PlantDetailScreen({super.key, required this.plant, required this.dbRef});

  @override
  State<PlantDetailScreen> createState() => _PlantDetailScreenState();
}

class _PlantDetailScreenState extends State<PlantDetailScreen> {
  bool isEditing = false;
  late TextEditingController _nameController;
  late TextEditingController _scienceNameController;
  late TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.plant.plantData!.name);
    _scienceNameController = TextEditingController(text: widget.plant.plantData!.science_name);
    _dateController = TextEditingController(text: widget.plant.plantData!.date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.plant.plantData!.name!),
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              if (isEditing) {
                saveChanges();
              }
              setState(() {
                isEditing = !isEditing;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              deletePlant();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isEditing ? buildEditView() : buildDetailView(),
      ),
    );
  }

  Widget buildEditView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        TextField(
          controller: _nameController,
          enabled: isEditing,
          decoration: const InputDecoration(
            labelText: "Name",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _scienceNameController,
          enabled: isEditing,
          decoration: const InputDecoration(
            labelText: "Scientific Name",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () => _selectDate(context),
          child: AbsorbPointer(
            child: TextField(
              controller: _dateController,
              enabled: isEditing,
              decoration: InputDecoration(
                labelText: "Date",
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        if (isEditing)
          ElevatedButton(
            onPressed: () {
              saveChanges();
            },
            child: const Text("Save Changes"),
          ),
      ],
    );
  }

  Widget buildDetailView() {
    // Formatieren des Datums für die Anzeige
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formattedDate = formatter.format(DateTime.parse(widget.plant.plantData!.date!));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          "Name: ${widget.plant.plantData!.name}",
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 20),
        Text(
          "Scientific Name: ${widget.plant.plantData!.science_name}",
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 20),
        Text(
          "Date: $formattedDate",
          style: const TextStyle(fontSize: 18),
        ),
      ],
    );
  }

  void saveChanges() {
    Map<String, dynamic> updatedData = {
      "name": _nameController.text,
      "science_name": _scienceNameController.text,
      "date": _dateController.text,
    };
    widget.dbRef.child("Plants").child(widget.plant.key!).update(updatedData).then((value) {
      Navigator.pop(context, true); // Return to HomeScreen with result
    });
  }

  void deletePlant() {
    widget.dbRef.child("Plants").child(widget.plant.key!).remove().then((value) {
      Navigator.pop(context, true); // Return to HomeScreen with result
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final String formattedDate = formatter.format(selectedDate);
      _dateController.text = formattedDate;
    }
  }
}