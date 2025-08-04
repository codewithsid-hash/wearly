// 'http://192.168.10.171:8045/wardbrobe/'
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:wearly/detailpage.dart';
import 'dart:math' as math;

class MyCollectionsPage extends StatefulWidget {
  const MyCollectionsPage({Key? key}) : super(key: key);
  
  @override
  _MyCollectionsPageState createState() => _MyCollectionsPageState();
}

class _MyCollectionsPageState extends State<MyCollectionsPage>
    with TickerProviderStateMixin {
  // ...existing code...
    final String baseUrl = 'https://wearlyfinal-102927385476.asia-south1.run.app/wardrobe/';
// ...existing code...
  late Future<Map<String, List<Map<String, dynamic>>>> groupedItems;
  
  // Animation Controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _floatingController;
  
  // Animations
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _rotateAnimation;
  
  // Expansion state tracking
  Set<String> expandedCategories = {};
  
  // Category data with colors and icons
  final Map<String, Map<String, dynamic>> _categoryData = {
    't-shirts': {
      'icon': Icons.checkroom,
      'emoji': '👔',
      'colors': [Color(0xFF74b9ff), Color(0xFF0984e3)],
      'title': 'Shirts',
    },
    'pants': {
      'icon': Icons.checkroom_outlined,
      'emoji': '👖',
      'colors': [Color(0xFF6c5ce7), Color(0xFF74b9ff)],
      'title': 'Pants',
    },
    'dresses': {
      'icon': Icons.wc,
      'emoji': '👗',
      'colors': [Color(0xFFfd79a8), Color(0xFFe84393)],
      'title': 'Dresses',
    },
    'shoes': {
      'icon': Icons.sports_handball,
      'emoji': '👟',
      'colors': [Color(0xFFfdcb6e), Color(0xFFe17055)],
      'title': 'Shoes',
    },
    'accessories': {
      'icon': Icons.watch,
      'emoji': '⌚',
      'colors': [Color(0xFF00b894), Color(0xFF00cec9)],
      'title': 'Accessories',
    },
    'others': {
      'icon': Icons.category,
      'emoji': '📦',
      'colors': [Color(0xFF636e72), Color(0xFF2d3436)],
      'title': 'Others',
    },
  };

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    groupedItems = fetchAndGroupWardrobe();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _floatingController = AnimationController(
      duration: Duration(milliseconds: 4000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut));
    
    _slideAnimation = Tween<Offset>(begin: Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));
    
    _rotateAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _floatingController, curve: Curves.linear));

    _fadeController.forward();
    _slideController.forward();
    _floatingController.repeat();
  }

  Future<Map<String, List<Map<String, dynamic>>>> fetchAndGroupWardrobe() async {
    final response = await http.get(
      Uri.parse('https://wearlyfinal-102927385476.asia-south1.run.app/wardrobe/'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load wardrobe');
    }

    List<dynamic> wardrobe = jsonDecode(response.body);
    Map<String, List<Map<String, dynamic>>> grouped = {};

    for (var item in wardrobe) {
      final type = (item['clothing_type'] ?? 'others').toString().toLowerCase();
      grouped.putIfAbsent(type, () => []);
      item['image_url'] = 'https://wearlyfinal-102927385476.asia-south1.run.app/${item['filename']}';
      grouped[type]!.add(Map<String, dynamic>.from(item));
    }

    return grouped;
  }

  Map<String, dynamic> _getCategoryInfo(String category) {
    final key = category.toLowerCase();
    return _categoryData[key] ?? _categoryData['others']!;
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0a0a0a),
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          _buildBackgroundGradient(),
          _buildFloatingElements(),
          _buildMainContent(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'My Collections',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.search_rounded, color: Colors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.filter_list_rounded, color: Colors.white),
          onPressed: () {},
        ),
        SizedBox(width: 8),
      ],
    );
  }

  Widget _buildBackgroundGradient() {
    return AnimatedBuilder(
      animation: _rotateAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0a0a0a),
                Color(0xFF1a1a2e),
                Color(0xFF16213e),
                Color(0xFF0f0f23),
              ],
              stops: [0.0, 0.3, 0.7, 1.0],
              transform: GradientRotation(_rotateAnimation.value * 0.03),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFloatingElements() {
    return AnimatedBuilder(
      animation: _floatingController,
      builder: (context, child) {
        return Stack(
          children: [
            _buildFloatingIcon('👔', 0.1, 0.15, 0.0),
            _buildFloatingIcon('👖', 0.85, 0.12, 0.25),
            _buildFloatingIcon('👗', 0.15, 0.6, 0.5),
            _buildFloatingIcon('👟', 0.9, 0.7, 0.75),
            _buildFloatingIcon('⌚', 0.05, 0.85, 0.3),
            _buildFloatingIcon('📦', 0.8, 0.4, 0.6),
          ],
        );
      },
    );
  }

  Widget _buildFloatingIcon(String icon, double x, double y, double delay) {
    return Positioned(
      left: MediaQuery.of(context).size.width * x,
      top: MediaQuery.of(context).size.height * y,
      child: Transform.translate(
        offset: Offset(
          0,
          math.sin(_floatingController.value * 2 * math.pi + delay * 2 * math.pi) * 10,
        ),
        child: Opacity(
          opacity: 0.15,
          child: Text(icon, style: TextStyle(fontSize: 20)),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return SafeArea(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            children: [
              SizedBox(height: 20),
              _buildHeader(),
              SizedBox(height: 30),
              Expanded(
                child: _buildCollectionsList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Wardrobe',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Organize and explore your clothing collection',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollectionsList() {
    return FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
      future: groupedItems,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        }

        if (snapshot.hasError) {
          return _buildErrorState(snapshot.error.toString());
        }

        final data = snapshot.data!;
        if (data.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.builder(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20),
          itemCount: data.entries.length,
          itemBuilder: (context, index) {
            final entry = data.entries.elementAt(index);
            final clothingType = entry.key;
            final items = entry.value;
            final categoryInfo = _getCategoryInfo(clothingType);
            
            return AnimatedContainer(
              duration: Duration(milliseconds: 300),
              margin: EdgeInsets.only(bottom: 16),
              child: _buildCategoryCard(clothingType, items, categoryInfo),
            );
          },
        );
      },
    );
  }

  Widget _buildCategoryCard(String clothingType, List<Map<String, dynamic>> items, Map<String, dynamic> categoryInfo) {
    final isExpanded = expandedCategories.contains(clothingType);
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: categoryInfo['colors'][0].withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: ExpansionTile(
          tilePadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          childrenPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          collapsedBackgroundColor: Colors.transparent,
          onExpansionChanged: (expanded) {
            setState(() {
              if (expanded) {
                expandedCategories.add(clothingType);
              } else {
                expandedCategories.remove(clothingType);
              }
            });
            HapticFeedback.lightImpact();
          },
          leading: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: categoryInfo['colors']),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              categoryInfo['emoji'],
              style: TextStyle(fontSize: 20),
            ),
          ),
          title: Text(
            clothingType.toUpperCase(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          subtitle: Text(
            '${items.length} items',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 14,
            ),
          ),
          iconColor: Colors.white,
          collapsedIconColor: Colors.white,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: _buildItemGrid(items),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemGrid(List<Map<String, dynamic>> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildItemCard(item, items, index);
      },
    );
  }

  Widget _buildItemCard(Map<String, dynamic> item, List<Map<String, dynamic>> items, int index) {
    final filename = item['filename'];
    final name = item['name'];
    final gender = item['gender'];
    final occasion = item['occasion'];
    final season = item['season'];

    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DressDetailPage(
              items: items,
              initialIndex: index,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.08),
              Colors.white.withOpacity(0.03),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  child: Hero(
                    tag: 'item_${item['id']}_$index',
                    child: Image.network(
                      'https://wearlyfinal-102927385476.asia-south1.run.app/wardrobe/$filename',
                      fit: BoxFit.fill,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.grey.withOpacity(0.3),
                                Colors.grey.withOpacity(0.1),
                              ],
                            ),
                          ),
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) => Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.grey.withOpacity(0.3),
                              Colors.grey.withOpacity(0.1),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.broken_image, color: Colors.white, size: 32),
                              SizedBox(height: 4),
                              Text('Image not available', 
                                   style: TextStyle(color: Colors.white, fontSize: 10)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name ?? 'Unnamed',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        _buildInfoChip(gender ?? 'N/A', Icons.person, Colors.blue),
                        SizedBox(width: 4),
                        _buildInfoChip(_getSeasonEmoji(season), null, Colors.orange),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      occasion ?? 'Any occasion',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(String text, IconData? icon, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 10, color: color),
            SizedBox(width: 2),
          ],
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 9,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _getSeasonEmoji(String? season) {
    switch (season?.toLowerCase()) {
      case 'spring': return '🌸';
      case 'summer': return '☀️';
      case 'autumn': return '🍂';
      case 'winter': return '❄️';
      default: return '🌟';
    }
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.1),
                  Colors.white.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Color(0xFF667eea)),
              strokeWidth: 3,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Loading your collection...',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Container(
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(30),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.red.withOpacity(0.1),
              Colors.red.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.red.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 48),
            SizedBox(height: 16),
            Text(
              "Failed to load collection",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              error,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  groupedItems = fetchAndGroupWardrobe();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF667eea),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                "Try Again",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(30),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.1),
              Colors.white.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.checkroom_outlined, color: Colors.white.withOpacity(0.5), size: 64),
            SizedBox(height: 16),
            Text(
              "No items in your wardrobe",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Start adding items to see your collection here",
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}