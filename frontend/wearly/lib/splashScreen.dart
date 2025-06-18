// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:wearly/homeScreen.dart';
// import 'package:wearly/scanner_page.dart';

// class WearlySplashScreen extends StatefulWidget {
//   const WearlySplashScreen({super.key});

//   @override
//   State<WearlySplashScreen> createState() => _WearlySplashScreenState();
// }

// class _WearlySplashScreenState extends State<WearlySplashScreen>
//     with TickerProviderStateMixin {
//   late AnimationController _logoController;
//   late AnimationController _textController;
//   late AnimationController _backgroundController;
//   late AnimationController _particleController;

//   late Animation<double> _logoScaleAnimation;
//   late Animation<double> _logoOpacityAnimation;
//   late Animation<double> _textOpacityAnimation;
//   late Animation<Offset> _textSlideAnimation;
//   late Animation<double> _backgroundAnimation;

//   @override
//   void initState() {
//     super.initState();
    
//     // Set status bar to transparent
//     SystemChrome.setSystemUIOverlayStyle(
//       const SystemUiOverlayStyle(
//         statusBarColor: Colors.transparent,
//         statusBarIconBrightness: Brightness.light,
//       ),
//     );

//     _initializeAnimations();
//     _startAnimationSequence();
//   }

//   void _initializeAnimations() {
//     // Logo animations
//     _logoController = AnimationController(
//       duration: const Duration(milliseconds: 1200),
//       vsync: this,
//     );

//     // Text animations
//     _textController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );

//     // Background animations
//     _backgroundController = AnimationController(
//       duration: const Duration(milliseconds: 2000),
//       vsync: this,
//     );

//     // Particle animation
//     _particleController = AnimationController(
//       duration: const Duration(milliseconds: 3000),
//       vsync: this,
//     )..repeat();

//     // Logo scale with bounce effect
//     _logoScaleAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _logoController,
//       curve: Curves.elasticOut,
//     ));

//     // Logo opacity
//     _logoOpacityAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _logoController,
//       curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
//     ));

//     // Text animations
//     _textOpacityAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _textController,
//       curve: Curves.easeIn,
//     ));

//     _textSlideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.5),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _textController,
//       curve: Curves.easeOutCubic,
//     ));

//     // Background gradient animation
//     _backgroundAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _backgroundController,
//       curve: Curves.easeInOut,
//     ));
//   }

//   void _startAnimationSequence() async {
//     // Start background animation
//     _backgroundController.forward();
    
//     // Start logo animation after a brief delay
//     await Future.delayed(const Duration(milliseconds: 300));
//     _logoController.forward();
    
//     // Start text animation
//     await Future.delayed(const Duration(milliseconds: 600));
//     _textController.forward();
    
//     // Navigate to main app after splash duration
//     await Future.delayed(const Duration(milliseconds: 2500));
//     _navigateToMain();
//   }

//   void _navigateToMain() {
//     // Replace with your main app navigation
//     Navigator.of(context).pushReplacement(
//       MaterialPageRoute(builder: (context) => HomeScreen()),
//     );
//   }

//   @override
//   void dispose() {
//     _logoController.dispose();
//     _textController.dispose();
//     _backgroundController.dispose();
//     _particleController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
    
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Animated gradient background
//           AnimatedBuilder(
//             animation: _backgroundAnimation,
//             builder: (context, child) {
//               return Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: [
//                       Color.lerp(
//                         const Color(0xFF1a1a1a),
//                         const Color(0xFF2d2d2d),
//                         _backgroundAnimation.value,
//                       )!,
//                       Color.lerp(
//                         const Color(0xFF000000),
//                         const Color(0xFF1a1a1a),
//                         _backgroundAnimation.value,
//                       )!,
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),

//           // Floating particles
//           AnimatedBuilder(
//             animation: _particleController,
//             builder: (context, child) {
//               return CustomPaint(
//                 painter: ParticlePainter(_particleController.value),
//                 size: Size(size.width, size.height),
//               );
//             },
//           ),

//           // Main content
//           Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // Logo with animations
//                 AnimatedBuilder(
//                   animation: _logoController,
//                   builder: (context, child) {
//                     return Transform.scale(
//                       scale: _logoScaleAnimation.value,
//                       child: Opacity(
//                         opacity: _logoOpacityAnimation.value,
//                         child: Container(
//                           width: 120,
//                           height: 120,
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(20),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.white.withOpacity(0.3),
//                                 blurRadius: 20,
//                                 spreadRadius: 5,
//                               ),
//                             ],
//                           ),
//                           child: const Center(
//                             child: Text(
//                               'W',
//                               style: TextStyle(
//                                 fontSize: 48,
//                                 fontWeight: FontWeight.bold,
//                                 color: Color(0xFF1a1a1a),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),

//                 const SizedBox(height: 40),

//                 // App name with slide animation
//                 AnimatedBuilder(
//                   animation: _textController,
//                   builder: (context, child) {
//                     return SlideTransition(
//                       position: _textSlideAnimation,
//                       child: FadeTransition(
//                         opacity: _textOpacityAnimation,
//                         child: Column(
//                           children: [
//                             const Text(
//                               'WEARLY',
//                               style: TextStyle(
//                                 fontSize: 36,
//                                 fontWeight: FontWeight.w300,
//                                 color: Colors.white,
//                                 letterSpacing: 8,
//                               ),
//                             ),
//                             const SizedBox(height: 12),
//                             Container(
//                               width: 60,
//                               height: 2,
//                               decoration: BoxDecoration(
//                                 gradient: const LinearGradient(
//                                   colors: [
//                                     Colors.transparent,
//                                     Colors.white,
//                                     Colors.transparent,
//                                   ],
//                                 ),
//                                 borderRadius: BorderRadius.circular(1),
//                               ),
//                             ),
//                             const SizedBox(height: 16),
//                             const Text(
//                               'Smart Wardrobe Assistant',
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w400,
//                                 color: Colors.white70,
//                                 letterSpacing: 1.5,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),

//                 const SizedBox(height: 80),

//                 // Loading indicator
//                 AnimatedBuilder(
//                   animation: _textController,
//                   builder: (context, child) {
//                     return FadeTransition(
//                       opacity: _textOpacityAnimation,
//                       child: SizedBox(
//                         width: 40,
//                         height: 40,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2,
//                           valueColor: AlwaysStoppedAnimation<Color>(
//                             Colors.white.withOpacity(0.7),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),

//           // Bottom tagline
//           Positioned(
//             bottom: 60,
//             left: 0,
//             right: 0,
//             child: AnimatedBuilder(
//               animation: _textController,
//               builder: (context, child) {
//                 return FadeTransition(
//                   opacity: _textOpacityAnimation,
//                   child: const Center(
//                     child: Text(
//                       'Solving your daily wardrobe dilemma',
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.white54,
//                         letterSpacing: 1,
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Custom painter for floating particles
// class ParticlePainter extends CustomPainter {
//   final double animationValue;

//   ParticlePainter(this.animationValue);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.white.withOpacity(0.1)
//       ..style = PaintingStyle.fill;

//     // Create floating particles
//     for (int i = 0; i < 50; i++) {
//       final x = (size.width * 0.1 + (i * 13.7) % size.width);
//       final y = (size.height * 0.1 + 
//           (i * 17.3 + animationValue * size.height * 0.5) % size.height);
      
//       final radius = (2 + (i % 3));
      
//       canvas.drawCircle(
//         Offset(x, y),
//         radius as double,
//         paint,
//       );
//     }
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => true;
// }


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wearly/homeScreen.dart';
import 'package:wearly/scanner_page.dart';

class WearlySplashScreen extends StatefulWidget {
  const WearlySplashScreen({super.key});

  @override
  State<WearlySplashScreen> createState() => _WearlySplashScreenState();
}

class _WearlySplashScreenState extends State<WearlySplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _backgroundController;
  late AnimationController _particleController;
  late AnimationController _buttonController;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _buttonOpacityAnimation;
  late Animation<Offset> _buttonSlideAnimation;

  @override
  void initState() {
    super.initState();
    
    // Set status bar to transparent
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    _initializeAnimations();
    _startAnimationSequence();
  }

  void _initializeAnimations() {
    // Logo animations
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Text animations
    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Background animations
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Particle animation
    _particleController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat();

    // Button animation
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Logo scale with bounce effect
    _logoScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    // Logo opacity
    _logoOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    // Text animations
    _textOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeIn,
    ));

    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOutCubic,
    ));

    // Background gradient animation
    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));

    // Button animations
    _buttonOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _buttonController,
      curve: Curves.easeIn,
    ));

    _buttonSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _buttonController,
      curve: Curves.easeOutCubic,
    ));
  }

  void _startAnimationSequence() async {
    // Start background animation
    _backgroundController.forward();
    
    // Start logo animation after a brief delay
    await Future.delayed(const Duration(milliseconds: 300));
    _logoController.forward();
    
    // Start text animation
    await Future.delayed(const Duration(milliseconds: 600));
    _textController.forward();
    
    // Start button animation
    await Future.delayed(const Duration(milliseconds: 400));
    _buttonController.forward();
  }

  void _navigateToMain() {
    // Replace with your main app navigation
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _backgroundController.dispose();
    _particleController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      body: Stack(
        children: [
          // Animated gradient background
          AnimatedBuilder(
            animation: _backgroundAnimation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.lerp(
                        const Color(0xFF1a1a1a),
                        const Color(0xFF2d2d2d),
                        _backgroundAnimation.value,
                      )!,
                      Color.lerp(
                        const Color(0xFF000000),
                        const Color(0xFF1a1a1a),
                        _backgroundAnimation.value,
                      )!,
                    ],
                  ),
                ),
              );
            },
          ),

          // Floating particles
          AnimatedBuilder(
            animation: _particleController,
            builder: (context, child) {
              return CustomPaint(
                painter: ParticlePainter(_particleController.value),
                size: Size(size.width, size.height),
              );
            },
          ),

          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo with animations
                AnimatedBuilder(
                  animation: _logoController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _logoScaleAnimation.value,
                      child: Opacity(
                        opacity: _logoOpacityAnimation.value,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              'W',
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1a1a1a),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40),

                // App name with slide animation
                AnimatedBuilder(
                  animation: _textController,
                  builder: (context, child) {
                    return SlideTransition(
                      position: _textSlideAnimation,
                      child: FadeTransition(
                        opacity: _textOpacityAnimation,
                        child: Column(
                          children: [
                            const Text(
                              'WEARLY',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w300,
                                color: Colors.white,
                                letterSpacing: 8,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              width: 60,
                              height: 2,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    Colors.white,
                                    Colors.transparent,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(1),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Smart Wardrobe Assistant',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.white70,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 80),

                // Get Started Button
                AnimatedBuilder(
                  animation: _buttonController,
                  builder: (context, child) {
                    return SlideTransition(
                      position: _buttonSlideAnimation,
                      child: FadeTransition(
                        opacity: _buttonOpacityAnimation,
                        child: Container(
                          width: 200,
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Colors.white,
                                Color(0xFFF0F0F0),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.2),
                                blurRadius: 15,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(25),
                              onTap: _navigateToMain,
                              child: const Center(
                                child: Text(
                                  'Get Started',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1a1a1a),
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Bottom tagline
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _textController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _textOpacityAnimation,
                  child: const Center(
                    child: Text(
                      'Solving your daily wardrobe dilemma',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white54,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for floating particles
class ParticlePainter extends CustomPainter {
  final double animationValue;

  ParticlePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    // Create floating particles
    for (int i = 0; i < 50; i++) {
      final x = (size.width * 0.1 + (i * 13.7) % size.width);
      final y = (size.height * 0.1 + 
          (i * 17.3 + animationValue * size.height * 0.5) % size.height);
      
      final radius = (2 + (i % 3));
      
      canvas.drawCircle(
        Offset(x, y),
        radius as double,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}