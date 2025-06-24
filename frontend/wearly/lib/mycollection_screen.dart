// 'http://192.168.31.75:8045/wardbrobe/'

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wearly/detailpage.dart';

class MyCollectionsPage extends StatefulWidget {
  const MyCollectionsPage({Key? key}) : super(key: key);

  @override
  _MyCollectionsPageState createState() => _MyCollectionsPageState();
}

class _MyCollectionsPageState extends State<MyCollectionsPage> {
  final String baseUrl = 'http://192.168.31.75:8045/wardbrobe/'; // Replace with your backend IP
  late Future<Map<String, List<Map<String, dynamic>>>> groupedItems;

  @override
  void initState() {
    super.initState();
    groupedItems = fetchAndGroupWardrobe();
  }

  Future<Map<String, List<Map<String, dynamic>>>> fetchAndGroupWardrobe() async {
    final response = await http.get(
  Uri.parse('http://192.168.31.75:8045/wardrobe/'),
);

    if (response.statusCode != 200) {
      throw Exception('Failed to load wardrobe');
    }

    List<dynamic> wardrobe = jsonDecode(response.body);
    Map<String, List<Map<String, dynamic>>> grouped = {};

    for (var item in wardrobe) {
      final type = item['clothing_type'] ?? 'Others';
      grouped.putIfAbsent(type, () => []);
      grouped[type]!.add(Map<String, dynamic>.from(item));
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Collections')),
      body: FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
        future: groupedItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());

          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));

          final data = snapshot.data!;
          return ListView(
            children: data.entries.map((entry) {
              final clothingType = entry.key;
              final items = entry.value;

              return ExpansionTile(
                title: Text(clothingType.toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                children: items.map((item) {
                  final filename = item['filename'];
                  final name = item['name'];
                  final gender = item['gender'];
                  final occasion = item['occasion'];
                  final season = item['season'];

                  return ListTile(
                  leading: Image.network(
                    'http://192.168.31.75:8045/wardrobe/$filename',
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return const SizedBox(
                        width: 60,
                        height: 60,
                        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                  ),
                  title: Text(name ?? 'Unnamed'),
                  subtitle: Text('Gender: $gender | Season: $season | Occasion: $occasion'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DressDetailPage(
                          items: items,
                          initialIndex: items.indexOf(item),
                        ),
                      ),
                    );
                  },
                  );

                }).toList(),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
