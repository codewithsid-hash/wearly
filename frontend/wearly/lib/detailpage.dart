import 'package:flutter/material.dart';

class DressDetailPage extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final int initialIndex;

  const DressDetailPage({
    Key? key,
    required this.items,
    required this.initialIndex,
  }) : super(key: key);

  @override
  State<DressDetailPage> createState() => _DressDetailPageState();
}

class _DressDetailPageState extends State<DressDetailPage> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.items[_currentIndex]['name'] ?? 'Dress Detail'),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.items.length,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          final item = widget.items[index];
          final filename = item['filename'];
          final name = item['name'];
          final gender = item['gender'];
          final occasion = item['occasion'];
          final season = item['season'];
          final clothingType = item['clothing_type'];

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Image.network(
                    'http://192.168.31.75:8045/wardrobe/$filename',
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image, size: 100),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    name ?? 'Unnamed',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text("Type: $clothingType"),
                  Text("Gender: $gender"),
                  Text("Season: $season"),
                  Text("Occasion: $occasion"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
