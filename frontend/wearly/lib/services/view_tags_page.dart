import 'package:flutter/material.dart';
import '../services/csv_storage_service.dart';

class ViewTagsPage extends StatelessWidget {
  final CSVStorageService csvService = CSVStorageService();

  ViewTagsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Saved Tags")),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: csvService.loadData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Error loading tag data"));
          }

          final data = snapshot.data ?? [];

          if (data.isEmpty) {
            return const Center(child: Text("No tags saved"));
          }

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(item['category'] ?? 'Unknown Category'),
                  subtitle: Text(
                    'Season: ${item['season'] ?? 'N/A'}\nTags: ${item['tags'] ?? ''}',
                  ),
                  isThreeLine: true,
                  trailing: item['is_favorite'] == 'true'
                      ? const Icon(Icons.star, color: Colors.orange)
                      : null,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
