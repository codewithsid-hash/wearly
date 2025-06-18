import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';

class CSVStorageService {
  static const String _fileName = 'clothing_tags.csv';

  Future<String> _getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$_fileName';
  }

  Future<void> saveData(List<Map<String, dynamic>> items) async {
    final filePath = await _getFilePath();

    final rows = <List<dynamic>>[];

    // Add headers
    rows.add(['item_id', 'category', 'season', 'is_favorite', 'tags']);

    // Add each item
    for (var item in items) {
      rows.add([
        item['item_id'],
        item['category'] ?? '',
        item['season'] ?? '',
        item['is_favorite'] ?? false,
        (item['tags'] as List?)?.join(',') ?? ''
      ]);
    }

    final csv = const ListToCsvConverter().convert(rows);
    final file = File(filePath);
    await file.writeAsString(csv);
  }

  Future<List<Map<String, dynamic>>> loadData() async {
    final filePath = await _getFilePath();
    final file = File(filePath);

    if (!await file.exists()) return [];

    final csvString = await file.readAsString();
    final rows = const CsvToListConverter().convert(csvString);

    if (rows.length <= 1) return []; // Only headers

    final data = <Map<String, dynamic>>[];

    for (var i = 1; i < rows.length; i++) {
      final row = rows[i];
      data.add({
        'item_id': row[0],
        'category': row[1],
        'season': row[2],
        'is_favorite': row[3] == true || row[3] == 'true',
        'tags': row[4].toString().split(',').where((t) => t.isNotEmpty).toList(),
      });
    }

    return data;
  }

  Future<void> deleteCSV() async {
    final filePath = await _getFilePath();
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
