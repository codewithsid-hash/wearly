// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class SeasonScreen extends StatefulWidget {
//   @override
//   _SeasonScreenState createState() => _SeasonScreenState();
// }

// class _SeasonScreenState extends State<SeasonScreen> {
//   List<String> _seasons = [];
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchSeasons();
//   }

//   Future<void> fetchSeasons() async {
//     final response = await http.get(Uri.parse('http://192.168.10.171:8000/seasons/'));

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       setState(() {
//         _seasons = List<String>.from(data['seasons'].map((s) => s['name']));
//         _isLoading = false;
//       });
//     } else {
//       setState(() {
//         _isLoading = false;
//       });
//       throw Exception('Failed to load seasons');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Seasons")),
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator())
//           : _seasons.isEmpty
//               ? Center(child: Text("No seasons available."))
//               : ListView.builder(
//                   itemCount: _seasons.length,
//                   itemBuilder: (context, index) {
//                     return ListTile(
//                       title: Text(_seasons[index]),
//                       leading: Icon(Icons.wb_sunny),
//                     );
//                   },
//                 ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SeasonScreen extends StatefulWidget {
  @override
  _SeasonScreenState createState() => _SeasonScreenState();
}

class _SeasonScreenState extends State<SeasonScreen> {
  List<String> _seasons = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    fetchSeasons();
  }

  Future<void> fetchSeasons() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.get(Uri.parse('http://192.168.10.171:8000/seasons/'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _seasons = List<String>.from(data['seasons'].map((s) => s['name']));
          _isLoading = false;
        });
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Seasons")),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Error: $_errorMessage"),
                      SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: fetchSeasons,
                        child: Text("Retry"),
                      )
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: fetchSeasons,
                  child: _seasons.isEmpty
                      ? ListView(
                          children: [
                            SizedBox(height: 100),
                            Center(child: Text("No seasons available.")),
                          ],
                        )
                      : ListView.builder(
                          itemCount: _seasons.length,
                          itemBuilder: (context, index) {
                            return Card(
                              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                leading: Icon(Icons.wb_sunny, color: Colors.orange),
                                title: Text(
                                  _seasons[index],
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            );
                          },
                        ),
                ),
    );
  }
}

