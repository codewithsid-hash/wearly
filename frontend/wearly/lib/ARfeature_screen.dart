import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;

class ARFeaturePage extends StatefulWidget {
  @override
  _ARFeaturePageState createState() => _ARFeaturePageState();
}

class _ARFeaturePageState extends State<ARFeaturePage>
    with TickerProviderStateMixin {
  final String url = 'https://huggingface.co/spaces/Kwai-Kolors/Kolors-Virtual-Try-On';

  // Animation Controllers
  late AnimationController _mainController;
  late AnimationController _floatingController;
  late AnimationController _glowController;
  
  // Animations
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _mainController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _floatingController = AnimationController(
      duration: Duration(milliseconds: 3000),
      vsync: this,
    );

    _glowController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _mainController, curve: Curves.easeInOut));

    _slideAnimation = Tween<Offset>(begin: Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _mainController, curve: Curves.easeOutCubic));

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
        CurvedAnimation(parent: _mainController, curve: Curves.elasticOut));

    _rotateAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _floatingController, curve: Curves.linear));

    _glowAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
        CurvedAnimation(parent: _glowController, curve: Curves.easeInOut));
  }

  void _startAnimations() {
    _mainController.forward();
    _floatingController.repeat();
    _glowController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _mainController.dispose();
    _floatingController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  Future<void> _launchURL() async {
    try {
      final String urlString = url;
      HapticFeedback.mediumImpact();
      
      // Try different launch modes to ensure compatibility
      bool launched = false;
      
      // First attempt: Use platformDefault mode
      try {
        launched = await launchUrl(
          Uri.parse(urlString),
          mode: LaunchMode.platformDefault,
        );
      } catch (e) {
        print('Platform default launch failed: $e');
      }
      
      // Second attempt: Use externalApplication mode
      if (!launched) {
        try {
          launched = await launchUrl(
            Uri.parse(urlString),
            mode: LaunchMode.externalApplication,
          );
        } catch (e) {
          print('External application launch failed: $e');
        }
      }
      
      // Third attempt: Use inAppWebView mode as fallback
      if (!launched) {
        try {
          launched = await launchUrl(
            Uri.parse(urlString),
            mode: LaunchMode.inAppWebView,
          );
        } catch (e) {
          print('In-app web view launch failed: $e');
        }
      }
      
      if (!launched) {
        _showErrorSnackBar('Could not launch AR Try-On feature. Please check your internet connection.');
      }
    } catch (e) {
      print('URL launch error: $e');
      _showErrorSnackBar('Could not launch AR Try-On feature. Error: ${e.toString()}');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[400],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
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
      title: ShaderMask(
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds);
        },
        child: Text(
          'AR Virtual Try-On',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle.light,
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
              transform: GradientRotation(_rotateAnimation.value * 0.1),
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
            _buildFloatingIcon('🥽', 0.1, 0.2, 0.0),
            _buildFloatingIcon('📱', 0.8, 0.15, 0.3),
            _buildFloatingIcon('👔', 0.2, 0.7, 0.6),
            _buildFloatingIcon('✨', 0.85, 0.8, 0.9),
            _buildFloatingIcon('🎯', 0.1, 0.5, 0.4),
            _buildFloatingIcon('🌟', 0.9, 0.4, 0.7),
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
            math.sin(_floatingController.value * 2 * math.pi +
                    delay * 2 * math.pi) *
                10),
        child: Opacity(
          opacity: 0.3,
          child: Text(
            icon,
            style: TextStyle(fontSize: 30),
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return SafeArea(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              _buildHeaderSection(),
              SizedBox(height: 30),
              _buildFeatureCards(),
              SizedBox(height: 30),
              _buildMainActionButton(),
              SizedBox(height: 20),
              _buildInfoSection(),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Experience the Future',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w800,
                height: 1.2,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Try on clothes virtually with AI-powered augmented reality',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF667eea).withOpacity(0.3),
                    Color(0xFF764ba2).withOpacity(0.3)
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Text(
                '🚀 Powered by Kolors AI',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCards() {
    final features = [
      {
        'icon': Icons.camera_alt_rounded,
        'title': 'Real-time Try-On',
        'description': 'See how clothes look on you instantly'
      },
      {
        'icon': Icons.auto_awesome_rounded,
        'title': 'AI-Powered',
        'description': 'Advanced machine learning technology'
      },
      {
        'icon': Icons.photo_library_rounded,
        'title': 'Upload & Try',
        'description': 'Use your photos or camera feed'
      },
      {
        'icon': Icons.share_rounded,
        'title': 'Share Results',
        'description': 'Save and share your virtual try-ons'
      },
    ];

    return FadeTransition(
      opacity: _fadeAnimation,
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.0,
        ),
        itemCount: features.length,
        itemBuilder: (context, index) {
          return ScaleTransition(
            scale: Tween<double>(begin: 0.8, end: 1.0).animate(
              CurvedAnimation(
                parent: _mainController,
                curve: Interval(0.2 * index, 0.8, curve: Curves.elasticOut),
              ),
            ),
            child: Container(
              padding: EdgeInsets.all(16),
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF667eea).withOpacity(0.3),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      features[index]['icon'] as IconData,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    features[index]['title'] as String,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 6),
                  Text(
                    features[index]['description'] as String,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 11,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMainActionButton() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          return Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF667eea).withOpacity(0.4 * _glowAnimation.value),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: _launchURL,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.launch_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Launch AR Try-On Experience',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoSection() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: EdgeInsets.all(20),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: Color(0xFF667eea),
                  size: 24,
                ),
                SizedBox(width: 12),
                Text(
                  'How it works',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildInfoStep('1', 'Upload a photo of yourself or use live camera'),
            SizedBox(height: 12),
            _buildInfoStep('2', 'Choose the garment you want to try on'),
            SizedBox(height: 12),
            _buildInfoStep('3', 'AI generates a realistic try-on result'),
            SizedBox(height: 12),
            _buildInfoStep('4', 'Save, share, or try different styles'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoStep(String number, String description) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            ),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            description,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
