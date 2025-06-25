//////////////////////////// IF we are using direct URL launching /////////////////////////////
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'dart:math' as math;

// class ARFeaturePage extends StatefulWidget {
//   @override
//   _ARFeaturePageState createState() => _ARFeaturePageState();
// }

// class _ARFeaturePageState extends State<ARFeaturePage>
//     with TickerProviderStateMixin {
//   final String url = 'https://huggingface.co/spaces/Kwai-Kolors/Kolors-Virtual-Try-On';
  
//   // Animation Controllers
//   late AnimationController _mainController;
//   late AnimationController _floatingController;
//   late AnimationController _glowController;
  
//   // Animations
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _rotateAnimation;
//   late Animation<double> _glowAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _initializeAnimations();
//     _startAnimations();
//   }

//   void _initializeAnimations() {
//     _mainController = AnimationController(
//       duration: Duration(milliseconds: 1500),
//       vsync: this,
//     );

//     _floatingController = AnimationController(
//       duration: Duration(milliseconds: 3000),
//       vsync: this,
//     );

//     _glowController = AnimationController(
//       duration: Duration(milliseconds: 2000),
//       vsync: this,
//     );

//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//         CurvedAnimation(parent: _mainController, curve: Curves.easeInOut));

//     _slideAnimation = Tween<Offset>(begin: Offset(0, 0.3), end: Offset.zero)
//         .animate(CurvedAnimation(
//             parent: _mainController, curve: Curves.easeOutCubic));

//     _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
//         CurvedAnimation(parent: _mainController, curve: Curves.elasticOut));

//     _rotateAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//         CurvedAnimation(parent: _floatingController, curve: Curves.linear));

//     _glowAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
//         CurvedAnimation(parent: _glowController, curve: Curves.easeInOut));
//   }

//   void _startAnimations() {
//     _mainController.forward();
//     _floatingController.repeat();
//     _glowController.repeat(reverse: true);
//   }

//   @override
//   void dispose() {
//     _mainController.dispose();
//     _floatingController.dispose();
//     _glowController.dispose();
//     super.dispose();
//   }

//   Future<void> _launchURL() async {
//     final Uri uri = Uri.parse(url);
//     HapticFeedback.mediumImpact();
    
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     } else {
//       _showErrorSnackBar('Could not launch AR Try-On feature');
//     }
//   }

//   void _showErrorSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.red[400],
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF0a0a0a),
//       extendBodyBehindAppBar: true,
//       appBar: _buildAppBar(),
//       body: Stack(
//         children: [
//           _buildBackgroundGradient(),
//           _buildFloatingElements(),
//           _buildMainContent(),
//         ],
//       ),
//     );
//   }

//   PreferredSizeWidget _buildAppBar() {
//     return AppBar(
//       elevation: 0,
//       backgroundColor: Colors.transparent,
//       leading: IconButton(
//         icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
//         onPressed: () => Navigator.pop(context),
//       ),
//       title: ShaderMask(
//         shaderCallback: (Rect bounds) {
//           return LinearGradient(
//             colors: [Color(0xFF667eea), Color(0xFF764ba2)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ).createShader(bounds);
//         },
//         child: Text(
//           'AR Virtual Try-On',
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.w700,
//             color: Colors.white,
//           ),
//         ),
//       ),
//       centerTitle: true,
//       systemOverlayStyle: SystemUiOverlayStyle.light,
//     );
//   }

//   Widget _buildBackgroundGradient() {
//     return AnimatedBuilder(
//       animation: _rotateAnimation,
//       builder: (context, child) {
//         return Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [
//                 Color(0xFF0a0a0a),
//                 Color(0xFF1a1a2e),
//                 Color(0xFF16213e),
//                 Color(0xFF0f0f23),
//               ],
//               stops: [0.0, 0.3, 0.7, 1.0],
//               transform: GradientRotation(_rotateAnimation.value * 0.1),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildFloatingElements() {
//     return AnimatedBuilder(
//       animation: _floatingController,
//       builder: (context, child) {
//         return Stack(
//           children: [
//             _buildFloatingIcon('🥽', 0.1, 0.2, 0.0),
//             _buildFloatingIcon('📱', 0.8, 0.15, 0.3),
//             _buildFloatingIcon('👔', 0.2, 0.7, 0.6),
//             _buildFloatingIcon('✨', 0.85, 0.8, 0.9),
//             _buildFloatingIcon('🎯', 0.1, 0.5, 0.4),
//             _buildFloatingIcon('🌟', 0.9, 0.4, 0.7),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildFloatingIcon(String icon, double x, double y, double delay) {
//     return Positioned(
//       left: MediaQuery.of(context).size.width * x,
//       top: MediaQuery.of(context).size.height * y,
//       child: Transform.translate(
//         offset: Offset(
//             0,
//             math.sin(_floatingController.value * 2 * math.pi +
//                     delay * 2 * math.pi) *
//                 10),
//         child: Opacity(
//           opacity: 0.3,
//           child: Text(
//             icon,
//             style: TextStyle(fontSize: 30),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildMainContent() {
//     return SafeArea(
//       child: SingleChildScrollView(
//         physics: BouncingScrollPhysics(),
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: 20),
//               _buildHeaderSection(),
//               SizedBox(height: 30),
//               _buildFeatureCards(),
//               SizedBox(height: 30),
//               _buildMainActionButton(),
//               SizedBox(height: 20),
//               _buildInfoSection(),
//               SizedBox(height: 30),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHeaderSection() {
//     return FadeTransition(
//       opacity: _fadeAnimation,
//       child: SlideTransition(
//         position: _slideAnimation,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Experience the Future',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 32,
//                 fontWeight: FontWeight.w800,
//                 height: 1.2,
//               ),
//             ),
//             SizedBox(height: 8),
//             Text(
//               'Try on clothes virtually with AI-powered augmented reality',
//               style: TextStyle(
//                 color: Colors.white.withOpacity(0.8),
//                 fontSize: 16,
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//             SizedBox(height: 16),
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     Color(0xFF667eea).withOpacity(0.3),
//                     Color(0xFF764ba2).withOpacity(0.3)
//                   ],
//                 ),
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(color: Colors.white.withOpacity(0.1)),
//               ),
//               child: Text(
//                 '🚀 Powered by Kolors AI',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildFeatureCards() {
//     final features = [
//       {
//         'icon': Icons.camera_alt_rounded,
//         'title': 'Real-time Try-On',
//         'description': 'See how clothes look on you instantly'
//       },
//       {
//         'icon': Icons.auto_awesome_rounded,
//         'title': 'AI-Powered',
//         'description': 'Advanced machine learning technology'
//       },
//       {
//         'icon': Icons.photo_library_rounded,
//         'title': 'Upload & Try',
//         'description': 'Use your photos or camera feed'
//       },
//       {
//         'icon': Icons.share_rounded,
//         'title': 'Share Results',
//         'description': 'Save and share your virtual try-ons'
//       },
//     ];

//     return FadeTransition(
//       opacity: _fadeAnimation,
//       child: GridView.builder(
//         shrinkWrap: true,
//         physics: NeverScrollableScrollPhysics(),
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           crossAxisSpacing: 12,
//           mainAxisSpacing: 12,
//           childAspectRatio: 1.0,
//         ),
//         itemCount: features.length,
//         itemBuilder: (context, index) {
//           return ScaleTransition(
//             scale: Tween<double>(begin: 0.8, end: 1.0).animate(
//               CurvedAnimation(
//                 parent: _mainController,
//                 curve: Interval(0.2 * index, 0.8, curve: Curves.elasticOut),
//               ),
//             ),
//             child: Container(
//               padding: EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     Colors.white.withOpacity(0.1),
//                     Colors.white.withOpacity(0.05),
//                   ],
//                 ),
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(color: Colors.white.withOpacity(0.1)),
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                     padding: EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [Color(0xFF667eea), Color(0xFF764ba2)],
//                       ),
//                       borderRadius: BorderRadius.circular(16),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Color(0xFF667eea).withOpacity(0.3),
//                           blurRadius: 10,
//                           offset: Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: Icon(
//                       features[index]['icon'] as IconData,
//                       color: Colors.white,
//                       size: 24,
//                     ),
//                   ),
//                   SizedBox(height: 12),
//                   Text(
//                     features[index]['title'] as String,
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(height: 6),
//                   Text(
//                     features[index]['description'] as String,
//                     style: TextStyle(
//                       color: Colors.white.withOpacity(0.6),
//                       fontSize: 11,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildMainActionButton() {
//     return ScaleTransition(
//       scale: _scaleAnimation,
//       child: AnimatedBuilder(
//         animation: _glowAnimation,
//         builder: (context, child) {
//           return Container(
//             width: double.infinity,
//             height: 60,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Color(0xFF667eea).withOpacity(0.4 * _glowAnimation.value),
//                   blurRadius: 20,
//                   offset: Offset(0, 10),
//                 ),
//               ],
//             ),
//             child: ElevatedButton(
//               onPressed: _launchURL,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.transparent,
//                 elevation: 0,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//               ),
//               child: Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Color(0xFF667eea), Color(0xFF764ba2)],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       Icons.launch_rounded,
//                       color: Colors.white,
//                       size: 24,
//                     ),
//                     SizedBox(width: 12),
//                     Text(
//                       'Launch AR Try-On Experience',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildInfoSection() {
//     return FadeTransition(
//       opacity: _fadeAnimation,
//       child: Container(
//         padding: EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Colors.white.withOpacity(0.1),
//               Colors.white.withOpacity(0.05),
//             ],
//           ),
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(color: Colors.white.withOpacity(0.1)),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(
//                   Icons.info_outline_rounded,
//                   color: Color(0xFF667eea),
//                   size: 24,
//                 ),
//                 SizedBox(width: 12),
//                 Text(
//                   'How it works',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 16),
//             _buildInfoStep('1', 'Upload a photo of yourself or use live camera'),
//             SizedBox(height: 12),
//             _buildInfoStep('2', 'Choose the garment you want to try on'),
//             SizedBox(height: 12),
//             _buildInfoStep('3', 'AI generates a realistic try-on result'),
//             SizedBox(height: 12),
//             _buildInfoStep('4', 'Save, share, or try different styles'),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoStep(String number, String description) {
//     return Row(
//       children: [
//         Container(
//           width: 24,
//           height: 24,
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Color(0xFF667eea), Color(0xFF764ba2)],
//             ),
//             shape: BoxShape.circle,
//           ),
//           child: Center(
//             child: Text(
//               number,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ),
//         SizedBox(width: 12),
//         Expanded(
//           child: Text(
//             description,
//             style: TextStyle(
//               color: Colors.white.withOpacity(0.8),
//               fontSize: 14,
//               fontWeight: FontWeight.w400,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
//////////////////////////// IF we are using direct URL launching /////////////////////////////

//////////////////////////// If we are using a separate AR feature page with image upload functionality /////////////////////////////
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:math' as math;
import 'package:image_picker/image_picker.dart';

class VirtualTryOnScreen extends StatefulWidget {
  @override
  _VirtualTryOnScreenState createState() => _VirtualTryOnScreenState();
}

class _VirtualTryOnScreenState extends State<VirtualTryOnScreen>
    with TickerProviderStateMixin {
  File? personImage;
  File? garmentImage;
  File? resultImage;
  bool isProcessing = false;
  double progress = 0.0;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _floatingController;
  late AnimationController _pulseController;
  late AnimationController _rotateController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotateAnimation;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _floatingController = AnimationController(
      duration: Duration(milliseconds: 3000),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    _rotateController = AnimationController(
      duration: Duration(milliseconds: 3000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
        CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

    _rotateAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _rotateController, curve: Curves.linear));

    _fadeController.forward();
    _slideController.forward();
    _floatingController.repeat();
    _pulseController.repeat(reverse: true);
    _rotateController.repeat();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _floatingController.dispose();
    _pulseController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source, bool isPerson) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          if (isPerson) {
            personImage = File(image.path);
          } else {
            garmentImage = File(image.path);
          }
        });

        HapticFeedback.lightImpact();
      }
    } catch (e) {
      _showErrorSnackBar('Failed to pick image: $e');
    }
  }

  void _showImageSourceDialog(bool isPerson) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF1a1a2e),
                Color(0xFF16213e),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Select Image Source',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 24),
              _buildImageSourceOption(
                icon: Icons.camera_alt_rounded,
                title: 'Camera',
                subtitle: 'Take a photo',
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera, isPerson);
                },
              ),
              SizedBox(height: 16),
              _buildImageSourceOption(
                icon: Icons.photo_library_rounded,
                title: 'Gallery',
                subtitle: 'Choose from gallery',
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery, isPerson);
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImageSourceOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.1),
                Colors.white.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white.withOpacity(0.4),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(16),
      ),
    );
  }

  Future<void> _generateTryOn() async {
    if (personImage == null || garmentImage == null) {
      _showErrorSnackBar('Please upload both person and garment images');
      return;
    }

    setState(() {
      isProcessing = true;
      progress = 0.0;
    });

    HapticFeedback.mediumImpact();

    // Simulate processing with progress
    for (int i = 0; i <= 100; i += 2) {
      await Future.delayed(Duration(milliseconds: 50));
      if (mounted) {
        setState(() {
          progress = i / 100;
        });
      }
    }

    // Simulate result (in real app, this would be the API call result)
    await Future.delayed(Duration(milliseconds: 500));

    setState(() {
      isProcessing = false;
      resultImage = personImage; // Placeholder - replace with actual result
    });

    HapticFeedback.lightImpact();
  }

  Widget _buildFloatingElements() {
    return AnimatedBuilder(
      animation: _floatingController,
      builder: (context, child) {
        return Stack(
          children: [
            _buildFloatingIcon('👔', 0.1, 0.2, 0.0),
            _buildFloatingIcon('👖', 0.8, 0.15, 0.3),
            _buildFloatingIcon('👟', 0.2, 0.7, 0.6),
            _buildFloatingIcon('⌚', 0.85, 0.8, 0.9),
            _buildFloatingIcon('👗', 0.1, 0.5, 0.4),
            _buildFloatingIcon('👠', 0.9, 0.4, 0.7),
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
          opacity: 0.2,
          child: Text(
            icon,
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0a0a0a),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black.withOpacity(0.2),
        centerTitle: true,
        title: ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds);
          },
          child: Text(
            'Virtual Try-On',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Stack(
        children: [
          _buildBackgroundGradient(),
          _buildFloatingElements(),
          _buildMainContent(),
        ],
      ),
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

  Widget _buildMainContent() {
    return SafeArea(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(height: 20),
                _buildHeader(),
                SizedBox(height: 30),
                _buildStepsRow(),
                SizedBox(height: 30),
                if (isProcessing) _buildProcessingSection(),
                if (resultImage != null && !isProcessing) _buildResultSection(),
                SizedBox(height: 20),
                _buildGenerateButton(),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
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
        boxShadow: [
          BoxShadow(
            color: Color(0xFF667eea).withOpacity(0.2),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.auto_awesome_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'AI-Powered Virtual Try-On',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            'Upload your photo and garment to see how it looks on you',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStepsRow() {
    return Row(
      children: [
        Expanded(child: _buildStepCard(1, 'Upload Person', personImage, true)),
        SizedBox(width: 16),
        Expanded(
            child: _buildStepCard(2, 'Upload Garment', garmentImage, false)),
      ],
    );
  }

  Widget _buildStepCard(int step, String title, File? image, bool isPerson) {
    bool hasImage = image != null;

    return GestureDetector(
      onTap: () => _showImageSourceDialog(isPerson),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        height: 300,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: hasImage
                ? [
                    Color(0xFF667eea).withOpacity(0.2),
                    Color(0xFF764ba2).withOpacity(0.1),
                  ]
                : [
                    Colors.white.withOpacity(0.1),
                    Colors.white.withOpacity(0.05),
                  ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: hasImage
                ? Color(0xFF667eea).withOpacity(0.3)
                : Colors.white.withOpacity(0.1),
            width: hasImage ? 2 : 1,
          ),
          boxShadow: hasImage
              ? [
                  BoxShadow(
                    color: Color(0xFF667eea).withOpacity(0.2),
                    blurRadius: 15,
                    offset: Offset(0, 8),
                  ),
                ]
              : [],
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      gradient: hasImage
                          ? LinearGradient(
                              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                            )
                          : null,
                      color: hasImage ? null : Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(
                        step.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: hasImage
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          image!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isPerson ? Icons.person_rounded : Icons.checkroom_rounded,
                            size: 48,
                            color: Colors.white.withOpacity(0.4),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Tap to upload',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProcessingSection() {
    return ScaleTransition(
      scale: _pulseAnimation,
      child: Container(
        padding: EdgeInsets.all(24),
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
              color: Color(0xFF667eea).withOpacity(0.2),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              Icons.auto_awesome_rounded,
              color: Color(0xFF667eea),
              size: 32,
            ),
            SizedBox(height: 16),
            Text(
              'Generating Your Try-On...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Stack(
              children: [
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: progress,
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              '${(progress * 100).toInt()}%',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF667eea),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultSection() {
    return Container(
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
        boxShadow: [
          BoxShadow(
            color: Color(0xFF667eea).withOpacity(0.2),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Your Virtual Try-On Result',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.file(
              resultImage!,
              height: 300,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                  },
                  icon: Icon(Icons.save_alt_rounded),
                  label: Text('Save'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.1),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: BorderSide(color: Colors.white.withOpacity(0.2)),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                    },
                    icon: Icon(Icons.share_rounded),
                    label: Text('Share'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGenerateButton() {
    bool canGenerate =
        personImage != null && garmentImage != null && !isProcessing;

    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: canGenerate
            ? LinearGradient(
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              )
            : null,
        color: canGenerate ? null : Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        boxShadow: canGenerate
            ? [
                BoxShadow(
                  color: Color(0xFF667eea).withOpacity(0.4),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ]
            : [],
      ),
      child: ElevatedButton(
        onPressed: canGenerate ? _generateTryOn : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: isProcessing
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Processing...',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            : Text(
                'Generate Virtual Try-On',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
/////////////////////////////// If we are using a separate AR feature page with image upload functionality /////////////////////////
