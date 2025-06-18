// tag_clothing_page.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/csv_storage_service.dart';


class TagClothingPage extends StatefulWidget {
  final Map<String, dynamic> detectionResult;

  const TagClothingPage({super.key, required this.detectionResult});

  @override
  State<TagClothingPage> createState() => _TagClothingPageState();
}

class _TagClothingPageState extends State<TagClothingPage> {
  final TextEditingController _seasonController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  bool _isFavorite = false;
  String? _category;

  final String tagApiUrl = 'http://192.168.10.171:8000/tag/'; // Change IP if needed

  Future<void> _submitTag() async {
  final itemData = {
    "item_id": widget.detectionResult["id"]?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
    "category": _category ?? widget.detectionResult["label"],
    "season": _seasonController.text,
    "is_favorite": _isFavorite.toString(),
    "tags": _tagsController.text.split(',').map((e) => e.trim()).toList(), // Store as pipe-separated
  };

  try {
    final response = await http.post(
      Uri.parse(tagApiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(itemData),
    );

    if (response.statusCode == 200) {
      // ✅ Save locally
      final csvService = CSVStorageService();
      List<Map<String, dynamic>> existing = await csvService.loadData();
      existing.add(itemData);
      await csvService.saveData(existing);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tag submitted and saved locally")),
      );
      Navigator.pop(context, true); // Go back to previous screen
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to submit tag")),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Error connecting to server")),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    final label = widget.detectionResult["label"];

    return Scaffold(
      appBar: AppBar(title: const Text("Tag Clothing")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Detected: $label", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Category'),
              items: const [
                DropdownMenuItem(value: "Shirt", child: Text("Shirt")),
                DropdownMenuItem(value: "Pant", child: Text("Pant")),
                DropdownMenuItem(value: "TShirt", child: Text("T-Shirt")),
              ],
              onChanged: (value) {
                setState(() {
                  _category = value;
                });
              },
            ),
            TextField(
              controller: _seasonController,
              decoration: const InputDecoration(labelText: 'Season (e.g. Summer)'),
            ),
            TextField(
              controller: _tagsController,
              decoration: const InputDecoration(labelText: 'Tags (comma separated)'),
            ),
            SwitchListTile(
              title: const Text("Mark as Favorite"),
              value: _isFavorite,
              onChanged: (val) {
                setState(() {
                  _isFavorite = val;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _submitTag,
              icon: const Icon(Icons.save),
              label: const Text("Save Tag"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            )
          ],
        ),
      ),
    );
  }
}
