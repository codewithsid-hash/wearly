import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

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

class _DressDetailPageState extends State<DressDetailPage>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late int _currentIndex;
  
  // Animation Controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _floatingController;
  late AnimationController _scaleController;
  
  // Animations
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _scaleAnimation;
  
  bool _showFullImage = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    
    _floatingController = AnimationController(
      duration: Duration(milliseconds: 4000),
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut));
    
    _slideAnimation = Tween<Offset>(begin: Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));
    
    _rotateAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _floatingController, curve: Curves.linear));
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05)
        .animate(CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut));

    _fadeController.forward();
    _slideController.forward();
    _floatingController.repeat();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _floatingController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  Map<String, dynamic> get currentItem => widget.items[_currentIndex];

  Color _getTypeColor(String? type) {
    switch (type?.toLowerCase()) {
      case 'shirts': return Color(0xFF74b9ff);
      case 'pants': return Color(0xFF6c5ce7);
      case 'dresses': return Color(0xFFfd79a8);
      case 'shoes': return Color(0xFFfdcb6e);
      case 'accessories': return Color(0xFF00b894);
      default: return Color(0xFF636e72);
    }
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
          if (_showFullImage) _buildFullImageOverlay(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
            // backdrop: true,
          ),
          child: Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 18),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          '${_currentIndex + 1} of ${widget.items.length}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.favorite_border_rounded, color: Colors.white, size: 18),
          ),
          onPressed: () {
            HapticFeedback.lightImpact();
          },
        ),
        IconButton(
          icon: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.share_rounded, color: Colors.white, size: 18),
          ),
          onPressed: () {
            HapticFeedback.lightImpact();
          },
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
              transform: GradientRotation(_rotateAnimation.value * 0.02),
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
            _buildFloatingIcon('✨', 0.1, 0.15, 0.0),
            _buildFloatingIcon('🌟', 0.85, 0.12, 0.25),
            _buildFloatingIcon('💫', 0.15, 0.6, 0.5),
            _buildFloatingIcon('⭐', 0.9, 0.7, 0.75),
            _buildFloatingIcon('🎨', 0.05, 0.85, 0.3),
            _buildFloatingIcon('👗', 0.8, 0.4, 0.6),
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
          math.sin(_floatingController.value * 2 * math.pi + delay * 2 * math.pi) * 8,
        ),
        child: Opacity(
          opacity: 0.1,
          child: Text(icon, style: TextStyle(fontSize: 16)),
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
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.items.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
              HapticFeedback.selectionClick();
            },
            itemBuilder: (context, index) {
              return _buildItemDetail(widget.items[index], index);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildItemDetail(Map<String, dynamic> item, int index) {
    final filename = item['filename'];
    final name = item['name'] ?? 'Unnamed Item';
    final gender = item['gender'] ?? 'Unisex';
    final occasion = item['occasion'] ?? 'Any occasion';
    final season = item['season'] ?? 'All seasons';
    final clothingType = item['clothing_type'] ?? 'Clothing';
    
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          SizedBox(height: 20),
          _buildImageSection(filename, name, index),
          SizedBox(height: 30),
          _buildInfoSection(name, clothingType, gender, season, occasion),
          SizedBox(height: 30),
          _buildActionButtons(),
          SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildImageSection(String? filename, String name, int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      height: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: _getTypeColor(currentItem['clothing_type']).withOpacity(0.3),
            blurRadius: 30,
            offset: Offset(0, 15),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _showFullImage = true;
                });
                HapticFeedback.mediumImpact();
              },
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: Hero(
                  tag: 'item_${currentItem['id']}_$index',
                  child: Image.network(
                    'http://192.168.31.75:8045/wardrobe/$filename',
                    fit: BoxFit.cover,
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation(Colors.white),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Loading image...',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 16,
                                ),
                              ),
                            ],
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
                            Icon(Icons.broken_image_rounded, 
                                 color: Colors.white.withOpacity(0.7), size: 64),
                            SizedBox(height: 16),
                            Text(
                              'Image not available',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 20,
              right: 20,
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.zoom_in_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String name, String clothingType, String gender, 
                          String season, String occasion) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _getTypeColor(clothingType),
                      _getTypeColor(clothingType).withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  clothingType.toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          _buildInfoGrid(gender, season, occasion),
        ],
      ),
    );
  }

  Widget _buildInfoGrid(String gender, String season, String occasion) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildInfoCard('Gender', gender, Icons.person_rounded, Color(0xFF74b9ff))),
            SizedBox(width: 12),
            Expanded(child: _buildInfoCard('Season', season, Icons.wb_sunny_rounded, Color(0xFFfdcb6e))),
          ],
        ),
        SizedBox(height: 12),
        _buildInfoCard('Occasion', occasion, Icons.event_rounded, Color(0xFFfd79a8)),
      ],
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.2),
            color.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _buildActionButton(
              'Edit Details',
              Icons.edit_rounded,
              Color(0xFF6c5ce7),
              () {
                HapticFeedback.mediumImpact();
                // Add edit functionality
              },
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _buildActionButton(
              'Create Outfit',
              Icons.style_rounded,
              Color(0xFF00b894),
              () {
                HapticFeedback.mediumImpact();
                // Add outfit creation functionality
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String text, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withOpacity(0.8)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text(
                    text,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFullImageOverlay() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showFullImage = false;
        });
      },
      child: Container(
        color: Colors.black.withOpacity(0.9),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    'http://192.168.31.75:8045/wardrobe/${currentItem['filename']}',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => 
                        Icon(Icons.broken_image_rounded, color: Colors.white, size: 100),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Tap anywhere to close',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}